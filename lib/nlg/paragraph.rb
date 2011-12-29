module Nlg
  class Paragraph
   
    attr_accessor :defaults, :dataset, :sentences
    # The parameters, dataset and defaults are both hashes.
    # For example:
    #
    # defaults = { "tense" => "present",
    #               "verb" => "have", 
    #               "pronoun" => "it",
    #               "voice" => "active",
    #               "aspect" => "habitual",
    #               "preposition" => "of" }
    #
    # dataset = {"subject"=>"Pune", 
    #            "objects"=>
    #              { "population"=>
    #                  {"value"=>"57841284790", 
    #                   "specifications"=>{}}, 
    #                "rainfall"=>
    #                  {"value"=>"198", 
    #                   "specifications"=>{"complement"=>"mm"}}, 
    #                "high temperature"=>
    #                  {"value"=>"45", 
    #                   "specifications"=>{"complement"=>"°C"}, 
    #                   "conjugated_with"=>["low temperature"]}, 
    #                "low temperature"=>
    #                  {"value"=>"20", 
    #                   "specifications"=>{"complement"=>"°C"}, 
    #                   "conjugated_with"=>["high temperature", "low temperature", "rainfall"]}, 
    #                "forts"=>
    #                  {"value"=>["sinhgad", "lohgad"], 
    #                   "specifications"=>{"preposition"=>"named"}, 
    #                   "conjugated_with"=>["high temperature", "low temperature", "rainfall"]}
    #              }
    #           }
    #
    # method to set defaults, build_conjugations and initialize other attributes
    def initialize(dataset, defaults)
      @subject = dataset['subject']
      @objects = {}
      @conjugations = {}
      @defaults = defaults
      @sentences = []
    
      # Iterating through all the objects and building conjugations.  
      dataset['objects'].each do |object_type, object_details|
        # A check to allow objects to be created with "conjugated" => false only if not already
        # present. build_conjugations method called which recursively builds the conjugations.
        unless @objects.has_key?(object_type)
          sentence_object = SentenceObject.new(object_type, object_details, "conjugated" => false)
          @objects[object_type] = sentence_object
          build_conjugations(object_type, dataset['objects']) 
        end 
      end
 
    end
  
    def build
      puts @conjugations.inspect, @objects.inspect
      # Paragraph generation by generating individual sentences.   
      @objects.each do |object_type, sentence_object|
        sentence = Sentence.new(:subject => @subject, :specifications => @defaults.merge(sentence_object.specifications))
        @sentences << sentence.build(object_type, sentence_object)
      end
    end
    
    # Method called internally in initialize to build conjugations among sentences of a paragraph.
    # The example dataset will give the conjugations,
    # 
    #   @conjugations ={"population"=>[], "forts"=>["low temperature", "rainfall", "high temperature"]}
    def build_conjugations(object_type, objects, parent_object = nil)
      object_details = objects[object_type]
      
      # Condition for setting the parent_object to be passed recursively
      parent_object = object_type unless parent_object
     
      # Creating the @conjugations[parent_object] array recursively to finally
      # build the conjugations.  
      conjugated_with = object_details['conjugated_with']
      
      unless conjugated_with.nil? or conjugated_with.empty?
        conjugated_with.each do |conjugated_object|
          if objects.has_key?(conjugated_object)
           
            # Creating object with "conjugated" => true if its present in "conjugated_with" array. 
            unless @objects.has_key?(conjugated_object)
              sentence_object = SentenceObject.new(conjugated_object, objects[conjugated_object], "conjugated" => true)
              @objects[conjugated_object] = sentence_object
            end
            
            # Creating array if does not already exist.
            @conjugations[parent_object] ||= []
            
            # Checking if currently iterating object included in the array already/is the parent_object itself.
            unless @conjugations[parent_object].include?(conjugated_object) or conjugated_object == parent_object

              # If an already parsed object with "conjugated" = false comes as a conjugation
              # to the object being parsed.
              if @objects[conjugated_object].conjugated == false      
                @objects[conjugated_object].conjugated = true
                @conjugations[parent_object] = @conjugations[parent_object].concat(@conjugations[conjugated_object]).uniq
                @conjugations.delete(conjugated_object)
              end
              
              # Appending to the conjugations array for the parent_object.
              @conjugations[parent_object] << conjugated_object
  
              # recursive call for building conjugations for a parent_object
              build_conjugations(conjugated_object, objects, parent_object)
            end
          else
            raise NlgException.new "No object named #{conjugation_object}"
          end
        end
      else 
   
        # adding independent sentences which have no conjugations 
        @conjugations[object_type] = [] if @objects[object_type].conjugated == false
      end
    
    end
  end

end
