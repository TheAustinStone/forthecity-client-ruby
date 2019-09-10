# frozen_string_literal: true

require 'spec_helper'
require_relative '../support/factory_girl'

describe RestoreStrategies::OrganizationPerson do
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

  it 'lists a user\'s people' do
    user.people.each { |p| expect(p.class).to be described_class }
  end

  it 'can create a person' do
    person = build(:person, organization_id: user.organization_id)
    expect(person.save).to be true
  end

  it 'can update a person' do
    person = user.people.last
    id = person.id

    given_name = Faker::Name.first_name
    family_name = Faker::Name.last_name
    email = Faker::Internet.email

    expect(
      person.update(
        given_name: given_name,
        family_name: family_name,
        email: email
      )
    ).not_to be false
    person = user.people.refresh!.where(id: id).last
    expect(person.given_name).to eq given_name
  end
end
