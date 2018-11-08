# frozen_string_literal: true

require 'spec_helper'

describe RestoreStrategies::CustomerSignup do
  let(:client) do
    RestoreStrategies::Client.new(
      ENV['TOKEN'],
      ENV['SECRET'],
      ENV['HOST'],
      ENV['PORT']
    )
  end

  let(:user) do
    RestoreStrategies::User.find(1)
  end

  it 'lists a user\'s customers signups' do
    user.customers.signups.each { |s| expect(s.class).to be described_class }
  end
end
