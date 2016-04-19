Roby.app.using 'syskit'
Roby.app.auto_load_models = false

require 'roby/schedulers/temporal'
Roby.scheduler = Roby::Schedulers::Temporal.new

## Uncomment to enable automatic transformer configuration support
Syskit.conf.transformer_enabled = true
Syskit.conf.backward_compatible_naming = true


# Syskit.conf.redirect_local_process_server = false
