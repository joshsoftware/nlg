require "json"
require "verbs"
require "multi_json"
require "/nlg/sentence"



class Paragraph
  
  attr_accessor :defaults, :dataset 

  #method to build simple paragraphs. A hash of a valid format to be passed as the dataset.
  def build_paragraph(dataset)
    full_paragraph = []
    @dataset = dataset
    @defaults = dataset["defaults"]
    dataset["subjects"].each do |subject_hash|
      sentence_count = 0
      subject_hash["objects"].each do |object_hash|
        sentence = Sentence.new
        sentence = init_sentence_specifications(defaults,sentence)
        full_sentence = build_sentence(subject_hash["subject"], object_hash, sentence, sentence_count)
        full_paragraph << full_sentence
        sentence_count = sentence_count + 1 
      end
    end
    full_paragraph.each do |line|
      puts line
    end
  end

  
  #method to build a sentence. Returns the formed sentece to build_paragraph
  def build_sentence(subject, object_hash, sentence, sentence_count)
    sentence.value = object_hash["value"]
    if sentence.value.is_a?(Array)
      sentence.value =  sentence.value.join(',')
    end
    sentence.object = object_hash["object"]
    if sentence_count == 0
      sentence.subject = subject
    else
      sentence.subject = sentence.pronoun.capitalize
    end
    sentence = init_sentence_specifications(object_hash["specifications"], sentence)
    full_sentence = sentence.to_sentence
    return full_sentence
  end

  #method to set the specifications like verb, preposition, tense, pronoun and complement for a sentence
  def init_sentence_specifications(specification_hash, sentence)
   
    sentence.verb = specification_hash["verb"] || defaults["verb"]
    sentence.tense = specification_hash["tense"] || defaults["tense"] 
    sentence.pronoun = specification_hash["pronoun"] || defaults["pronoun"] 
    sentence.complement = specification_hash["complement"] || defaults["complement"] 
    sentence.coordination_phrase = specification_hash["coordination_phrase"] || defaults["coordination_phrase"] 
    sentence.voice = specification_hash["voice"] || defaults["voice"] 
    sentence.aspect = specification_hash["aspect"] || defaults["aspect"] 
    sentence.preposition = specification_hash["preposition"] || defaults["preposition"] 
    return sentence
  
  end

end

