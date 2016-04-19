class OroGen::CorridorNavigation::ServoingTask
    argument :initial_heading, :default => nil

    # Data writer connected to the heading port of the corridor servoing task
    attr_reader :direction_writer

    # Additional information for the transformer's automatic configuration
    transformer do
        associate_frame_to_ports 'odometry', 'trajectory', 'debugVfhTree'
        #transform_input 'odometry_samples', 'body' => 'odometry'
    end

    on :start do |event|
        if initial_heading
            @direction_writer = heading_port.writer
            @direction_writer.write(initial_heading)
            Robot.info "corridor_servoing: initial heading=#{initial_heading * 180 / Math::PI}deg"
        end
    end
end

class OroGen::CorridorNavigation::FollowingTask
    # Additional information for the transformer's automatic configuration
    transformer do
        transform_input "pose_samples", "body" => "world"
        associate_frame_to_ports "world", "trajectory"
    end
end
