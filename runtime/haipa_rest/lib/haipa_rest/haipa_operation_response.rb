# encoding: utf-8
# Copyright (c) dbosoft GmbH and Haipa Contributors. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module Haipa::Client
  #
  # Class which represents the data received and deserialized from Haipa service.
  #
  class HaipaOperationResponse < MsRest::HttpOperationResponse

    # @return [String] identificator of the request.
    attr_accessor :request_id

    # @return [String] Correlation Id of the request.
    attr_accessor :correlation_request_id

    # @return [String] Client Request Id of the request.
    attr_accessor :client_request_id
  end
end
