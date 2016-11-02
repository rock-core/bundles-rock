require 'models/blueprints/devices'
require 'rock/models/blueprints/control'

class ServoDynamixel::Task
    driver_for Dev::Actuators::Dynamixel, :as => 'driver'
    provides Base::JointsControlledSystemSrv, as: 'joints_controlled_system'

    orogen_model.find_port('command').multiplexes

    transformer do
        frames "lower", "upper"
        transform_output "transforms", "lower" => "upper"
    end
end
