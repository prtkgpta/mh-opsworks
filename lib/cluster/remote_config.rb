module Cluster
  class RemoteConfig
    def self.create(attributes = {})
      creator = ConfigCreator.new(attributes)
      templatted_output = creator.create
    end
  end
end
