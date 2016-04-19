module Base
    autoload :ControllerSrv, 'models/blueprints/backwards/control'
    autoload :ControlledSystemSrvSrv, 'models/blueprints/backwards/control'
    autoload :ControlLoop, 'models/blueprints/backwards/control'

    autoload :ActuatorControlledSystemSrv, 'models/blueprints/backwards/control'
    autoload :ActuatorControllerSrv, 'models/blueprints/backwards/control'
    autoload :ActuatorStatusSrv, 'models/blueprints/backwards/control'
    autoload :ActuatorCommandSrv, 'models/blueprints/backwards/control'
    autoload :ActuatorCommandConsumerSrv, 'models/blueprints/backwards/control'

    autoload :JointsControlledSystemSrv, 'models/blueprints/backwards/control'
    autoload :JointsControllerSrv, 'models/blueprints/backwards/control'
    autoload :JointsStatusSrv, 'models/blueprints/backwards/control'
    autoload :JointsCommandSrv, 'models/blueprints/backwards/control'
    autoload :JointsCommandConsumerSrv, 'models/blueprints/backwards/control'

    autoload :Motion2DControlledSystemSrv, 'models/blueprints/backwards/control'
    autoload :Motion2DControllerSrv, 'models/blueprints/backwards/control'
    autoload :Motion2DStatusSrv, 'models/blueprints/backwards/control'
    autoload :Motion2DCommandSrv, 'models/blueprints/backwards/control'
    autoload :Motion2DCommandConsumerSrv, 'models/blueprints/backwards/control'
end

