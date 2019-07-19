# encoding: utf-8
# Copyright (c) dbosoft GmbH and Haipa Contributors. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module Haipa::Client::Common
  # The Haipa::Common::Configurable module provides basic configuration for Haipa activities.
  module Configurable

    # @return [String] client id.
    attr_accessor :client_id

    # @return [String] secret key.
    attr_accessor :client_secret

    # @return [MsRest::ServiceClientCredentials] credentials to authorize HTTP requests made by the service client.
    attr_accessor :credentials

    # @return [MsRestAzure::ActiveDirectoryServiceSettings] Azure active directory service settings.
    attr_accessor :active_directory_settings    

    class << self
      #
      # List of configurable keys for {Haipa::Client::Common::Client}.
      # @return [Array] of option keys.
      #
      def keys
        @keys ||= [:client_id, :client_secret, :active_directory_settings]
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

      if(options[:credentials].nil?)
        # The user has not passed in the credentials. So, the SDK has to
        # build the credentials itself.
        fail ArgumentError, 'client_id is nil' if self.client_id.nil?
        fail ArgumentError, 'client_secret is nil' if self.client_secret.nil?
        fail ArgumentError, 'active_directory_settings is nil' if self.active_directory_settings.nil?

        self.credentials = MsRest::TokenCredentials.new(
            Haipa::Client::ApplicationTokenProvider.new(
                self.client_id, self.client_secret, self.active_directory_settings))
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
