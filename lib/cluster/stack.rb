module Cluster
  class Stack < Base
    include Waiters
    # Returns a list of all stacks in the credentialled AWS account.
    # The list is composed of Aws::OpsWorks::Stack instances.
    def self.all
      stacks = []
      opsworks_client.describe_stacks.inject([]){ |memo, page| memo + page.stacks }.each do |stack|
        stacks << construct_instance(stack.stack_id)
      end
      stacks
    end

    def self.delete
      stack = find_existing
      if stack
        stack.delete
      end
    end

    def self.stop_all
      instance_ids = []
      with_existing_stack do |stack|
        instance_ids = Cluster::Instances.find_existing.map(&:instance_id)
        opsworks_client.stop_stack(stack_id: stack.stack_id)
      end
      if instance_ids.any?
        wait_until_opsworks_instances_stopped(instance_ids)
      end
    end

    def self.start_all
      instance_ids = []
      with_existing_stack do |stack|
        instance_ids = Cluster::Instances.find_existing.map(&:instance_id)
        opsworks_client.start_stack(stack_id: stack.stack_id)
      end
      if instance_ids.any?
        wait_until_opsworks_instances_started(instance_ids)
      end
    end

    def self.find_existing
      vpc = VPC.find_existing
      find_existing_in(vpc)
    end

    def self.with_existing_stack
      stack = Cluster::Stack.find_existing
      raise Cluster::StackNotInitialized if ! stack

      yield stack if block_given?
      stack
    end

    # Returns a Aws::OpsWorks::Stack instance according to the active cluster
    # configuration If it does not exist, it creates it within your configured
    # VPC.
    def self.find_or_create
      vpc = VPC.find_or_create

      stack = find_existing_in(vpc)
      return construct_instance(stack.stack_id) if stack

      service_role = ServiceRole.find_or_create
      instance_profile = InstanceProfile.find_or_create

      parameters = {
        name: stack_config[:name],
        region: root_config[:region],
        vpc_id: vpc.vpc_id,
        configuration_manager: {
          name: 'Chef',
          version: '11.10'
        },
        use_custom_cookbooks: true,
        custom_cookbooks_source: stack_chef_config.fetch(:custom_cookbooks_source, {}),
        chef_configuration: {
          manage_berkshelf: true,
          berkshelf_version: '3.2.0'
        },
        custom_json: json_encode(
          stack_custom_json
        ),
        default_os: 'Ubuntu 14.04 LTS',
        service_role_arn: service_role.arn,
        default_instance_profile_arn: instance_profile.arn,
        default_subnet_id: vpc.subnets.first.id,
        default_root_device_type: stack_config.fetch(:default_root_device_type, 'ebs'),
        default_ssh_key_name: stack_config.fetch(:default_ssh_key_name, '')
      }

      stack = create_stack(parameters)

      User.reset_stack_user_permissions_for(stack.stack_id)

      construct_instance(stack.stack_id)
    end

    def self.find_existing_in(vpc)
      all.find do |stack|
        (stack.name == stack_config[:name]) &&
          (stack.vpc_id == vpc.vpc_id)
      end
    end

    private

    def self.create_stack(parameters)
      stack = nil
      loop do
        stack =
          begin
            opsworks_client.create_stack(
              parameters
            )
          rescue => e
            puts e.inspect
            sleep 10
            puts 'retrying stack creation'
            nil
          end
        break if stack != nil
      end
      stack
    end

    def self.construct_instance(stack_id)
      Aws::OpsWorks::Stack.new(stack_id, client: opsworks_client)
    end
  end
end
