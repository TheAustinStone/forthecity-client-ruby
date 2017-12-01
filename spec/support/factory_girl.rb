# frozen_string_literal: true

# spec/support/factory_girl.rb
# RSpec without Rails
require 'factory_girl'
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.find_definitions
  end
end
