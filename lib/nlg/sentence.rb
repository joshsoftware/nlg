module Nlg  
  class Sentence
  
    attr_accessor :verb, :tense, :pronoun, :voice, :subject, :value, :object
    attr_accessor :complement, :coordination_phrase, :preposition, :aspect
    
    def initialize(args = {})
      specifications = args[:specifications]
      @verb = specifications["verb"] || (raise NlgException.new "Verb is nil") 
      @tense = specifications["tense"] || (raise NlgException.new "tense is nil")
      @pronoun = specifications["pronoun"] || (raise NlgException.new "pronoun is nil")
      @complement = specifications["complement"]  
      @coordination_phrase = specifications["coordination_phrase"]  
      @voice = specifications["voice"]  
      @aspect = specifications["aspect"] || (raise NlgException.new "aspect is nil")
      @preposition = specifications["preposition"]  
      @conjunction = specifications["conjunction"]  
      @subject = args[:subject] || true
    end
    
    #method to build a sentence. Returns the formed sentece to build_paragraph
    def build(object_type, object_details)
      self.value = object_details.value
      @value_type = value.class
      self.value = value.to_sentence(:words_connector => " #{@conjunction} ") if value.is_a?(Array) # connector still remains 'and' 
      self.object = object_type
      formed_sentence = self.form
      return formed_sentence
    end
  
    #method to form the sentence using the given specifications
    def form
      set_tense
      predicate = set_predicate
      formed_sentence = "#{verb} #{predicate}".verb.conjugate :subject => subject, :tense => tense.to_sym, :aspect => aspect.to_sym
      return  "#{formed_sentence} #{complement}" 
    end 
  
    def set_tense
      if tense == "past" and aspect == "habitual" 
        self.aspect = "perfective"
      end
    end
  
    def set_predicate
      predicate = "#{preposition} #{value}"
      if verb == "have"
        if @value_type.to_s == "Array" # @value_type.is_a?(Array) not acting as expected.
          predicate = "#{object} #{preposition} #{value}"
        else
          predicate = "a #{object} #{preposition} #{value}"
        end 
      end
      return predicate
    end
  
  end
end
