describe Cluster::RemoteConfig do
  context '.create' do
    it 'uses Cluster::RemoteConfigCreator to create the templatted json' do
      attributes = {
        name: 'a name',
        cidr_block: '10.1.1.0/24',
        variant: 'large'
      }
      described_class.create(attributes)

      expect(Cluster::RemoteConfigCreator).to have_received(:new).with(attributes)
    end
  end

  context '#latest?' do
    it 'gets the latest cluster config from the remote' do

    end

    it 'is true if our version is >= upstream and we have changes' do

    end

    it 'is true if our version is >= and we do not have changes' do

    end

    it 'is false if our version is <= upstream and there are changes' do

    end

    it 'is false if our version is <= upstream and there are no changes' do

    end
  end

  context '#version' do

  end

  context '#delete' do
    it 'deletes the remote config via the aws-sdk client' do

    end
  end

  context '#changeset' do
    it 'shows a diff against the upstream cluster config' do

    end
  end

  context '#save' do
    it 'uses the aws-sdk client to save the latest cluster_config by name' do

    end
  end
end
