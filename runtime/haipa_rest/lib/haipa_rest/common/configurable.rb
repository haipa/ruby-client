# encoding: utf-8
# Copyright (c) dbosoft GmbH and Haipa Contributors. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'openssl'

module Haipa::Client::Common
  # The Haipa::Common::Configurable module provides basic configuration for Haipa activities.
  module Configurable

    # @return [MsRest::ServiceClientCredentials] credentials to authorize HTTP requests made by the service client.
    attr_accessor :credentials

    # @return [String] client id.
    attr_accessor :client_id

    # @return [String] path to client key file
    attr_accessor :client_key_file

    # @return [String] client key
    attr_accessor :client_key

    # @return [String] url to identity endpoint.
    attr_accessor :identity_endpoint

    class << self
      #
      # List of configurable keys for {Haipa::Client::Common::Client}.
      # @return [Array] of option keys.
      #
      def keys
        @keys ||= [:client_id, :client_key_file, :identity_endpoint ]
      end
    end

    #
    # Set configuration options using a block.
    #
    def configure
      yield self
    end

    #
    # Resets the configurable options to provided options or defaults.
    # This will also creates MsRest::TokenCredentials to be used for subsequent clients.
    #
    def reset!(options = {})
      Haipa::Client::Common::Configurable.keys.each do |key|
        default_value = Haipa::Client::Common::Default.options[key]
        instance_variable_set(:"@#{key}", options.fetch(key, default_value))
      end

      if(options[:client_key].nil?)
        # The user has not passed in the client key. try to read it from client_key_file
        self.client_key = OpenSSL::PKey::RSA.new File.read self.client_key_file unless self.client_key_file.nil?       
      end

      if(options[:credentials].nil?)
        # The user has not passed in the credentials. So, the api has to
        # build the credentials itself.
        fail ArgumentError, 'client_id is nil' if self.client_id.nil?
        fail ArgumentError, 'client_key is nil' if self.client_key.nil?
        fail ArgumentError, 'identity_endpoint is nil' if self.identity_endpoint.nil?

        self.credentials = MsRest::TokenCredentials.new(
            Haipa::Client::ApplicationTokenProvider.new(
                self.client_id, self.client_key, self.identity_endpoint))
      else
        self.credentials = options[:credentials]
      end

      self
    end

    def config
      self
    end

    private

    #
    # configures configurable options to default values
    #
    def setup_default_options
      opts = {}
      Haipa::Client::Common::Configurable.keys.map do |key|
        opts[key] = Haipa::Client::Common::Default.options[key]
      end

      opts
    end
  end
end
