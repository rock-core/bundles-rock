require 'models/blueprints/map_gen/map_generator_srv'

class OroGen::Envire::SynchronizationTransmitter
    argument :initial_map

    provides Rock::MapGen::OneShotSrv, :as => 'one_shot'

    on :start do |event|
        if !File.directory?(initial_map)
            raise ArgumentError, "Envire::SynchronizationTransmitter -- cannot load initial environment. File '#{initial_map}' does not exist"
        else
            Robot.info "Envire::SynchronizationTransmitter -- loading initial environment from '#{initial_map}'"
            orocos_task.loadEnvironment(initial_map)
        end
    end

    provides Rock::MapGen::MLSSrv, :as => 'mls'
end
