# encoding: utf-8
# Copyright (c) dbosoft GmbH and Haipa Contributors. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'ms_rest'
require 'haipa_rest/async_operation_status.rb'
require 'haipa_rest/Haipa_operation_error.rb'
require 'haipa_rest/Haipa_operation_response.rb'
require 'haipa_rest/Haipa_service_client.rb'
require 'haipa_rest/cloud_error_data.rb'
require 'haipa_rest/final_state_via.rb'
require 'haipa_rest/credentials/application_token_provider.rb'
require 'haipa_rest/polling_state.rb'
require 'haipa_rest/serialization.rb'
require 'haipa_rest/typed_error_info.rb' 
require 'haipa_rest/version'
require 'haipa_rest/common/configurable'
require 'haipa_rest/common/default'

module Haipa end
module Haipa::Client end
module Haipa::Client::Serialization end
module Haipa::Client::Common end
module Haipa::Client::Common::Configurable end
module Haipa::Client::Common::Default end
