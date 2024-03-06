describe Geoservice do
  context 'getting a catalog' do
    let(:catalog) do
      Geoservice::Catalog.new(host: 'http://rmgsc.cr.usgs.gov/ArcGIS/rest/services/')
    end

    context '#services' do
      it 'returns the number of services available - at least 1' do
        expect(catalog.services.size).to be >= 1
      end
    end

    context '#[]' do
      it "indexes the catalog's services by name" do
        expect(catalog['ecosys_US']['type']).to eq('MapServer')
      end
    end
  end
end
