require 'rock/models/services/control_loop'
import_types_from 'base'
Rock::Services::ControlLoop.declare \
    'Actuator', '/base/actuators/Command', '/base/actuators/Status'
