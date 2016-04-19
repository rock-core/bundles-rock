class OroGen::Stereo::Task
    # Additional information to allow for the transformer's automatic
    # configuration
    transformer do
        associate_frame_to_ports 'left_camera', 'distance_frame'
    end
end

