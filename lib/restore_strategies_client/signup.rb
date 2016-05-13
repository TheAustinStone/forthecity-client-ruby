module RestoreStrategiesClient

  class Signup
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Conversion
    include POSTing
    extend ActiveModel::Naming

    attr_reader :raw, :client, :opportunity

    attr_accessor :given_name, :family_name, :telephone, :email, :comment,
                  :num_of_items_commited, :lead
    validates_length_of :given_name, minimum => 2
    validates_length_of :given_name, minimum => 2
    validates :email, :email => true
    validates :telephone, :phone => true

    field_attr :given_name, :family_name, :telephone, :email, :comment,
                  :num_of_items_commited, :lead

    def initialize(json_obj, json_str, opportunity, client)
      super
      @raw = json_str
      @opportunity = opportunity
      @client = client
    end
  end

  class PhoneValidation < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless Phoner::Phone.isValid? value
        record.errors[attribute] << (options[:message] || "is not a valid phone
        number")
      end
    end
  end
end
