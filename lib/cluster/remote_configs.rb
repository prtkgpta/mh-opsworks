module Cluster
  class RemoteConfigs
    def self.all

    end

    def self.find(name)
      all.find do |cluster_config|
        cluster_config[:name] == name
      end
    end
  end
end
