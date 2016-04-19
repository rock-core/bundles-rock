class OroGen::PoseEstimator::Task
    argument :initial_pose, :default => nil
    provides Srv::Pose

    find_output_port('pose_samples').
        triggered_on('odometry_delta_samples')

    transformer do
        # The IMU is NOT imu => world. The pose estimator is meant to correct a
        # yaw bias due to local magnetic disturbance, so the orientation coming
        # from the IMU and the orientation output by the pose estimator do not
        # match
        transform_input "orientation_samples", "imu" => "magnetic_world"

        # Now declare some other global estimators
        transform_input "position_samples",    "gps" => "world"
        transform_input "icp_pose_samples",    "icp" => "world"

        # The odometry is used as incremental values. They must give us the
        # change of pose of the body frame, so declare that
        associate_frame_to_ports "body", "odometry_delta_samples"

        # And declare the output frame
        transform_output "pose_samples", "body" => "world"
    end

    on :start do |event|
        return if !initial_pose

        yaw_bias = 0
        position_variance = Eigen::Vector3.new(0.09, 0.09, 0.09)
        yaw_variance  = (15 * Math::PI / 180) ** 2

        if initial_pose.respond_to?(:cov_position)
            vx, vy, vz = initial_pose.cov_position.data[0], initial_pose.cov_position.data[4], initial_pose.cov_position.data[8]
            position_variance = Eigen::Vector3.new(vx, vy, vz)
        end
        if initial_pose.respond_to?(:yaw_bias)
            yaw_bias = initial_pose.yaw_bias
        end
        if initial_pose.respond_to?(:cov_orientation)
            yaw_variance = initial_pose.cov_orientation.data[8]
        end
        orogen_task.set_position(initial_pose.position, position_variance, yaw_bias, yaw_variance)
    end
end

