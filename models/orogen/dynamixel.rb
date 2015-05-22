module Dev
    module Actuators
        device_type 'Dynamixel'
    end
end

class Dynamixel::Task
    driver_for Dev::Actuators::Dynamixel, :as => 'driver'
    provides Base::TransformationSrv, :as => 'transform',
	'transformation' => 'lowerDynamixel2UpperDynamixel'

    # Add some more information for the transformer configuration
    transformer do
        frames "lower", "upper"
        transform_output "lowerDynamixel2UpperDynamixel", "lower" => "upper"
    end

    on :start do |event|
        if Conf.initial_dynamixel_position? && orogen_task.mode == :POSITION
            orogen_task.setAngle(Conf.initial_dynamixel_position)
        end
    end
end

