require "test_helper"

class SentenceTest < ActiveSupport::TestCase

  def setup
    dataset_json = File.read("test/sentence_test_json.txt")
    dataset = JSON.parse(dataset_json)
    @defaults = dataset['defaults']
    @subject = dataset['subjects']['subject']
    @objects = dataset['subjects']['objects']
    @objects.each do |object_type, object_details|
      @sentence_hash= {object_type => object_details}
    end    
  end  

  def teardown

  end

  test "should init sentence" do 
    sentence = Nlg::Sentence.new(:subject => @subject, :specifications => @defaults.merge(@sentence_hash[@sentence_hash.keys.first]["specifications"])) 
    assert_equal @subject, sentence.subject
  end
 
  test "" do 
    @subject = nil
    assert_raise NlgException
      Sentence.new()
    
  end
end
