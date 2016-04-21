require 'net/http'
require 'spec_helper'
require 'json'


describe RestoreStrategiesClient do

  before(:example) do
      @client = RestoreStrategiesClient::Client.new(ENV['TOKEN'], ENV['SECRET'], ENV['HOST'], ENV['PORT'])
  end

  it 'has a version number' do
    expect(RestoreStrategiesClient::VERSION).not_to be nil
  end

  describe 'get_opportunity' do
    it 'responds with 404 code and error when the opportunity doesnt exist' do
      response = @client.get_opportunity(1000000)
      isTrue = response.is_a? Net::HTTPNotFound
      expect(isTrue).to be true
    end

    it 'responds with an opportunity' do
      response = @client.get_opportunity(1)
      response = JSON.parse(response.body)
      href = response['collection']['items'][0]['href']
      expect(href).to eq('/api/opportunities/1')
    end
  end

  describe 'list_opportunities' do
      it 'responds with a list of opportunities' do
        response = @client.list_opportunities.body
        response = JSON.parse(response)
        expect(response['collection']['href']).to eq('/api/opportunities')
        expect(response['collection']['version']).to eq('1.0')
        expect(response['collection']['items'].kind_of?(Array)).to be true
      end
  end

  describe 'search' do
      it 'responds with opportunities based on text search' do
        params = {
          'q' => 'foster care'
        }
        response = @client.search(params).body
        response = JSON.parse(response)
        expect(response['collection']['href']).to eq('/api/search?q=foster+care')
        expect(response['collection']['version']).to eq('1.0')
        expect(response['collection']['items'].kind_of?(Array)).to be true
      end

      it 'responds with opportunities based on search parameters' do
        params = {
          'issues' => ['Education', 'Children/Youth'],
          'region' => ['South', 'Central']
        }
        path = '/api/search?issues[]=Education&issues[]=Children%2FYouth&region[]=South&region[]=Central'
        response = @client.search(params).body
        response = JSON.parse(response)
        expect(response['collection']['href']).to eq(path)
        expect(response['collection']['version']).to eq('1.0')
        expect(response['collection']['items'].kind_of?(Array)).to be true
      end

      it 'responds with opportunities based on text and search parameters' do
        params = {
          'q' => 'foster care',
          'issues' => ['Education', 'Children/Youth'],
          'region' => ['South', 'Central']
        }
        path = '/api/search?q=foster+care&issues[]=Education&issues[]=Children%2FYouth&region[]=South&region[]=Central'
        response = @client.search(params).body
        response = JSON.parse(response)
        expect(response['collection']['href']).to eq(path)
        expect(response['collection']['version']).to eq('1.0')
        expect(response['collection']['items'].kind_of?(Array)).to be true

      end
  end

  describe 'get_signup' do
      it 'responds with a signup template' do
        response = @client.get_signup(1).body
        response = JSON.parse(response)
        expect(response['collection']['version']).to eq('1.0')
        expect(response['collection']['template']['data'].kind_of?(Array)).to be true
      end
  end

  describe 'submit_signup' do
      it 'responds with a 400 code from a bad signup template' do
        template = {
          "familyName" => "Doe",
          "telephone" => "5124567890",
          "email" => "jon.doe@example.com",
          "comment" => "I'm excited!",
          "numOfItemsCommitted" => 1,
          "lead" => "other"
        }
        response = @client.submit_signup(1, template)
        expect(response.code).to eq("400")
      end

      it 'responds with a 202 code if the signup is accepted' do
        template = {
          "givenName" => "Jon",
          "familyName" => "Doe",
          "telephone" => "5124567890",
          "email" => "jon.doe@example.com",
          "comment" => "I'm excited!",
          "numOfItemsCommitted" => 1,
          "lead" => "other"
        }
        response = @client.submit_signup(1, template)
        expect(response.code).to eq("202")
      end
  end
end
