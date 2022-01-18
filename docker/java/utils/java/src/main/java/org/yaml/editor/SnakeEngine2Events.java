package org.yaml.editor;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import org.snakeyaml.engine.v2.api.LoadSettings;
import org.snakeyaml.engine.v2.api.lowlevel.Parse;
import org.snakeyaml.engine.v2.events.Event;

public class SnakeEngine2Events {

  void yamlToEvents(final InputStream in, final Writer out) throws IOException {
    Parse parser = new Parse(LoadSettings.builder().build());
    for (final Event event : parser.parseInputStream(in)) {
      out.write(event.toString());
      out.write('\n');
    }
  }

  public static void main(final String[] args) throws IOException {
    final Writer writer = new OutputStreamWriter(System.out);
    new SnakeEngine2Events().yamlToEvents(System.in, writer);
    writer.close();
  }
}
