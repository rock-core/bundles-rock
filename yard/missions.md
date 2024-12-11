# Missions

The missions are the high-level (read: UI-oriented) interface to the system. There
can be only one mission active at any given time.

The REST API that allows to manipulate them is currently defined in `bundles/wetpaint`,
in `Wetpaint::REST::MissionAPI` and `Wetpaint::REST::MissionHelpers`. This package
defines the lower level elements on top of which the missions are built.

The core of the mission system is to offer a JSON representation for missions, and
a mean to both represent them before they are executed, and to instanciate them
through the action system.

The available endpoints are described in the list below. They are defined relatively
to where `Wetpaint::REST::MissionAPI` is mounted, which is
`signalk/v1/api/resources/mission` in the Wetpaint system. Each endpoint is
detailed in separate sections.

| Endpoint               | Description                                            |
| --------               | ------------------------------------                   |
| POST /                  | [Create a new mission](#creating-a-new-mission)                        |
| GET /:mission_id       | [Query information about a created mission](#inspecting-an-existing-mission)      |
| PUT /:mission_id/state | [Change a mission's state](#changing-a-mission-state)                 |

## Workflow

Missions must first be [created](#create). Once created, they can be
[queried](#get) or their [state modified](#changing-a-mission-state). Missions are
one-use-only, i.e. once running and/or finished they cannot be restarted (but an
identical mission can easily be created by querying the mission parameters and
creating a new one)

## Error Handling

On error, the endpoints will return an appropriate HTML error code (documented for each
endpoint) as well as a JSON object with appropriate information.

## Creating a new mission

### Endpoint

`POST /`

### Arguments

| Argument | Type   | Description                                           |
| -------- | ----   | -----------                                           |
| type     | string | The type of the mission being created                 |
| *        |        | Other arguments are specific to the mission type, see [existing mission types](#mission-types) |

### Return Value

| Field | Type | Description |
| ----- | ---- | ----------- |
| missionId | string | The mission ID |

### Errors

| Description                                              | Code | Error Object |
| -----------                                              | ---- | ------------ |
| type is not an existing mission type | 400  | { "error": { "message": "invalid mission type 'TYPE'" }}
| the fields do not match the required/optional fields from the mission type | 400  | { "error": { "message": "description of the error" }}

### Example

`POST /` with arguments `{ "type": "transit", "routeId": "some-id" }` returns `{ missionId: "the-mission-id" }`

### Detailed Description

A mission has first to be created with a POST to the root of the MissionAPI
(mounted under in the Wetpaint system). The only required argument is the
`type` argument, which defines how the rest of the arguments will be
interpreted. The endpoint returns the new mission's ID, which is an arbitrary
string that allows to refer to the mission in the rest of the API

The API calls `Seabots::Missions.from_json` that resolves the mission class
using the `type` argument. The type-to-class mapping is done using the
`Seabots::Missions::MISSION_TYPE_TO_CLASS` hash. `Missions.to_json` then
delegates to the `#to_json` method of the instance of the new class.

After creation, the mission instance is store internally but not yet added
to the system's running plan

## Inspecting an existing mission {#get}

### Endpoint

`GET /:mission_id`

### Arguments

| Name | Type   | Description                                           |
| -------- | ----   | -----------                                           |
| mission_id | string | The ID of the mission, as returned on creation      |

### Return Value

| Field | Type   | Description                                           |
| -------- | ----   | -----------                                           |
| missionId | string | The ID of the mission, as returned on creation      |
| state | string | The mission state (see [the list of mission states](#mission-states))  |
| * |    | The mission parameters, identical to the ones given to {#create}. They are type-specific, see [the existing mission types](#mission-types) for more information |

### Detailed description

The endpoint returns a JSON document of the same format than the one used for
creation, augmented with mission ID and state information.

## Changing a mission state

### Endpoint

`PUT /:mission_id/state`

### Arguments

| Name | Type   | Description                                           |
| -------- | ----   | -----------                                           |
| mission_id | string | The ID of the mission, as returned on creation      |
| value.target | string | `running` or `terminated` |

### Return Value

This endpoint does not return anything

### Errors

| Description                                              | Code | Error Object |
| -----------                                              | ---- | ------------ |
| value.target is `running` but the mission has already finished  | 400  | { "error": { "message": "mission has been started but finished or was aborted" }}
| value.target is `stopped` but the mission is neither active nor running | 400  | { "error": { "message": "mission has been started but finished or was aborted" }}
| value.target is invalid | 400  | { "error": { "message": "invalid target state" }}

### Detailed Description

This endpoint allows to change the [mission's state](#mission-states). A created
mission that has never been started can be started by calling it with the
`running` target. An active or running mission can be terminated with
`terminated`

The endpoint is idempotent. One can call with a `running` target while in
`active` or `running` state, or `terminated` on a finished mission.

Making a mission active will automatically terminate any other active mission.

## Existing Mission Types

### Transit

The transit mission represents a route following behavior. The route has to be
created and the trajectory planned separately using the relevant APIs.

The transit mission requires the following parameters:

| Field | Description |
| ----- | ----------- |
| routeId | The ID of a planned route |
### Survey

The survey mission represents following a route for the purpose of survey. The
route has to be created and the trajectory planned separately using the relevant
APIs.

| Field | Description |
| ----- | ----------- |
| routeId | The ID of a planned route |

## Mission States

| Name | Description |
| ---- | ----------- |
| pending | Created but never started |
| active | Present in plan, but not yet running |
| running | Running |
| success | Finished successfully |
| failed | Finished unsuccessfully |
| aborted | Terminated while in `active` state (i.e. before it got even started) |
| unknown | Invalid state (should never happen) |

## Creating new mission types

To create a new mission type, one has to create:

- a mission class (see below)
- a JSON schema for the mission representation in JSON
- an action that returns an instance of this type's mission
- register the mission class on `Seabots::Missions::MISSION_TYPE_TO_CLASS`

Mission classes are subclasses of Seabots::Tasks::Missions::Base. The subclass
**must** overload the following methods, which are documented on
Seabots::Tasks::Missions::Base:

| Name               | Description |
| ------------------ | ----------- |
| self.from_json     | Create a new mission. Should ultimately call `create(action_interface, **action_arguments)`, where `action_arguments` will be passed to `instanciate` once the mission is activated. The JSON object MUST be validated using `JSON::Schema.validate!` from [json-schema](https://github.com/voxpupuli/json-schema). The REST API catches the validation error and returns an appropriate error code (400). Additional validation errors should raise `InvalidMissionJSON` |
| self.instanciate   | Create a runnable representation of the mission. This is usually done by calling a separately defined action on `action_interface`, as e.g. `action_interface.mission_usv_transit.as_plan(**action_arguments) |
| json_type | Return the type of the mission as string (e.g. "transit") |

Additionally, the `activate` instance method can be overloaded to modify action
arguments that need to be modified on activation. `USVTransit` for instance
sets the trajectory's reference time to `Time.now`
