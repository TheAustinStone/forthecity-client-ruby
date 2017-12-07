# frozen_string_literal: true

require 'spec_helper'

describe RestoreStrategies::Organization do
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

  it 'lists a user\'s organizations' do
    orgs = user.organizations
    expect(orgs).to all be_a(described_class)
  end

  it 'blacklists an organization for a user' do
    org = user.organizations[0]

    expect { user.organizations.delete(org) }.to change {
      user.organizations.count
    }.from(2).to(1)
  end

  it 'lists a user\'s blacklisted organizations' do
    orgs = user.organizations.blacklist
    expect(orgs).to all be_a(described_class)
  end

  it 'removes an organization for a user\'s blacklist' do
    org = described_class.new(id: 2)

    expect { user.organizations << org }.to change {
      user.organizations.count
    }.by(1)
    expect(user.organizations.blacklist.count).to eq 0
  end

  it 'searches orgs with parameters' do
    expect(user.organizations.where(
      name: 'Crescent Project',
      id: '3'
    ).count).to eq 1
  end
end
