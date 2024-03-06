describe Geoservice do
  context 'a feature service' do
    let(:service) do # v10.21 server example
      Geoservice::FeatureService.new(url:
        'http://rmgsc.cr.usgs.gov/arcgis/rest/'\
        'services/geomac_fires/FeatureServer')
    end

    context '#metadata' do
      it "should be indexable by keys, such as: ['serviceDescription']" do
        expect(-> { service.metadata['serviceDescription'] }).not_to raise_error
      end

      it "the ['serviceDescription'] value may be empty" do
        expect(service.metadata['serviceDescription']).to eq('')
      end
    end

    context '#layers' do
      it 'should return a value of at least 1' do
        expect(service.layers.length).to be >= 1
      end

      it 'should be indexable by an integer (zero-based)' do
        expect(service.layers[0]['name']).to eq('Large Fire Points')
      end

      it "should indexable by name - e.g. ['Fire Perimeters']" do
        expect(service.layers('Fire Perimeters')['name']).to eq 'Fire Perimeters'
      end
    end

    context '#query' do
      it "with a layer index param should have a ['features'] key" do
        expect(-> { service.query(1)['features'] }).not_to raise_error
      end
    end

    context '#count' do
      it "with a layer index param should have a ['count'] key" do
        expect(-> { service.count(1)['count'] }).not_to raise_error
      end

      it "the ['count'] value should be the number of layer features" do
        expect(service.count(1)['count'].is_a?(Integer)).to be true
      end
    end

    context '#features' do
      it 'with layer and feature index params returns a specific feature' do
        expect(service.features(1, 1).keys).to eq %w(feature)
      end
    end
  end

  context 'getting a map service' do
    context 'from a layer at version v10.21' do
      let(:service) do # v10.21 server example
        Geoservice::MapService.new(url:
        'http://rmgsc.cr.usgs.gov/arcgis/rest/services/ecosys_US/MapServer')
      end

      context '#metadata' do
        it "should have a ['mapName'] value" do
          expect(service.metadata['mapName']).to eq 'Layers'
        end
      end

      context '#layers' do
        it 'should return the number of layers (>= 1)' do
          expect(service.layers.length).to eq 5
        end

        it 'should be indexable by an integer (zero-based)' do
          expect(service.layers[0]['name']).to eq('Ecosystems')
        end

        it "should indexable by name - e.g. ['Ecosystems']" do
          expect(service.layers('Ecosystems')['name']).to eq 'Ecosystems'
        end
      end
    end

    context 'from a layer at version v10.0' do
      let(:service) do # v10.0 server example
        Geoservice::MapService.new(url:
          'http://sampleserver3.arcgisonline.com/ArcGIS/rest/services/'\
          'Earthquakes/EarthquakesFromLastSevenDays/MapServer')
      end

      context '#count' do
        it "with a layer index param should have a ['count'] key" do
          expect(-> { service.count(0)['count'] }).not_to raise_error
        end

        it "the ['count'] value should be the number of layer features" do
          expect(service.count(0)['count'].is_a?(Integer)).to be true
        end
      end
    end
  end
end
