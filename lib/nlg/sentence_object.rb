module Nlg
  class SentenceObject
    attr_accessor :specifications, :value, :object_type, :conjugated

    def initialize(object_type, object_details, options={})
      puts object_details
      @specifications = object_details['specifications'] if object_details['specifications'] 
      @value = object_details['value']
      @object_type = object_type
      @conjugated = options["conjugated"]
    end

  end
end

