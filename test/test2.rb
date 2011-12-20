$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "nlg"

dataset_json = File.read("json_place.txt")
dataset = JSON.parse(dataset_json)
puts dataset
paragraph = Nlg::Paragraph.new(dataset["subjects"], dataset["defaults"])
paragraph.build
paragraph.sentences.each do |sentence|
  puts sentence
end


