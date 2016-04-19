require 'models/blueprints/control'

using_task_library 'canbus'

module Dev
    module Controldev

        Base::ControlLoop.declare 'RawCommand', 'controldev/RawCommand'

        device_type 'Joystick' do
            provides Base::RawCommandControllerSrv
        end

        device_type 'Mouse3D' do
            provides Base::RawCommandControllerSrv
        end

    end
end

class OroGen::Controldev::JoystickTask
    driver_for Dev::Controldev::Joystick, :as => 'joystick'
end

class OroGen::Controldev::Mouse3DTask
    driver_for Dev::Controldev::Mouse3D, :as => 'mouse3d'
end

class OroGen::Controldev::Remote
    provides Dev::Bus::CAN::ClientInSrv, "from_bus" => "canInputDevice" ,:as => "can"
    driver_for Dev::Controldev::Joystick, :as => 'joystick'
end

