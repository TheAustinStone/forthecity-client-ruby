require 'net/http'
require 'spec_helper'
require 'json'
require 'opportunities'

describe RestoreStrategies::Opportunities do
  let(:client) do
    RestoreStrategies::Client.new(
      ENV['TOKEN'],
      ENV['SECRET'],
      ENV['HOST'],
      ENV['PORT']
    )
  end

  let(:opps) do
    described_class.new client
  end

  describe 'get_all' do
    it 'return an array of Opportunity objects' do
      opps_array = opps.get_all
      expect(opps_array).to be_an(Array)
      expect(opps_array.size).to eq 2
      opps_array.each do |opp|
        expect(opp).to be_an_instance_of(RestoreStrategies::Opportunity)
      end
    end
  end

  describe 'get' do
    it 'return null if the opportunity doesn\'t exist' do
      begin
        opps.get 1_000_000
      rescue RestoreStrategies::ResponseError => e
        expect(e.response.code).to eq('404')
      end
    end

    it 'return an Opportunity object' do
      opp = opps.get 1
      expect(opp).to be_an_instance_of(RestoreStrategies::Opportunity)
    end
  end

  describe 'search' do
    it 'return an Opportunity object' do
      opps_list = opps.search 'q' => 'Foster Care'
      expect(opps_list).to be_an(Array)
      expect(opps_list.size).to be 2
      expect(opps_list[0]).to be_an_instance_of(RestoreStrategies::Opportunity)
    end
  end
end
