# encoding: utf-8
# Copyright (c) dbosoft GmbH and Haipa Contributors. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'jwt'

module Haipa::Client
  #
  # Class that provides access to authentication token.
  #
  class ApplicationTokenProvider < MsRest::TokenProvider

    private

    TOKEN_ACQUIRE_URL = '{identity_endpoint}/connect/token'
    DEFAULT_SCHEME = 'Bearer'

    # @return [String] client id.
    attr_accessor :client_id

    # @return [String] client key
    attr_accessor :client_key

    # @return [String] url to identity endpoint.
    attr_accessor :identity_endpoint

    # @return [String] auth token.
    attr_accessor :token

    # @return [Time] the date when the current token expires.
    attr_accessor :token_expires_on

    # @return [Integer] the amount of time we refresh token before it expires.
    attr_reader :expiration_threshold

    # @return [String] the type of token.
    attr_reader :token_type

    public

    #
    # Creates and initialize new instance of the ApplicationTokenProvider class.
    # @param client_id [String] client id.
    # @param client_key [String] client key.
    # @param identity_endpoint [String] url of identity endpoint.
    # @param ca_file [String] path to additional ca file.
    def initialize(client_id, client_key, identity_endpoint)
      fail ArgumentError, 'Client id cannot be nil' if client_id.nil?
      fail ArgumentError, 'Client key cannot be nil' if client_key.nil?
      fail ArgumentError, 'Identity_endpoint url cannot be nil' if identity_endpoint.nil?

      @client_id = client_id
      @client_key = client_key
      @identity_endpoint = identity_endpoint

      @expiration_threshold = 5 * 60
    end

    #
    # Returns the string value which needs to be attached
    # to HTTP request header in order to be authorized.
    #
    # @return [String] authentication headers.
    def get_authentication_header
      acquire_token if token_expired
      "#{token_type} #{token}"
    end

    private

    #
    # Checks whether token is about to expire.
    #
    # @return [Bool] True if token is about to expire, false otherwise.
    def token_expired
      @token.nil? || Time.now >= @token_expires_on + expiration_threshold
    end

    #
    # Retrieves a new authentication token.
    #
    # @return [String] new authentication token.
    def acquire_token
      token_acquire_url = TOKEN_ACQUIRE_URL.dup
      token_acquire_url['{identity_endpoint}'] = @identity_endpoint

      url = URI.parse(token_acquire_url)

      connection = Faraday.new(:url => url, :ssl => MsRest.ssl_options)
      exp = Time.now.to_i + @expiration_threshold

      payload = { iss: client_id,
        aud: token_acquire_url,
        sub: @client_id,
        exp: exp
      }

      signed_payload = JWT.encode payload, client_key, 'RS256'

      response = connection.post url.path, { 
        :grant_type => 'client_credentials',
        :client_id => client_id,
        :client_assertion_type => 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer',
        :client_assertion => signed_payload,
        :scope => 'compute_api' }
      
      fail HaipaOperationError,
        'Couldn\'t login to Haipa, please verify your client id and client key' unless response.status == 200

      response_body = JSON.load(response.body)
      @token = response_body['access_token']
      @token_expires_on = Time.now + Integer(response_body['expires_in'])
      @token_type = response_body['token_type']
      
    end
  end

end
