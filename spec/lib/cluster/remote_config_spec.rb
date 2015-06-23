describe Cluster::RemoteConfig do
  context '.create' do
    it 'uses Cluster::ConfigCreator to create the templatted json' do
      config_creator_double = double('Config creator')
      allow(config_creator_double).to receive(:create)

      allow(Cluster::ConfigCreator).to receive(:new).and_return(config_creator_double)
      attributes = {
        name: 'a name',
        cidr_block: '10.1.1.0/24',
        variant: :large
      }
      described_class.create(attributes)

      expect(Cluster::ConfigCreator).to have_received(:new).with(attributes)
      expect(config_creator_double).to have_received(:create)
    end
  end

  context '#latest?' do
    it 'gets the latest cluster config from the remote'

    it 'is true if our version is >= upstream and we have changes'

    it 'is true if our version is >= and we do not have changes'

    it 'is false if our version is <= upstream and there are changes'

    it 'is false if our version is <= upstream and there are no changes'
  end

  context '#version' do
    it 'gets the version from the config'
  end

  context '#delete' do
    it 'deletes the remote config via the aws-sdk client'
    it 'does not delete if the cluster still exists'
  end

  context '#changeset' do
    it 'shows a diff against the upstream cluster config'
  end

  context '#changed' do
    it 'is true if there are differences'
    it 'is false if they are the same'
  end

  context '#save' do
    it 'uses the aws-sdk client to save the latest cluster_config by name'
  end
end
