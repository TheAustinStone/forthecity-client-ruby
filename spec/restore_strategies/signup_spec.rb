# frozen_string_literal: true

require 'spec_helper'
require 'signup'

describe RestoreStrategies::Signup do
  let(:client) do
    RestoreStrategies::Client.new(
      ENV['TOKEN'],
      ENV['SECRET'],
      ENV['HOST'],
      ENV['PORT']
    )
  end

  let(:params) do
    {
      given_name: 'Jon',
      family_name: 'Doe',
      email: 'jon.doe@example.com',
      telephone: '5124567890',
      campus: 'Test Campus',
      opportunity_id: 37
    }
  end

  it 'gets list of signups for an API user' do
    signups = described_class.where(user_id: 1)
    expect(signups.class).to be Array
    expect(signups.first.class).to be described_class
  end

  describe 'validity' do
    it 'requires given name' do
      params.delete(:given_name)
      signup = described_class.new(params)

      expect(signup.valid?).to be(false)
      expect(signup.errors.messages[:given_name]).to eq(['can\'t be blank'])
    end

    it 'requires family name' do
      params.delete(:family_name)
      signup = described_class.new(params)

      expect(signup.valid?).to be(false)
      expect(signup.errors.messages[:family_name]).to eq(['can\'t be blank'])
    end

    it 'requires telephone number' do
      params.delete(:telephone)
      signup = described_class.new(params)

      expect(signup.valid?).to be(false)
      expect(signup.errors.messages[:telephone]).to(
        eq(['is not a valid phone number'])
      )
    end

    it 'requires email' do
      params.delete(:email)
      signup = described_class.new(params)

      expect(signup.valid?).to be(false)
      expect(signup.errors.messages[:email]).to(
        eq(['is invalid'])
      )
    end

    it 'has a campus attribute' do
      signup = described_class.new(params)
      expect(signup.campus).to eq('Test Campus')
    end

    it 'validates correct inputs' do
      signup = described_class.new(params)
      expect(signup.valid?).to be(true)
    end

    it 'allows committed items' do
      params[:numOfItemsCommitted] = 2
      signup = described_class.new(params)
      expect(signup.valid?).to be(true)
    end
  end

  describe 'save' do
    let(:opp) do
      RestoreStrategies::Opportunity.first
    end

    it 'saves valid signups' do
      params[:opportunity_id] = opp.id
      signup = described_class.new(params)
      expect(signup.save).to be(true)
    end

    it 'does not save invalid signups' do
      params.delete(:email)
      signup = described_class.new(params)

      expect(signup.valid?).to be(false)
      expect(signup.save).to be(false)
    end

    it 'does not save signups for nonexistent opportunity' do
      params[:opportunity_id] = 9999
      signup = described_class.new(params)
      expect(signup.save).to be(false)
    end
  end
end
