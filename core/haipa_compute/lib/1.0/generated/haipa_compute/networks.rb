# encoding: utf-8
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module Haipa::Client::Compute::V1_0
  #
  # Haipa management API
  #
  class Networks
    include Haipa::Client

    #
    # Creates and initializes a new instance of the Networks class.
    # @param client service class for accessing basic functionality.
    #
    def initialize(client)
      @client = client
    end

    # @return [HaipaCompute] reference to the HaipaCompute
    attr_reader :client

    #
    # @param select [String] Limits the properties returned in the result.
    # @param expand [String] Indicates the related entities to be represented
    # inline. The maximum depth is 2.
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def list(select:nil, expand:nil, custom_headers:nil)
      response = list_async(select:select, expand:expand, custom_headers:custom_headers).value!
      nil
    end

    #
    # @param select [String] Limits the properties returned in the result.
    # @param expand [String] Indicates the related entities to be represented
    # inline. The maximum depth is 2.
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [Haipa::Client::HaipaOperationResponse] HTTP response information.
    #
    def list_with_http_info(select:nil, expand:nil, custom_headers:nil)
      list_async(select:select, expand:expand, custom_headers:custom_headers).value!
    end

    #
    # @param select [String] Limits the properties returned in the result.
    # @param expand [String] Indicates the related entities to be represented
    # inline. The maximum depth is 2.
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def list_async(select:nil, expand:nil, custom_headers:nil)


      request_headers = {}
      request_headers['Content-Type'] = 'application/json; charset=utf-8'

      # Set Headers
      request_headers['x-ms-client-request-id'] = SecureRandom.uuid
      request_headers['accept-language'] = @client.accept_language unless @client.accept_language.nil?
      path_template = 'odata/v1/Networks'

      request_url = @base_url || @client.base_url

      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02]],
          query_params: {'$select' => select,'$expand' => expand},
          headers: request_headers.merge(custom_headers || {}),
          base_url: request_url
      }
      promise = @client.make_request_async(:get, path_template, options)

      promise = promise.then do |result|
        http_response = result.response
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 200
          error_model = JSON.load(response_content)
          fail Haipa::Client::HaipaOperationError.new(result.request, http_response, error_model)
        end

        result.request_id = http_response['x-ms-request-id'] unless http_response['x-ms-request-id'].nil?
        result.correlation_request_id = http_response['x-ms-correlation-request-id'] unless http_response['x-ms-correlation-request-id'].nil?
        result.client_request_id = http_response['x-ms-client-request-id'] unless http_response['x-ms-client-request-id'].nil?

        result
      end

      promise.execute
    end

    #
    # @param network [Network]
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def create(network:nil, custom_headers:nil)
      response = create_async(network:network, custom_headers:custom_headers).value!
      nil
    end

    #
    # @param network [Network]
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [Haipa::Client::HaipaOperationResponse] HTTP response information.
    #
    def create_with_http_info(network:nil, custom_headers:nil)
      create_async(network:network, custom_headers:custom_headers).value!
    end

    #
    # @param network [Network]
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def create_async(network:nil, custom_headers:nil)


      request_headers = {}
      request_headers['Content-Type'] = 'application/json; charset=utf-8'

      # Set Headers
      request_headers['x-ms-client-request-id'] = SecureRandom.uuid
      request_headers['accept-language'] = @client.accept_language unless @client.accept_language.nil?

      # Serialize Request
      request_mapper = Haipa::Client::Compute::V1_0::Models::Network.mapper()
      request_content = @client.serialize(request_mapper,  network)
      request_content = request_content != nil ? JSON.generate(request_content, quirks_mode: true) : nil

      path_template = 'odata/v1/Networks'

      request_url = @base_url || @client.base_url

      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02]],
          body: request_content,
          headers: request_headers.merge(custom_headers || {}),
          base_url: request_url
      }
      promise = @client.make_request_async(:post, path_template, options)

      promise = promise.then do |result|
        http_response = result.response
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 200
          error_model = JSON.load(response_content)
          fail Haipa::Client::HaipaOperationError.new(result.request, http_response, error_model)
        end

        result.request_id = http_response['x-ms-request-id'] unless http_response['x-ms-request-id'].nil?
        result.correlation_request_id = http_response['x-ms-correlation-request-id'] unless http_response['x-ms-correlation-request-id'].nil?
        result.client_request_id = http_response['x-ms-client-request-id'] unless http_response['x-ms-client-request-id'].nil?

        result
      end

      promise.execute
    end

    #
    # @param key
    # @param select [String] Limits the properties returned in the result.
    # @param expand [String] Indicates the related entities to be represented
    # inline. The maximum depth is 2.
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def get(key, select:nil, expand:nil, custom_headers:nil)
      response = get_async(key, select:select, expand:expand, custom_headers:custom_headers).value!
      nil
    end

    #
    # @param key
    # @param select [String] Limits the properties returned in the result.
    # @param expand [String] Indicates the related entities to be represented
    # inline. The maximum depth is 2.
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [Haipa::Client::HaipaOperationResponse] HTTP response information.
    #
    def get_with_http_info(key, select:nil, expand:nil, custom_headers:nil)
      get_async(key, select:select, expand:expand, custom_headers:custom_headers).value!
    end

    #
    # @param key
    # @param select [String] Limits the properties returned in the result.
    # @param expand [String] Indicates the related entities to be represented
    # inline. The maximum depth is 2.
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def get_async(key, select:nil, expand:nil, custom_headers:nil)
      fail ArgumentError, 'key is nil' if key.nil?


      request_headers = {}
      request_headers['Content-Type'] = 'application/json; charset=utf-8'

      # Set Headers
      request_headers['x-ms-client-request-id'] = SecureRandom.uuid
      request_headers['accept-language'] = @client.accept_language unless @client.accept_language.nil?
      path_template = 'odata/v1/Networks({key})'

      request_url = @base_url || @client.base_url

      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02]],
          path_params: {'key' => key},
          query_params: {'$select' => select,'$expand' => expand},
          headers: request_headers.merge(custom_headers || {}),
          base_url: request_url
      }
      promise = @client.make_request_async(:get, path_template, options)

      promise = promise.then do |result|
        http_response = result.response
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 200
          error_model = JSON.load(response_content)
          fail Haipa::Client::HaipaOperationError.new(result.request, http_response, error_model)
        end

        result.request_id = http_response['x-ms-request-id'] unless http_response['x-ms-request-id'].nil?
        result.correlation_request_id = http_response['x-ms-correlation-request-id'] unless http_response['x-ms-correlation-request-id'].nil?
        result.client_request_id = http_response['x-ms-client-request-id'] unless http_response['x-ms-client-request-id'].nil?

        result
      end

      promise.execute
    end

    #
    # @param key
    # @param update [Network]
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def update(key, update:nil, custom_headers:nil)
      response = update_async(key, update:update, custom_headers:custom_headers).value!
      nil
    end

    #
    # @param key
    # @param update [Network]
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [Haipa::Client::HaipaOperationResponse] HTTP response information.
    #
    def update_with_http_info(key, update:nil, custom_headers:nil)
      update_async(key, update:update, custom_headers:custom_headers).value!
    end

    #
    # @param key
    # @param update [Network]
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def update_async(key, update:nil, custom_headers:nil)
      fail ArgumentError, 'key is nil' if key.nil?


      request_headers = {}
      request_headers['Content-Type'] = 'application/json; charset=utf-8'

      # Set Headers
      request_headers['x-ms-client-request-id'] = SecureRandom.uuid
      request_headers['accept-language'] = @client.accept_language unless @client.accept_language.nil?

      # Serialize Request
      request_mapper = Haipa::Client::Compute::V1_0::Models::Network.mapper()
      request_content = @client.serialize(request_mapper,  update)
      request_content = request_content != nil ? JSON.generate(request_content, quirks_mode: true) : nil

      path_template = 'odata/v1/Networks({key})'

      request_url = @base_url || @client.base_url

      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02]],
          path_params: {'key' => key},
          body: request_content,
          headers: request_headers.merge(custom_headers || {}),
          base_url: request_url
      }
      promise = @client.make_request_async(:put, path_template, options)

      promise = promise.then do |result|
        http_response = result.response
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 200
          error_model = JSON.load(response_content)
          fail Haipa::Client::HaipaOperationError.new(result.request, http_response, error_model)
        end

        result.request_id = http_response['x-ms-request-id'] unless http_response['x-ms-request-id'].nil?
        result.correlation_request_id = http_response['x-ms-correlation-request-id'] unless http_response['x-ms-correlation-request-id'].nil?
        result.client_request_id = http_response['x-ms-client-request-id'] unless http_response['x-ms-client-request-id'].nil?

        result
      end

      promise.execute
    end

    #
    # @param key
    # @param product [Network]
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def patch(key, product:nil, custom_headers:nil)
      response = patch_async(key, product:product, custom_headers:custom_headers).value!
      nil
    end

    #
    # @param key
    # @param product [Network]
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [Haipa::Client::HaipaOperationResponse] HTTP response information.
    #
    def patch_with_http_info(key, product:nil, custom_headers:nil)
      patch_async(key, product:product, custom_headers:custom_headers).value!
    end

    #
    # @param key
    # @param product [Network]
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def patch_async(key, product:nil, custom_headers:nil)
      fail ArgumentError, 'key is nil' if key.nil?


      request_headers = {}
      request_headers['Content-Type'] = 'application/json; charset=utf-8'

      # Set Headers
      request_headers['x-ms-client-request-id'] = SecureRandom.uuid
      request_headers['accept-language'] = @client.accept_language unless @client.accept_language.nil?

      # Serialize Request
      request_mapper = Haipa::Client::Compute::V1_0::Models::Network.mapper()
      request_content = @client.serialize(request_mapper,  product)
      request_content = request_content != nil ? JSON.generate(request_content, quirks_mode: true) : nil

      path_template = 'odata/v1/Networks({key})'

      request_url = @base_url || @client.base_url

      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02]],
          path_params: {'key' => key},
          body: request_content,
          headers: request_headers.merge(custom_headers || {}),
          base_url: request_url
      }
      promise = @client.make_request_async(:patch, path_template, options)

      promise = promise.then do |result|
        http_response = result.response
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 200
          error_model = JSON.load(response_content)
          fail Haipa::Client::HaipaOperationError.new(result.request, http_response, error_model)
        end

        result.request_id = http_response['x-ms-request-id'] unless http_response['x-ms-request-id'].nil?
        result.correlation_request_id = http_response['x-ms-correlation-request-id'] unless http_response['x-ms-correlation-request-id'].nil?
        result.client_request_id = http_response['x-ms-client-request-id'] unless http_response['x-ms-client-request-id'].nil?

        result
      end

      promise.execute
    end

  end
end