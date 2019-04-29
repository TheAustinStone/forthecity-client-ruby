# frozen_string_literal: true

require 'spec_helper'
require_relative '../support/factory_girl'

describe RestoreStrategies::OrganizationOpportunity do
  let(:client) do
    RestoreStrategies::Client.new(
      ENV['TOKEN'],
      ENV['SECRET'],
      ENV['HOST'],
      ENV['PORT']
    )
  end

  let(:user) do
    RestoreStrategies::User.find(17603)
  end

  it 'lists a user\'s opportunities' do
    user.opportunities.each { |o| expect(o.class).to be described_class }
  end

  it 'can create an opportunity' do
    opp = described_class.new(
      name: 'Test',
      regions: ['North', 'South'],
      times: ['Morning'],
      coordinator: {
        givenName: Faker::Name.first_name,
        familyName: Faker::Name.last_name,
        email: Faker::Internet.email,
        telephone: Faker::PhoneNumber.phone_number
      },
      ongoing: true,
      location: "#{Faker::Address.street_address} #{Faker::Address.city}",
      status: "Removed by nonprofit",
      cities: [Faker::Address.city],
      days: ['Sunday', 'Friday'],
      level: ['Walk'],
      description: Faker::Hipster.paragraph(1, false, 2),
      issues: ['Education', 'Homelessness'],
      type: 'Service',
      group_types: ['Family', 'Group'],
      municipalities: ['Round Rock', 'Hyde Park'],
      organization_sfid: '1234567XYZ',
      organization_id: 662,
    )

    expect(opp.save).to be true
    expect(opp.id.to_i > 0).to be true 
  end
end
