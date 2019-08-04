# encoding: utf-8
# Copyright (c) dbosoft GmbH and Haipa Contributors. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module Haipa::Client::Common
  module Default
    class << self

      #
      # Default Haipa Client Id.
      # @return [String] Haipa Client Id.
      #
      def client_id
        ENV['HAIPA_CLIENT_ID']
      end

      #
      # Default Haipa Client Secret.
      # @return [String] Haipa Client Secret.
      #
      def client_key_file
        ENV['HAIPA_CLIENT_KEY_FILE']
      end

      #
      # Default Haipa identity endpoint.
      # @return [String] Haipa identiy endpoint
      #
      def identity_endpoint
        ENV['HAIPA_IDENTITY_ENDPOINT']
      end

      #
      # Configuration options.
      # @return [Hash] Configuration options.
      #
      def options
        Hash[Haipa::Client::Common::Configurable.keys.map { |key| [key, send(key)]}]
      end
    end
  end
end
