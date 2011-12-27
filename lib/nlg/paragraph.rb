module Nlg
  
  class Paragraph
   
    attr_accessor :defaults, :dataset, :sentences
  
    # method to set defaults, build_conjugations and initialize other attributes
    def initialize(dataset, defaults)
      @subject = dataset['subject']
      @objects = {}
      @conjugations = {}
      @defaults = defaults
      @sentences = []
      
      dataset['objects'].each do |object_type, object_details|
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
            unless @objects.has_key?(conjugated_object)
              sentence_object = SentenceObject.new(conjugated_object, objects[conjugated_object], "conjugated" => true)
              @objects[conjugated_object] = sentence_object
            end
            @conjugations[parent_object] ||= []
            unless @conjugations[parent_object].include?(conjugated_object) or conjugated_object == parent_object
              if @objects[conjugated_object].conjugated == false
                @objects[conjugated_object].conjugated = true
                @conjugations[parent_object] = @conjugations[parent_object].concat(@conjugations[conjugated_object]).uniq
                @conjugations.delete(conjugated_object)
              end
              @conjugations[parent_object] << conjugated_object
              build_conjugations(conjugated_object, objects, parent_object) # recursive call for building conjugations for a parent_object
            end
          else
            raise NlgException.new "No object named #{conjugation_object}"
          end
        end
      else
        @conjugations[object_type] = [] if @objects[object_type].conjugated == false # adding independent sentences which have no conjugations
      end
    
    end
  end

end
