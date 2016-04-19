require 'models/blueprints/devices'
Dev::Sensors.device_type 'MB500' do
    provides Dev::Sensors::GPS
end

class OroGen::Gps::BaseTask
    def configure
        super

        if Conf.utm_local_origin?
            orocos_task.origin = Conf.utm_local_origin
        end
    end
end

class OroGen::Gps::MB500Task
    driver_for Dev::Sensors::MB500, :as => 'driver'
end

class OroGen::Gps::GPSDTask
    driver_for Dev::Sensors::GPS, :as => 'driver'
end
