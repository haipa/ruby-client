# encoding: utf-8
# Copyright (c) dbosoft GmbH and Haipa Contributors. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module Haipa::Client
  #
  # Class which represents a final state via of Haipa long running operation.
  #
  class FinalStateVia
    NONE = -1
    DEFAULT = 0
    ASYNC_OPERATION = 0
    LOCATION = 1
    ORIGINAL_URI = 2
  end
end