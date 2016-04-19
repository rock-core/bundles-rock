require 'models/services/control_loop'

module Rock
    module Services
        describe ControlLoop do
            it "raises if the services are already declared" do
                type = stub_type '/Mock'
                ControlLoop.declare_open_loop 'Test', type
                assert_raises(ControlLoop::AlreadyDeclared) do
                    ControlLoop.declare_open_loop 'Test', type
                end
            end

            describe "open-loop control" do
                attr_reader :command_type
                before do
                    @command_type = stub_type '/Command'
                    ControlLoop.declare_open_loop 'Test', command_type
                end

                it "properly sets up the relationship between the open loop models and the root models" do
                    assert ControlLoop::TestOpenLoopController.provides?(ControlLoop::Controller)
                    assert ControlLoop::TestOpenLoopControlledSystem.provides?(ControlLoop::ControlledSystem)
                end
                it "creates ports that allow for an open-loop connection" do
                    assert_equal command_type, ControlLoop::TestOpenLoopController.command_out_port.type
                    assert_equal command_type, ControlLoop::TestOpenLoopControlledSystem.command_in_port.type
                    ControlLoop::TestOpenLoopController.command_out_port.can_connect_to?(ControlLoop::TestOpenLoopControlledSystem.command_in_port)
                end
            end

            describe "closed-loop control" do
                attr_reader :command_type, :status_type
                before do
                    @command_type = stub_type '/Command'
                    @status_type = stub_type '/Status'
                    ControlLoop.declare 'Test', command_type, status_type
                end

                it "sets up the relationship between the closed loop models and the root models" do
                    assert ControlLoop::TestController.provides?(ControlLoop::Controller)
                    assert ControlLoop::TestControlledSystem.provides?(ControlLoop::ControlledSystem)
                end
                it "sets up the relationship between the open and closed loop models" do
                    assert ControlLoop::TestController.provides?(ControlLoop::TestOpenLoopController)
                    assert ControlLoop::TestControlledSystem.provides?(ControlLoop::TestOpenLoopControlledSystem)
                end
                it "leaves the open-loop models untouched" do
                    assert !ControlLoop::TestOpenLoopController.has_port?(:status_in)
                    assert !ControlLoop::TestOpenLoopControlledSystem.has_port?(:status_out)
                end
                it "creates ports that allow for a feedback" do
                    assert_equal status_type, ControlLoop::TestController.status_in_port.type
                    assert_equal status_type, ControlLoop::TestControlledSystem.status_out_port.type
                    ControlLoop::TestControlledSystem.status_out_port.can_connect_to?(ControlLoop::TestController.status_in_port)
                end

                describe "controller_for" do
                    it "returns the generated controller model" do
                        assert_same ControlLoop::TestControlledSystem,
                            ControlLoop.controlled_system_for('Test')
                    end
                end
                describe "controlled_system_for" do
                    it "returns the generated controlled system model" do
                        assert_same ControlLoop::TestController,
                            ControlLoop.controller_for('Test')
                    end
                end
            end
        end
    end
end
