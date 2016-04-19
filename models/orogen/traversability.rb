class OroGen::Traversability::Grassfire
    transformer do
        associate_frame_to_ports 'world', 'mls_map', 'traversability_map'
    end

    event :start do |context|
        if !orocos_task.env_save_path.empty?
            # Make sure that the directory exists
            FileUtils.mkdir_p(File.expand_path(orocos_task.env_save_path, Roby.app.log_dir))
        end

        super(context)
    end
end
