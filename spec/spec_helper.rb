$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'restore_strategies_client'
require 'unit_helper'
require 'webmock/rspec'

RSpec.configure do |config|
    config.mock_with :rspec do |mocks|
        mocks.verify_doubled_constant_names = true
    end
end
