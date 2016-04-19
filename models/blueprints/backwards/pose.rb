Syskit.warn "The services from the Base:: module that were defined in models/blueprints/pose are now defined under models/services/, and have been renamed to match the new Syskit naming conventions"
module Base
    backward_compatible_constant :PositionSrv         , "Rock::Services::Position"         , 'rock/models/services/position'
    backward_compatible_constant :RotationSrv         , "Rock::Services::Rotation"         , 'rock/models/services/rotation'
    backward_compatible_constant :OrientationSrv      , "Rock::Services::Orientation"      , 'rock/models/services/orientation'
    backward_compatible_constant :ZProviderSrv        , "Rock::Services::ZProvider"        , 'rock/models/services/z_provider'
    backward_compatible_constant :OrientationWithZSrv , "Rock::Services::OrientationWithZ" , 'rock/models/services/orientation_with_z'
    backward_compatible_constant :PoseSrv             , "Rock::Services::Pose"             , 'rock/models/services/pose'
    backward_compatible_constant :TransformationSrv   , "Rock::Services::Transformation"   , 'rock/models/services/transformation'
    backward_compatible_constant :GlobalPoseSrv       , "Rock::Services::GlobalPose"       , 'rock/models/services/global_pose'
    backward_compatible_constant :RelativePoseSrv     , "Rock::Services::RelativePose"     , 'rock/models/services/relative_pose'
    backward_compatible_constant :PoseDeltaSrv        , "Rock::Services::PoseDelta"        , 'rock/models/services/pose_delta'
    backward_compatible_constant :VelocitySrv         , "Rock::Services::Velocity"         , 'rock/models/services/velocity'
    backward_compatible_constant :GroundDistanceSrv   , "Rock::Services::GroundDistance"   , 'rock/models/services/ground_distance'
end
