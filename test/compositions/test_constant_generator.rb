require 'models/compositions/constant_generator'
module Rock
    module Compositions
        describe ConstantGenerator do
            attr_reader :srv_m, :generator_m

            before do
                @srv_m = Syskit::DataService.new_submodel do
                    output_port 'out', 'double'
                end
                @generator_m = ConstantGenerator.for(srv_m)
            end

            describe "defined from a data service" do
                it "constantly writes data to its output port" do
                    stub_syskit_deployment_model(generator_m, 'task')
                    generator = syskit_run_deployer(generator_m.with_arguments('values' => Hash['out' => 10]))
                    syskit_start_component(generator)
                    sample = assert_has_one_new_sample(generator.out_port)
                    assert_in_delta sample, 10, 0.01
                end
                it "returns the same component over and over again" do
                    assert_same generator_m, ConstantGenerator.for(srv_m)
                end
            end

            it "validates that the keys in 'values' are actual port names" do
                stub_syskit_deployment_model(generator_m, 'task')
                assert_raises(ArgumentError) do
                    generator_m.with_arguments('values' => Hash['bla' => 10]).
                        instanciate(plan)
                end
            end
        end
    end
end

