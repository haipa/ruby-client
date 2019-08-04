# encoding: utf-8
# Copyright (c) dbosoft GmbH and Haipa Contributors. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'haipa_rest'

module Haipa::Client

  describe ApplicationTokenProvider do
    it 'should throw error if nil data is passed into constructor' do
      expect { ApplicationTokenProvider.new(nil, 'client_id', 'client_secret') }.to raise_error(ArgumentError)
      expect { ApplicationTokenProvider.new(nil, 'client_id', nil) }.to raise_error(ArgumentError)
      expect { ApplicationTokenProvider.new(nil, 'client_id', 'client_secret', nil) }.to raise_error(ArgumentError)
    end
  end

end
