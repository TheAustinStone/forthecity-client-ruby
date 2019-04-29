# frozen_string_literal: true

require 'json'
require 'hawk'
require 'cgi'
require 'uri'
require_relative 'restore_strategies/collection_json_utils'
require_relative 'restore_strategies/api_object'
require_relative 'restore_strategies/api_collectable'
require_relative 'restore_strategies/collection'
require_relative 'restore_strategies/version'
require_relative 'restore_strategies/response'
require_relative 'restore_strategies/client'
require_relative 'restore_strategies/error'
require_relative 'restore_strategies/updateable'
require_relative 'restore_strategies/opportunity'
require_relative 'restore_strategies/user'
require_relative 'restore_strategies/key'
require_relative 'restore_strategies/organization'
require_relative 'restore_strategies/organizations_collection'
require_relative 'restore_strategies/keys_collection'
require_relative 'restore_strategies/signups_collection'
require_relative 'restore_strategies/customer'
require_relative 'restore_strategies/customer_signup'
require_relative 'restore_strategies/customer_signups_collection'
require_relative 'restore_strategies/organization_opportunity'
require_relative 'restore_strategies/organization_opportunities_collection'

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
