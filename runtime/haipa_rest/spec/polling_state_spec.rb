# encoding: utf-8
# Copyright (c) dbosoft GmbH and Haipa Contributors. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'haipa_rest'

module Haipa::Client

  describe PollingState do
    it 'should initialize status from flattened response body' do
      response_body = double('response_body', :provisioning_state => 'InProgress')
      response = double('response', :status => 201, :headers =>
          { 'Haipa-AsyncOperation' => 'async_operation_header',
            'Location' => 'location_header'})
      haipa_response = double('response',
                        :request => nil,
                        :response => response,
                        :body => response_body)

      polling_state = PollingState.new haipa_response, 0

      expect(polling_state.status.casecmp('InProgress') == 0).to be true
    end

    it 'should initialize status from non-flattened response body' do
      provisioning_state = double('provisioning_state', :provisioning_state => 'Succeeded')
      response_body = double('response_body', :properties => provisioning_state)
      response = double('response', :status => 201, :headers =>
          { 'Haipa-AsyncOperation' => 'async_operation_header',
            'Location' => 'location_header'})
      haipa_response = double('response',
                        :request => nil,
                        :response => response,
                        :body => response_body)

      polling_state = PollingState.new haipa_response, 0

      expect(polling_state.status.casecmp('Succeeded') == 0).to be true
    end

    it 'should initialize status from response status' do
      response = double('response', :status => 200, :headers => {})

      haipa_response = double('haipa_response',
                        :request => nil,
                        :response => response,
                        :body => nil)

      polling_state = PollingState.new haipa_response, 0

      expect(polling_state.status.casecmp(AsyncOperationStatus::SUCCESS_STATUS) == 0).to be true
    end

    it 'should grab Haipa headers from response' do
      response = double('response', :headers =>
                                      { 'Haipa-AsyncOperation' => 'async_operation_header',
                                        'Location' => 'location_header'},
                                    :status => 204)

      haipa_response = double('haipa_response',
                              :request => nil,
                              :response => response,
                              :body => nil)

      polling_state = PollingState.new haipa_response, 0

      expect(polling_state.Haipa_async_operation_header_link).to eq('async_operation_header')
      expect(polling_state.location_header_link).to eq('location_header')
    end

    it 'should grab timeout from constructor' do
      response = double('response', :headers =>
                                      { 'RetryAfter' => 5 },
                        :status => 204)

      haipa_response = double('haipa_response',
                              :request => nil,
                              :response => response,
                              :body => nil)

      polling_state = PollingState.new haipa_response, 3

      expect(polling_state.get_delay).to eq(3)
    end

    it 'should grab timeout from response' do
      response = double('response', :headers =>
                                      { 'Retry-After' => 5 },
                        :status => 204)

      haipa_response = double('haipa_response',
                              :request => nil,
                              :response => response,
                              :body => nil)

      polling_state = PollingState.new haipa_response, nil

      expect(polling_state.get_delay).to eq(5)
    end

    it 'should return succeeded status for a 200 response and no provisioning status' do
      response = double('response', :status => 200, :headers =>
          { 'Haipa-AsyncOperation' => 'async_operation_header',
            'Location' => 'location_header'})
      haipa_response = double('response',
                              :request => nil,
                              :response => response,
                              :body => nil)

      polling_state = PollingState.new haipa_response, 0

      expect(polling_state.status.casecmp(AsyncOperationStatus::SUCCESS_STATUS) == 0).to be true
    end

    it 'should return in progress status for a 201 response and no provisioning status' do
      response = double('response', :status => 201, :headers =>
          { 'Haipa-AsyncOperation' => 'async_operation_header',
            'Location' => 'location_header'})
      haipa_response = double('response',
                              :request => nil,
                              :response => response,
                              :body => nil)

      polling_state = PollingState.new haipa_response, 0

      expect(polling_state.status.casecmp(AsyncOperationStatus::IN_PROGRESS_STATUS) == 0).to be true
    end

  end

end
