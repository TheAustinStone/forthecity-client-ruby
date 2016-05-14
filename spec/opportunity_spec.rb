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
      opp_raw = RsApi::get_opportunity
      opp_json = JSON.parse(opp_raw)['collection']['items'][0]
      opp = RestoreStrategiesClient::Opportunity.new opp_json, opp_raw, client

      allow(client).to receive(:get_signup).
        and_return(RsApi::get_signup)

      signup = opp.get_signup 1
      expect(signup).to be_a(RestoreStrategiesClient::Signup)
    end
  end

  describe 'submit_signup' do
    it 'throw an error if the object put in is not a signup object' do
      opp_raw = RsApi::get_opportunity
      opp_json = JSON.parse(opp_raw)['collection']['items'][0]
      opp = RestoreStrategiesClient::Opportunity.new opp_json, opp_raw, client

      expect(opp.submit_signup {}).to raise_error(TypeError)
    end

    it 'submit successfully' do
      opp_raw = RsApi::get_opportunity
      opp_json = JSON.parse(opp_raw)['collection']['items'][0]
      opp = RestoreStrategiesClient::Opportunity.new opp_json, opp_raw, client

      expect(client).to recieve(:submit_signup)
    end
  end
end

class RsApi
  def self.submit_signup(signup_raw)
    WebMock::API::stub_request(:any, "localhost").to_return(:status => 202, :body => body)
    http = Net::HTTP.new("localhost")
    http.post("/").body
  end

  def self.get_signup
    body = "{
    \"collection\": {
        \"version\": \"1.0\",
        \"href\": \"/api/opportunities/11/signup\",
        \"items\": [
            {
                \"links\": [
                    {
                        \"href\": \"/api/signup/11\",
                        \"rel\": \"opportunity\",
                        \"name\": \"opportunity\",
                        \"prompt\": \"Back to opportunity\"
                    }
                ]
            }
        ],
        \"template\": {
            \"data\": [
                { \"name\": \"givenName\", \"value\": \"\", \"prompt\": \"First Name\", \"validations\": [ {\"name\": \"presence\"} ] },
                { \"name\": \"familyName\", \"value\": \"\", \"prompt\": \"Last Name\", \"validations\": [ {\"name\": \"presence\"} ] },
                { \"name\": \"telephone\", \"value\": \"\", \"prompt\": \"Phone number\", \"validations\": [ {\"name\": \"presence\"} ] },
                { \"name\": \"email\", \"value\": \"\", \"prompt\": \"Email\", \"validations\": [ {\"name\": \"presence\"} ]},
                { \"name\": \"hasChurch\", \"value\": \"\", \"prompt\": \"Are you part of a church?\", \"validations\": [
                        {
                            \"name\": \"presence\"
                        },
                        {
                            \"name\": \"inclusion\",
                            \"arguments\": [
                                {
                                    \"name\": \"option\",
                                    \"value\": \"yes\",
                                    \"prompt\": \"Yes\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"no\",
                                    \"prompt\": \"No\"
                                }
                            ]
                        }
                    ]
                },
                { \"name\": \"church\", \"prompt\": \"Which Church?*\", \"value\": \"\", \"validations\": [
                        {
                            \"name\": \"presence\",
                            \"dependencies\": [
                                {
                                    \"name\": \"hasChurch\",
                                    \"value\": \"yes\"
                                }
                            ]
                        },
                        {
                            \"name\": \"inclusion\",
                            \"arguments\": [
                                {
                                    \"name\": \"option\",
                                    \"value\": \"theJourneyBibleFellowship\",
                                    \"prompt\": \"The Journey Bible Fellowship\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"christCommunityChurch\",
                                    \"prompt\": \"Christ Community Church\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"allSaintsPresbyterianChurch\",
                                    \"prompt\": \"All Saints Presbyterian Church\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"salinaStreetChurch\",
                                    \"prompt\": \"Salina Street Church\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"austinStoneCC\",
                                    \"prompt\": \"Austin Stone Community Church\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"austinStoneLDP\",
                                    \"prompt\": \"Austin Stone LDP\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"providenceChurch\",
                                    \"prompt\": \"Providence Church\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"austinRidge\",
                                    \"prompt\": \"Austin Ridge\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"other\",
                                    \"prompt\": \"Other\"
                                }
                            ],
                            \"dependencies\": [
                                {
                                    \"name\": \"hasChurch\",
                                    \"value\": \"yes\"
                                }
                            ]
                        }
                    ]
                },
                { \"name\": \"churchOther\", \"prompt\": \"Other Church*\", \"value\": \"\", \"validations\": [
                        {
                            \"name\": \"presence\",
                            \"dependencies\": [
                                {
                                    \"name\": \"church\",
                                    \"value\": \"other\"
                                }
                            ]
                        }
                    ]
                },
                { \"name\": \"churchCampus\", \"prompt\": \"Church campus\", \"value\": \"\", \"validations\": [
                        {
                            \"name\": \"inclusion\",
                            \"arguments\": [
                                {
                                    \"name\": \"option\",
                                    \"value\": \"downtownAM\",
                                    \"prompt\": \"Downtown AM\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"downtownPM\",
                                    \"prompt\": \"Downtown PM\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"stJohnsAM\",
                                    \"prompt\": \"St. Johns AM\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"stJohnsPM\",
                                    \"prompt\": \"St. Johns PM\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"south\",
                                    \"prompt\": \"South\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"west\",
                                    \"prompt\": \"West\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"north\",
                                    \"prompt\": \"North\"
                                }
                            ],
                            \"dependencies\": [
                                {
                                    \"name\": \"church\",
                                    \"value\": \"austinStoneCC\"
                                }
                            ]
                        }
                    ]
                },
                { \"name\": \"comment\", \"prompt\": \"Comments or questions\", \"value\": \"\" },
                {
                    \"name\": \"numOfItemsCommitted\",
                    \"prompt\": \"Number of items committed\",
                    \"value\": 0,
                    \"validations\": [
                        {
                            \"name\": \"range\",
                            \"arguments\": [
                                {
                                    \"name\": \"min\",
                                    \"value\": \"0\"
                                },
                                {
                                    \"name\": \"step\",
                                    \"value\": \"1\"
                                }
                            ]
                        }
                    ]
                },
                {
                    \"name\": \"lead\",
                    \"prompt\": \"How did you hear about this opportunity?\",
                    \"value\": \"\",
                    \"validations\":
                    [
                        {
                            \"name\": \"multi\",
                            \"arguments\": [
                                {
                                    \"name\": \"delimiter\",
                                    \"value\": \",\"
                                }
                            ]
                        },
                        {
                            \"name\": \"inclusion\",
                            \"arguments\": [
                                {
                                    \"name\": \"option\",
                                    \"value\": \"searchingFTC\",
                                    \"prompt\": \"Searching forthecity.org\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"socialMedia\",
                                    \"prompt\": \"Social Media (Twitter, Facebook, etc.)\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"stageAnnouncement\",
                                    \"prompt\": \"Stage Announcement\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"churchBulletinOrFlier\",
                                    \"prompt\": \"Church Bulletin / Flier\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"emailOrNewsletter\",
                                    \"prompt\": \"Email / Newsletter\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"wordOfMouth\",
                                    \"prompt\": \"Word of Mouth\"
                                },
                                {
                                    \"name\": \"option\",
                                    \"value\": \"other\",
                                    \"prompt\": \"Other\"
                                }
                            ]
                        }
                    ]
                }
            ]
        }
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
