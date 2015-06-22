describe Cluster::ConfigChecks::BucketConfigs do
  include EnvironmentHelpers

  it 'does not raise when the correct buckets are defined' do
    stub_config_to_include({
      stack: {
        chef: {
          custom_json: {
            shared_asset_bucket_name: 'foo',
            cluster_config_bucket_name: 'foobar'
          }
        }
      }
    })

    expect { described_class.sane? }.not_to raise_error
  end

  it 'raises when the correct buckets are not defined' do
    stub_config_to_include({
      stack: {
        chef: {
          custom_json: { }
        }
      }
    })

    expect { described_class.sane?  }.to raise_error
  end

  it_behaves_like 'a registered configuration check'
end
