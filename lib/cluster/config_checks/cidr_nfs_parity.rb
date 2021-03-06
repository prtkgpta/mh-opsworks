module Cluster
  module ConfigChecks
    class VpcCidrAndNfsExportMismatch < StandardError; end

    class CidrNfsParity < Base
      def self.sane?
        if external_storage?
          return
        end
        if root_config[:vpc][:cidr_block] != stack_custom_json[:storage][:network]
          raise VpcCidrAndNfsExportMismatch.new('The Vpc cidr_block and stack-level storage network export must match')
        end
      end
    end
  end
end

Cluster::Config.append_to_check_registry(Cluster::ConfigChecks::CidrNfsParity)
