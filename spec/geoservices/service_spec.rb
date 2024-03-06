describe Geoservice do
  let(:layers) do
    [
      {"id"=>0, "name"=>"TSDM_ACIA_MERGED_POINTS", "parentLayerId"=>-1, "defaultVisibility"=>true, "subLayerIds"=>nil, "minScale"=>0, "maxScale"=>0, "type"=>"Feature Layer", "geometryType"=>"esriGeometryPoint"},
      {"id"=>1, "name"=>"TSDM_ACIA_MERGED_LINES", "parentLayerId"=>-1, "defaultVisibility"=>true, "subLayerIds"=>nil, "minScale"=>0, "maxScale"=>0, "type"=>"Feature Layer", "geometryType"=>"esriGeometryPolyline"},
      {"id"=>2, "name"=>"PMS_PMRY_LRS_NETWORK", "parentLayerId"=>-1, "defaultVisibility"=>true, "subLayerIds"=>nil, "minScale"=>0, "maxScale"=>0, "type"=>"Feature Layer", "geometryType"=>"esriGeometryPolyline"}
    ]
  end
  let(:mock_response) { Net::HTTPSuccess.new(1.0, '200', 'OK') }

  context 'a feature service' do
    let(:service) do
      Geoservice::FeatureService.new(url: 'https://apps.firstmap.delaware.gov/apps/rest/services/DelDOT/DE_DOT_Outbound_Map/FeatureServer')
    end

    let(:response) do
      {
        "currentVersion"=>11.1,
        "serviceDescription"=>"",
        "capabilities"=>"Query,Extract",
        # ...snip...
        "layers"=>layers
        # ...snip...
      }
    end

    before do
      expect(Net::HTTP).to receive(:get_response).and_return(mock_response)
      expect(mock_response).to receive(:body) { response.to_json }
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
      let(:layers_response) do
        {
          "layers": layers
        }
      end

      before do
        expect(Net::HTTP).to receive(:get_response).and_return(mock_response)
        expect(mock_response).to receive(:body) { layers_response.to_json }
      end

      it 'should return a value of at least 1' do
        expect(service.layers.length).to be >= 1
      end

      it 'should be indexable by an integer (zero-based)' do
        expect(service.layers[0]['name']).to eq('TSDM_ACIA_MERGED_POINTS')
      end

      it "should indexable by name - e.g. ['PMS_PMRY_LRS_NETWORK']" do
        expect(service.layers('PMS_PMRY_LRS_NETWORK')['name']).to eq 'PMS_PMRY_LRS_NETWORK'
      end
    end

    context '#query' do
      let(:query_response) do
        {
          # ...snip...
          "features"=> [
            {
              "attributes"=> {
                "ROAD"=>"KC-46035A-F",
                "RDWAY_ID"=>10522.0,
                "ROAD_MAINT_RSP"=>"Municipal (in Smyrna)",
                "FACILITY_TYPE"=>"Crosswalk",
                "TSDM_REF"=>"3269843",
                "ACIA_ID"=>nil,
                "REF_COMMENT"=>nil,
                "PROCESS_DATE"=>1709684270000,
                "ACTION_NEEDED"=>"Add",
                "OBJECTID"=>3269843,
                "Shape__Length"=>0
              },
              "geometry"=>{"paths"=>[[[-8417547.9661, 4764646.763400003], [-8417539.159, 4764636.606700003]]]}},
            {
              "attributes"=> {
                "ROAD"=>"NC-141048-F",
                "RDWAY_ID"=>11627.0,
                "ROAD_MAINT_RSP"=>"DelDOT (in Suburban)",
                "FACILITY_TYPE"=>"Crosswalk",
                "TSDM_REF"=>"3269696",
                "ACIA_ID"=>nil,
                "REF_COMMENT"=>nil,
                "PROCESS_DATE"=>1709684270000,
                "ACTION_NEEDED"=>"Add",
                "OBJECTID"=>3269696,
                "Shape__Length"=>0},
                "geometry"=>{"paths"=>[[[-8435178.956, 4815212.059], [-8435161.5051, 4815207.6677]]]}
            },
            # ...snip...
          ]
          # ...snip...
        }
      end

      it "with a layer index param should have a ['features'] key" do
        expect_any_instance_of(Net::HTTP).to receive(:request).and_return(mock_response)
        expect(mock_response).to receive(:body) { query_response.to_json }

        expect(-> { service.query(1)['features'] }).not_to raise_error
      end
    end

    context '#count' do
      let(:count_response) do
        {
          "count": 13596
        }
      end

      before do
        expect_any_instance_of(Net::HTTP).to receive(:request).and_return(mock_response)
        expect(mock_response).to receive(:body) { count_response.to_json }
      end

      it "with a layer index param should have a ['count'] key" do
        expect(-> { service.count(1)['count'] }).not_to raise_error
      end

      it "the ['count'] value should be the number of layer features" do
        expect(service.count(1)['count'].is_a?(Integer)).to be true
      end
    end

    context '#features' do
      xit 'with layer and feature index params returns a specific feature' do
        expect(service.features(1, 1).keys).to eq %w(feature)
      end
    end
  end

  context 'getting a map service' do
    let(:service) do
      Geoservice::MapService.new(url: 'https://apps.firstmap.delaware.gov/apps/rest/services/DelDOT/DE_DOT_Outbound_Map/MapServer')
    end
    let(:response) do
      {
        "currentVersion"=>11.1,
        "serviceDescription"=>"",
        "mapName"=>"DE_DOT_Outbound_Map",
        "capabilities"=>"Map,Query,Data",
        # ...snip...
        "layers"=>layers
        # ...snip...
      }
    end

    before do
      expect(Net::HTTP).to receive(:get_response).and_return(mock_response)
      expect(mock_response).to receive(:body) { response.to_json }
    end

    context '#metadata' do
      it "should have a ['mapName'] value" do
        expect(service.metadata['mapName']).to eq 'DE_DOT_Outbound_Map'
      end
    end

    context '#layers' do
      let(:layers_response) do
        {
          "layers": layers
        }
      end

      before do
        expect(Net::HTTP).to receive(:get_response).and_return(mock_response)
        expect(mock_response).to receive(:body) { layers_response.to_json }
      end

      it 'should return the number of layers (>= 1)' do
        expect(service.layers.length).to eq 3
      end

      it 'should be indexable by an integer (zero-based)' do
        expect(service.layers[0]['name']).to eq('TSDM_ACIA_MERGED_POINTS')
      end

      it "should indexable by name - e.g. ['Ecosystems']" do
        expect(service.layers('TSDM_ACIA_MERGED_POINTS')['name']).to eq 'TSDM_ACIA_MERGED_POINTS'
      end
    end

    context '#count' do
      let(:count_response) do
        {
          "count": 13596
        }
      end

      before do
        expect_any_instance_of(Net::HTTP).to receive(:request).and_return(mock_response)
        expect(mock_response).to receive(:body) { count_response.to_json }
      end

      it "with a layer index param should have a ['count'] key" do
        expect(-> { service.count(0)['count'] }).not_to raise_error
      end

      it "the ['count'] value should be the number of layer features" do
        expect(service.count(0)['count'].is_a?(Integer)).to be true
      end
    end
  end
end
