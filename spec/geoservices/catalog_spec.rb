describe Geoservice do
  context 'getting a catalog' do
    let(:response) do
      {
        "currentVersion": 11.1,
        "folders": [],
        "services": [
          {
            "name": "DelDOT/DE_ADA_Self_Evaluation_Inventory",
            "type": "FeatureServer"
          },
          {
            "name": "DelDOT/DE_ADA_Self_Evaluation_Inventory",
            "type": "MapServer"
          },
          {
            "name": "DelDOT/DE_DOT_Outbound_Map",
            "type": "FeatureServer"
          },
          {
            "name": "DelDOT/DE_DOT_Outbound_Map",
            "type": "MapServer"
          }
        ]
      }
    end
    let(:catalog) do
      Geoservice::Catalog.new(host: 'https://apps.firstmap.delaware.gov/apps/rest/services/DelDOT')
    end

    let(:mock_response) { Net::HTTPSuccess.new(1.0, '200', 'OK') }

    before do
      expect(Net::HTTP).to receive(:get_response).and_return(mock_response)
      expect(mock_response).to receive(:body) { response.to_json }
    end

    context '#services' do
      it 'returns the number of services available - at least 1' do
        expect(catalog.services.size).to be >= 1
      end
    end

    context '#[]' do
      it "indexes the catalog's services by name" do
        expect(catalog['DelDOT/DE_DOT_Outbound_Map']['type']).to eq('FeatureServer')
      end
    end
  end
end
