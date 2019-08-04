# encoding: utf-8
# Copyright (c) dbosoft GmbH and Haipa Contributors. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'concurrent'
require 'haipa_rest'

module Haipa::Client

  describe HaipaServiceClient do
    before(:all) do
      @methods = ['put', 'post', 'delete', 'patch']
    end

    it 'should throw error in case provided Haipa response is nil' do
      Haipa_service_client = HaipaServiceClient.new nil
      expect { Haipa_service_client.get_long_running_operation_result(nil, nil) }.to raise_error(MsRest::ValidationError)
    end

    it 'should throw error if unexpected polling state is passed' do
      Haipa_service_client = HaipaServiceClient.new nil

      response = double('response', :status => 404)
      request = double('request', headers: {}, base_uri: '', method: @methods[0])

      haipa_response = double('haipa_response',
                              :request => request,
                              :response => response,
                              :body => nil)

      expect { Haipa_service_client.get_long_running_operation_result(haipa_response, nil) }.to raise_error(HaipaOperationError)
    end

    it 'should use async operation header when async_operation_header present' do
      Haipa_service_client = HaipaServiceClient.new nil
      Haipa_service_client.long_running_operation_retry_timeout = 0

      allow_any_instance_of(Haipa::Client::PollingState).to receive(:create_connection).and_return(nil)
      allow(Haipa_service_client).to receive(:update_state_from_Haipa_async_operation_header) do |request, polling_state|
        polling_state.status = AsyncOperationStatus::SUCCESS_STATUS
        polling_state.resource = 'resource'
      end

      response = double('response',
                        :headers =>
                            { 'Haipa-AsyncOperation' => 'async_operation_header',
                              'Location' => 'location_header'},
                        :status => 202)
      expect(Haipa_service_client).to receive(:update_state_from_Haipa_async_operation_header)

      @methods.each do |method|
        request = double('request', headers: {}, base_uri: '', method: method)
        haipa_response = double('haipa_response',
                                :request => request,
                                :response => response,
                                :body => nil)
        Haipa_service_client.get_long_running_operation_result(haipa_response, nil)
      end
    end

    it 'should use location operation header when location_header present' do
      Haipa_service_client = HaipaServiceClient.new nil
      Haipa_service_client.long_running_operation_retry_timeout = 0

      allow_any_instance_of(Haipa::Client::PollingState).to receive(:create_connection).and_return(nil)
      allow(Haipa_service_client).to receive(:update_state_from_location_header) do |request, polling_state|
        polling_state.status = AsyncOperationStatus::SUCCESS_STATUS
        polling_state.resource = 'resource'
      end

      response = double('response', :headers => { 'Location' => 'location_header'}, :status => 202)
      expect(Haipa_service_client).to receive(:update_state_from_location_header)

      @methods.each do |method|
        request = double('request', headers: {}, base_uri: '', method: method)
        haipa_response = double('haipa_response',
                                :request => request,
                                :response => response,
                                :body => nil)
        Haipa_service_client.get_long_running_operation_result(haipa_response, nil)
      end
    end

    it 'should throw error in case LRO ends up with failed status' do
      Haipa_service_client = HaipaServiceClient.new nil
      Haipa_service_client.long_running_operation_retry_timeout = 0

      allow_any_instance_of(Haipa::Client::PollingState).to receive(:create_connection).and_return(nil)
      allow(Haipa_service_client).to receive(:update_state_from_Haipa_async_operation_header) do |request, polling_state|
        polling_state.status = AsyncOperationStatus::FAILED_STATUS
      end

      response = double('response', :headers =>
                                      { 'Haipa-AsyncOperation' => 'async_operation_header' },
                                    :status => 202)

      @methods.each do |method|
        request = double('request', headers: {}, base_uri: '', method: method)
        haipa_response = double('haipa_response',
                                :request => request,
                                :response => response,
                                :body => nil)
        expect { Haipa_service_client.get_long_running_operation_result(haipa_response, nil) }.to raise_error(HaipaOperationError)
      end
    end

    it 'should add or update default user agent information' do
      Haipa_service_client = HaipaServiceClient.new nil

      # Verify default information
      default_info = 'Haipa-SDK-For-Ruby'
      expect(Haipa_service_client.user_agent_extended).not_to be_nil
      expect(Haipa_service_client.user_agent_extended).to include(default_info)

      # Verify updated information
      additional_user_agent_information = "fog-Haipa-rm/0.2.0"
      Haipa_service_client.add_user_agent_information(additional_user_agent_information)
      expect(Haipa_service_client.user_agent_extended).not_to be_nil
      expect(Haipa_service_client.user_agent_extended).to include(default_info)
      expect(Haipa_service_client.user_agent_extended).to include(additional_user_agent_information)
    end
  end
end
