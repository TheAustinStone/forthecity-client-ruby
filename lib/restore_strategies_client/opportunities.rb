require_relative 'opportunity'

module RestoreStrategiesClient

  class Opportunities

    attr_reader :client

    def initialize(client)
      @client = client
    end

    def get_all
      response = client.list_opportunities
      init_opps response
    end

    def get(id)
      json_str = client.get_opportunity(id)
      init_opps(json_str)[0]
    end

    def search(params)
      json_str = client.search(params)
      init_opps json_str
    end

    private
      def init_opps(json_str)
        json_obj = JSON.parse(json_str)
        items = json_obj['collection']['items']
        opps = []

        items.each do |item|
          opps.push Opportunity.new(item, json_str, :client)
        end

        opps
      end
  end
end
