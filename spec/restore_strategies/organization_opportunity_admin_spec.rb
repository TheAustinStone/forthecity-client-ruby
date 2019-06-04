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
    RestoreStrategies::User.find(17_603)
  end

  it 'lists a user\'s opportunities' do
    user.opportunities.each { |o| expect(o.class).to be described_class }
  end

  it 'has a person as the coordinator' do
    opp = user.opportunities.last
    expect(opp.coordinator_object.class).to be RestoreStrategies::Person
  end

  it 'can create an opportunity' do
    opp = described_class.new(
      name: 'Test', regions: %w[North South], times: ['Morning'],
      coordinator_object: RestoreStrategies::Person.new(
        given_name: Faker::Name.first_name,
        family_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        telephone: Faker::PhoneNumber.phone_number
      ),
      ongoing: true,
      location: "#{Faker::Address.street_address} #{Faker::Address.city}",
      status: 'Removed by nonprofit',
      cities: [Faker::Address.city], days: %w[Sunday Friday],
      level: ['Walk'],
      description: Faker::Hipster.paragraph(1, false, 2),
      issues: %w[Education Homelessness], type: 'Service',
      group_types: %w[Family Group], municipalities: %w[Round Rock Hyde Park],
      organization_sfid: '1234567XYZ',
      organization_id: 662
    )

    expect(opp.save).to be true
    expect(opp.id.to_i > 0).to be true
  end

  it 'updates an opportunity' do
    opp = user.opportunities.where(id: '1').first
    type = ['Service', 'Event', 'Gift'].sample
    expect(opp.update(type: type, municipalities: ['Waco'])).not_to be false
    expect(opp.type).to eq type
  end
end
