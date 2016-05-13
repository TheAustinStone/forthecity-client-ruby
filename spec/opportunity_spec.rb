require 'net/http'
require 'spec_helper'
require 'json'
require 'opportunities'
require 'webmock'

describe RestoreStrategiesClient do

  let(:client) do
    instance_double('RestoreStrategiesClient::Client')
  end

  describe 'get_signup' do
    it 'get a signup object' do
      opps = RestoreStrategiesClient::Opportunities.new client

      allow(client).to receive(:list_opportunities).
        and_return(RsApi::list_opportunities)

      oppsArray = opps.get_all
      expect(oppsArray).to be_an(Array)
      expect(oppsArray.size).to eq 2

      oppsArray.each do |opp|
        expect(opp).to be_an_instance_of(RestoreStrategiesClient::Opportunity)
      end
    end
  end

  describe 'submit_signup' do
    it 'throw an error if the object put in is not a signup object' do
      opps = RestoreStrategiesClient::Opportunities.new client

    end

    it 'submit successfully' do
      opps = RestoreStrategiesClient::Opportunities.new client

    end
  end
end

class RsApi
  def self.list_opportunities
    body = "{
      \"collection\": {
        \"version\": \"1.0\",
        \"href\": \"/api/opportunities/page/2\",
        \"items\": [
          {
            \"href\": \"/api/opportunities/11\",
            \"data\": [
              { \"name\": \"name\", \"value\": \"Example Opportunity\" },
              { \"name\": \"type\", \"value\": \"Event\" },
              { \"name\": \"featured\", \"value\": true },
              { \"name\": \"description\", \"value\": \"This is an example of what you could say here.\" },
              { \"name\": \"location\", \"value\": \"\" },
              { \"name\": \"itemsCommitted\", \"value\": 1 },
              { \"name\": \"itemsGiven\", \"value\": 3 },
              { \"name\": \"maxItemsNeeded\", \"value\": 12 },
              { \"name\": \"ongoing\", \"value\": true },
              { \"name\": \"organization\", \"value\": \"Volunteer Inc.\" },
              { \"name\": \"instructions\", \"value\": \"Be there at 8am.\" },
              { \"name\": \"giftQuestion\", \"value\": \"How many cans?\" },
              { \"name\": \"days\", \"array\": [\"Monday\", \"Tuesday\"] },
              { \"name\": \"groupType\", \"array\": [\"Family\", \"Individual\"] },
              { \"name\": \"issues\", \"array\": [\"Education\", \"Housing\"] },
              { \"name\": \"region\", \"array\": [\"North\", \"West\"] },
              { \"name\": \"supplies\", \"array\": [\"shoes\", \"hats\"] },
              { \"name\": \"skills\", \"array\": [\"math\", \"reading\"] }
            ],
            \"links\": [
              {
                \"href\": \"/api/opportunities/11/signup\",
                \"rel\": \"opportunitySignup\",
                \"name\": \"signup\",
                \"prompt\": \"Signup for this opportunity\"
              }
            ]
          },
          {
            \"href\": \"/api/opportunities/12\",
            \"data\": [
              { \"name\": \"name\", \"value\": \"Another Example Opportunity\" },
              { \"name\": \"type\", \"value\": \"Event\" },
              { \"name\": \"featured\", \"value\": true },
              { \"name\": \"description\", \"value\": \"This is an another example of what you could say here.\" },
              { \"name\": \"location\", \"value\": \"\" },
              { \"name\": \"itemsCommitted\", \"value\": 1 },
              { \"name\": \"itemsGiven\", \"value\": 3 },
              { \"name\": \"maxItemsNeeded\", \"value\": 12 },
              { \"name\": \"ongoing\", \"value\": true },
              { \"name\": \"organization\", \"value\": \"Volunteer Inc.\" },
              { \"name\": \"instructions\", \"value\": \"Be there at 8am.\" },
              { \"name\": \"giftQuestion\", \"value\": \"How many cans?\" },
              { \"name\": \"days\", \"array\": [\"Monday\", \"Tuesday\"] },
              { \"name\": \"groupType\", \"array\": [\"Family\", \"Individual\"] },
              { \"name\": \"issues\", \"array\": [\"Education\", \"Housing\"] },
              { \"name\": \"region\", \"array\": [\"North\", \"West\"] },
              { \"name\": \"supplies\", \"array\": [\"shoes\", \"hats\"] },
              { \"name\": \"skills\", \"array\": [\"math\", \"reading\"] }
            ],
            \"links\": [
              {
                \"href\": \"/api/opportunities/12/signup\",
                \"rel\": \"opportunity\",
                \"name\": \"signup\",
                \"prompt\": \"Signup for this opportunity\"
              }
            ]
          }
        ],
        \"links\": [
          {
            \"href\": \"/api/opportunities/page/1\",
            \"name\": \"previous_page\",
            \"prompt\": \"Back\",
            \"rel\": \"previous\",
            \"render\": \"link\"
          },
          {
            \"href\": \"/api/opportunities/page/3\",
            \"name\": \"next_page\",
            \"prompt\": \"Next\",
            \"rel\": \"next\",
            \"render\": \"link\"
          }
        ],
        \"queries\": [
          {
            \"href\": \"/api/search\",
            \"rel\": \"search\",
            \"prompt\": \"Search for opportunities\",
            \"data\": [
              {
                \"name\": \"q\",
                \"prompt\": \"(optional) Enter search string\",
                \"value\": \"\"
              },
              {
                \"name\": \"issues\",
                \"prompt\": \"(optional) Select 0 or more issues\",
                \"array\": [
                  \"Children/Youth\",
                  \"Elderly\",
                  \"Family/Community\",
                  \"Foster Care/Adoption\",
                  \"Healthcare\",
                  \"Homelessness\",
                  \"Housing\",
                  \"Human Trafficking\",
                  \"International/Refugee\",
                  \"Job Training\",
                  \"Sanctity of Life\",
                  \"Sports\",
                  \"Incarceration\"
                ]
              },
              {
                \"name\": \"region\",
                \"prompt\": \"(optional) Select 0 or more geographical regions\",
                \"array\": [
                  \"North\",
                  \"Central\",
                  \"East\",
                  \"West\",
                  \"Other\"
                ]
              },
              {
                \"name\": \"time\",
                \"prompt\": \"(optional) Select 0 or more times of day\",
                \"array\": [
                  \"Morning\",
                  \"Mid-Day\",
                  \"Afternoon\",
                  \"Evening\"
                ]
              },
              {
                \"name\": \"day\",
                \"prompt\": \"(optional) Select 0 or more days of the week\",
                \"array\": [
                  \"Monday\",
                  \"Tuesday\",
                  \"Wednesday\",
                  \"Thursday\",
                  \"Friday\",
                  \"Saturday\",
                  \"Sunday\"
                ]
              },
              {
                \"name\": \"type\",
                \"prompt\": \"(optional) Select 0 or more opportunity types\",
                \"array\": [
                  \"Gift\",
                  \"Service\",
                  \"Specific Gift\",
                  \"Training\"
                ]
              },
              {
                \"name\": \"group_type\",
                \"prompt\": \"(optional) Select 0 or more volunteer group types\",
                \"array\": [
                  \"Individual\",
                  \"Group\",
                  \"Family\"
                ]
              }
            ]
          }
        ]
      }
    }"
    WebMock::API::stub_request(:any, "localhost").to_return(:status => 200, :body => body)
    http = Net::HTTP.new("localhost")
    http.get("/").body
  end

  def self.get_opportunity
    body = "{
      \"collection\": {
        \"version\": \"1.0\",
        \"href\": \"/api/opportunities/page/2\",
        \"items\": [
          {
            \"href\": \"/api/opportunities/11\",
            \"data\": [
              { \"name\": \"name\", \"value\": \"Example Opportunity\" },
              { \"name\": \"type\", \"value\": \"Event\" },
              { \"name\": \"featured\", \"value\": true },
              { \"name\": \"description\", \"value\": \"This is an example of what you could say here.\" },
              { \"name\": \"location\", \"value\": \"\" },
              { \"name\": \"itemsCommitted\", \"value\": 1 },
              { \"name\": \"itemsGiven\", \"value\": 3 },
              { \"name\": \"maxItemsNeeded\", \"value\": 12 },
              { \"name\": \"ongoing\", \"value\": true },
              { \"name\": \"organization\", \"value\": \"Volunteer Inc.\" },
              { \"name\": \"instructions\", \"value\": \"Be there at 8am.\" },
              { \"name\": \"giftQuestion\", \"value\": \"How many cans?\" },
              { \"name\": \"days\", \"array\": [\"Monday\", \"Tuesday\"] },
              { \"name\": \"groupType\", \"array\": [\"Family\", \"Individual\"] },
              { \"name\": \"issues\", \"array\": [\"Education\", \"Housing\"] },
              { \"name\": \"region\", \"array\": [\"North\", \"West\"] },
              { \"name\": \"supplies\", \"array\": [\"shoes\", \"hats\"] },
              { \"name\": \"skills\", \"array\": [\"math\", \"reading\"] }
            ],
            \"links\": [
              {
                \"href\": \"/api/opportunities/11/signup\",
                \"rel\": \"opportunitySignup\",
                \"name\": \"signup\",
                \"prompt\": \"Signup for this opportunity\"
              }
            ]
          }
        ]
      }
    }"
    WebMock::API::stub_request(:any, "localhost").to_return(:status => 200, :body => body)
    http = Net::HTTP.new("localhost")
    http.get("/").body
  end
end
