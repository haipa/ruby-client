
module Haipa::Client::Compute 

    class ApiConfiguration

        include Haipa::Client::Common::Configurable
        
        # @return [String] url to api endpoint.
        attr_accessor :api_endpoint

        # @return [String] url to api endpoint.
        attr_accessor :api_version

        # @return [Module] Model module for selected api.
        attr_accessor :models

        # @return [Haipa::Client::Compute::V1_0::HaipaCompute] client for selected api
        attr_accessor :client
        
        def initialize(options = {})
            if options.is_a?(Hash) && options.length == 0
            @options = setup_default_options
            else
            @options = options
            end
        
            reset!(options)
        
            @api_endpoint = options[:api_endpoint].nil? ? nil:options[:api_endpoint]
            @api_version = options[:api_version].nil? ? nil:options[:api_version]
            @options = options[:options].nil? ? nil:options[:options]

            #require files for requested api version
            @api_version = '1.0' if @api_version.nil?
            require "#{api_version}/generated/haipa_compute"

            #module for models
            @models = Object.const_get("Haipa::Client::Compute::#{module_version}::Models")


            #create client for api version
            clientObject = Object.const_get("Haipa::Client::Compute::#{module_version}::HaipaCompute")
            @client = clientObject.new(config.credentials, config.api_endpoint)
        end

        def deserialize(mapper, hash)
            if mapper.is_a?(Hash)
                mapper_hash = mapper
            else
                if mapper.respond_to?(:mapper)
                    mapper_class = mapper
                end
                
                if mapper.is_a?(Symbol) || mapper.is_a?(String)
                    mapper_class = Object.const_get("Haipa::Client::Compute::#{module_version}::Models::#{mapper}")
                end

                raise "Invalid mapper #{mapper}, only mappers, mapper classes and mapper class names are allowed" unless mapper_class
                mapper_hash = mapper_class.mapper()
            end

            hash_with_string_keys = JSON.parse(hash.to_json)
            @client.deserialize(mapper_hash, hash_with_string_keys)
        end

        def module_version
            #set module version from api version, should be replaced with a more flexible solution later
            module_version = 'V1_0'
            unless @api_version.nil?
                case @api_version
                when '1.0'
                    module_version = 'V1_0'
                else
                    raise 'invalid api version'
                end
            end
        end
    end

end
