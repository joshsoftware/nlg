require "/home/sricharan/ruby_tests/paragraph"


paragraph = Paragraph.new
dataset_json = File.read("/home/sricharan/ruby_tests/json_thing.txt")
dataset = MultiJson.decode(dataset_json)
paragraph.build_paragraph(dataset)

