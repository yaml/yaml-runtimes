import yaml/stream, yaml/parser, streams

var
  p = newYamlParser()
  events = p.parse(newFileStream(stdin))

echo "+STR"
for event in events: echo p.display(event)
echo "-STR"
