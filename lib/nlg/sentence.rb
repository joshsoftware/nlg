
class Sentence

  attr_accessor :verb, :tense, :pronoun, :voice, :subject, :value, :object, :complement, :coordination_phrase, :preposition, :aspect
  
  #method to form the sentence using the given specifications
  def to_sentence
    set_tense
    predicate = set_predicate
    sentence = "#{verb} #{predicate}".verb.conjugate :subject => subject, :tense => tense.to_sym, :aspect => aspect.to_sym
    return sentence = "#{sentence} #{complement}" 
  end 

  def set_tense
    if tense == "past" and aspect == "habitual" 
      self.aspect = "perfective"
    end
  end

  def set_predicate
    predicate = "#{preposition} #{value}"
    if verb == "have"
      preposition = "of"
      predicate = "#{object} #{preposition} #{value}" 
    end
    return predicate
  end

end
