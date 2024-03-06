module Geoservice
  module Featureable
    # Returns a specific feature from a layer
    # returns nil if the layer does not have any features
    def features(layer_id, id)
      get("#{@url}/#{layer_id}/#{id}")
    end
  end
end
