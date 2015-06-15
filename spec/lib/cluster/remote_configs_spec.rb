describe Cluster::RemoteConfigs do
  context '.all' do
    it 'creates the dynamodb table if it does not exist' do

    end

    it 'finds the dynamodb table if it exists' do

    end

    it 'returns a list of remotely stored configs' do

    end
  end

  context '.find' do
    it 'uses .all to find cluster configs' do
      name = 'Cluster of concern'
      with_a_config_named(name) do
        described_class.find(name)
        expect(described_class).to have_received(:all)
      end
    end

    it 'matches cluster configs by their name' do
      name = 'Cluster of concern'
      with_a_config_named(name) do
        config = described_class.find(name)
        expect(config[:name]).to eq name
      end
    end
  end

  def with_a_config_named(name)
    cluster_configs = [
      cluster_config_with_name(name),
      cluster_config_with_name('unwanted')
    ]
    allow(described_class).to receive(:all).and_return(cluster_configs)

    yield
  end

  def cluster_config_with_name(name)
    {
      name: name,
      layers: [],
      stack: []
    }
  end
end
