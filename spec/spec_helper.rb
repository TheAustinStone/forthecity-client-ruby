$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'restore_strategies'
require 'unit_helper'

RSpec.configure do |config|
  config.before(:suite) do
    CLIENT = RestoreStrategies::Client.new(
      ENV['TOKEN'],
      ENV['SECRET'],
      ENV['HOST'],
      ENV['PORT']
    )
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end
end
