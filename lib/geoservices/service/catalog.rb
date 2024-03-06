module Geoservice
  # a catalog of services
  class Catalog
    include Geoservice::Base
    attr_reader :metadata, :services, :version

    def initialize(options = {})
      @host = options[:host]
      @metadata = get(@host)
      @services = @metadata['services']
      @version  = @metadata['currentVersion']
    end

    def [](service_name)
      return services[service_name] if service_name.is_a?(Integer)
      (0..services.length).each do |i|
        return services[i] if service_name == services[i]['name']
      end
    end
  end
end
