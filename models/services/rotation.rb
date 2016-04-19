import_types_from 'base'

module Rock
    module Services
        data_service_type 'Rotation' do
            output_port 'rotation_samples', '/base/samples/RigidBodyState'
        end
    end
end
