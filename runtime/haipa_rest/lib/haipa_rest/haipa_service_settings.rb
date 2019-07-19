# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module Haipa::Client
  #
  # Class which represents an settings for Azure AD authentication.
  #
  class HaipaServiceSettings

    # @return [String] auth token.
    attr_accessor :authentication_endpoint

    # @return [String] auth token.
    attr_accessor :token_audience
  
    private

  end
end
