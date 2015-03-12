module Cluster
  module Waiters
    module ClassMethods
      def wait_until_opsworks_instance_stopped(instance_id)
        opsworks_client.wait_until(
          :instance_stopped, instance_ids: [instance_id]
        ) do |w|
          w.before_wait do |attempts, response|
            puts "Stopping instance #{instance_id}, attempt ##{attempts}"
          end
        end

        yield if block_given?
      end

      def when_vpc_available(vpc_id)
        ec2_client.wait_until(:vpc_available, vpc_ids: [vpc_id]) do |w|
          w.before_wait do |attempts, response|
            puts "Checking if VPC available, attempt ##{attempts}"
          end
        end

        yield if block_given?
      end

      def wait_until_instance_profile_available(instance_profile_name)
        iam_client.wait_until(
          :instance_profile_available,
          instance_profile_name: instance_profile_name
        ) do |w|
          w.before_wait do |attempts, response|
            puts "Checking if instance profile #{instance_profile_name} available, attempt: ##{attempts}"
          end
        end

        yield if block_given?
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end