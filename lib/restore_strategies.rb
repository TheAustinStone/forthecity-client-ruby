require 'json'
require 'hawk'
require 'cgi'
require 'uri'
require_relative'restore_strategies/version'
require_relative'restore_strategies/response'
require_relative'restore_strategies/client'
require_relative'restore_strategies/error'
require_relative'restore_strategies/opportunity'

# Restore Strategies module
module RestoreStrategies
  @client = nil

  def self.client=(client)
    @client = client
  end

  def self.client
    @client
  end
end
