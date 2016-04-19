import_types_from 'base'
require 'rock/models/services/control_loop'

Rock::Services::ControlLoop.declare \
    'Joints', '/base/commands/Joints', '/base/samples/Joints'

