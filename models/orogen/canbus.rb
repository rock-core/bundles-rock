require 'models/blueprints/devices'

Dev::Bus.com_bus_type 'CAN', :message_type => '/canbus/Message' do
    worstcase_processing_time 0.2 
    extend_attached_device_configuration do
        dsl_attribute :can_id do |id, mask|
            mask ||= id
            id   = Integer(id)
            mask = Integer(mask)
            if (id & mask) != id
                raise ArgumentError, "wrong id/mask combination: some bits in the ID are not set in the mask, and therefore the filter will never match"
            end
            [id, mask]
        end
    end
end

class OroGen::Canbus::Task
    driver_for Dev::Bus::CAN, :as => 'driver'

    # This declares that all devices attached to this bus should use the 'in'
    # port of the component. Otherwise, syskit will assume that a new dynamic
    # input port should be created
    provides Dev::Bus::CAN::BusInSrv, :as => 'to_bus'

    def configure
        super
        bus_name = self.driver_dev.name #self.canbus_name
        each_declared_attached_device do |dev|
            can_id, can_mask = dev.can_id
            if !dev.can_id
                raise ArgumentError, "No can id/mask given for #{dev}" 
            end
            name = dev.name
            Robot.info "#{bus_name}: watching #{name} on 0x#{can_id.to_s.to_i(16)}/#{can_mask.to_s.to_i(16)}"
            orocos_task.watch(name, can_id, can_mask)
        end
    end
end

