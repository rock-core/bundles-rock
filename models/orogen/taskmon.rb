class OroGen::Taskmon::Task
    attr_reader :query_tasks
    attr_reader :query_deployments

    def initialize(options = Hash.new)
        super

        @watched_deployments = Set.new
        @watched_tasks = Set.new
    end

    on :start do |event|
        @query_tasks = plan.find_tasks(Syskit::TaskContext).
            running
        @query_deployments = plan.find_tasks(Syskit::Deployment).
            running
    end

    poll do
        @query_tasks.reset
        tasks = @query_tasks.to_value_set
        new_tasks = (tasks - @watched_tasks)

        @query_deployments.reset
        deployments = @query_deployments.to_value_set
        new_deployments = (deployments - @watched_deployments)

        return if new_deployments.empty? && new_tasks.empty?
        orocos_task.add_watches(new_deployments.map(&:pid),
                                new_tasks.map(&:orocos_task))
        @watched_deployments = deployments
        @watched_tasks = tasks
    end
end

