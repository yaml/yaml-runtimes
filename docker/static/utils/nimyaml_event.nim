import yaml/stream, yaml/parser, streams

var
  p = initYamlParser()
  events = p.parse(newFileStream(stdin))

for event in events: echo p.display(event)
