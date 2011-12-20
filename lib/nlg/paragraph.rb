module Nlg
  
  class Paragraph
   
    attr_accessor :defaults, :dataset, :sentences
  
    #method to build simple paragraphs. A hash of a valid format to be passed as the dataset.
    def initialize(dataset, defaults)
      @subject = dataset['subject']
      @objects = dataset['objects']
      @defaults = defaults
      @sentences = []
    end
  
    def build
      @objects.each do |object|
        sentence = Sentence.new(:subject => @subject, :specifications => @defaults.merge(object['specifications']))
        @sentences << sentence.build(object)
      end
    end
  end
  
end
