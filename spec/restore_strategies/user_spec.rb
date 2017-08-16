# frozen_string_literal: true

require 'net/http'
require 'spec_helper'
require 'json'
require_relative '../support/factory_girl'

church_names = [
  '1st Baptist', 'Community Bible', 'Bible Church', 'United Methodist',
  'Cornerstone', 'Covenant', 'Grace', 'Cross', 'Life', 'Mount Zion',
  'Promise', 'Providence', 'Redeemer', 'St David', 'St John', 'St Paul',
  'St Peter'
]

describe RestoreStrategies::User do
  let(:client) do
    RestoreStrategies::Client.new(
      ENV['TOKEN'],
      ENV['SECRET'],
      ENV['HOST'],
      ENV['PORT']
    )
  end

  it 'finds a user by id' do
    user = described_class.find(1)
    expect(user).to be_a(described_class)
    expect(user.id.to_i).to be(1)
  end

  it 'gets a valid user from the api' do
    user = described_class.find(1)
    expect(user.valid?).to be true
  end

  it 'saves a new user' do
    user = described_class.new(
      given_name: Faker::Name.first_name,
      family_name: Faker::Name.last_name,
      church: church_names[Random.rand(church_names.length - 1)],
      church_size: Random.rand(8000),
      website: "http://#{Faker::Internet.domain_name}",
      email: Faker::Internet.email,
      franchise_city: Faker::Address.city,
      street_address: Faker::Address.street_address,
      address_locality: Faker::Address.city,
      address_region: Faker::Address.state,
      postal_code: Faker::Address.zip
    )
    expect(user.save).to be true
    expect(user.uuid.length).to be 36
  end

  it 'creates a new user' do
    user = described_class.create(
      given_name: Faker::Name.first_name,
      family_name: Faker::Name.last_name,
      church: church_names[Random.rand(church_names.length - 1)],
      church_size: Random.rand(8000),
      website: "http://#{Faker::Internet.domain_name}",
      email: Faker::Internet.email,
      franchise_city: Faker::Address.city,
      street_address: Faker::Address.street_address,
      address_locality: Faker::Address.city,
      address_region: Faker::Address.state,
      postal_code: Faker::Address.zip
    )
    expect(user.class).to be described_class
    expect(user.uuid.length).to be 36
  end

  it 'updates an existing user' do
    church = "Church Name #{Time.now.to_f}"
    user = described_class.find(1)
    expect(user.update(church: church)).not_to be false
    expect(described_class.find(1).church).to eq(church)
  end
end
