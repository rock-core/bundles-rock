using_task_library "fog_kvh"
require 'models/blueprints/sensors'

module Dev
    module Sensors
        module KVH 
            device_type 'DSP3000' do
                provides Base::RotationSrv
            end
        end
    end
end

class FogKvh::Dsp3000Task
  driver_for Dev::Sensors::KVH::DSP3000, :as => 'driver'
end
