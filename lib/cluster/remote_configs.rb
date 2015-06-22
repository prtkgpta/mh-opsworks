module Cluster
  class RemoteConfigs < Base
    def self.all
      s3_client.list_objects(
        bucket: stack_custom_json[:cluster_config_bucket_name]
      ).contents.map(&:key)
    end

    def self.find(name)
      all.find do |cluster_config|
        cluster_config[:name] == name
      end
    end
  end
end
