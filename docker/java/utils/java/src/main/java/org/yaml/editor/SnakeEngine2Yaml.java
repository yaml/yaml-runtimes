package org.yaml.editor;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import org.snakeyaml.engine.v2.api.DumpSettings;
import org.snakeyaml.engine.v2.api.LoadSettings;
import org.snakeyaml.engine.v2.api.StreamDataWriter;
import org.snakeyaml.engine.v2.api.lowlevel.Parse;
import org.snakeyaml.engine.v2.emitter.Emitter;
import org.snakeyaml.engine.v2.events.Event;

public class SnakeEngine2Yaml {

  /**
   * Convert a YAML character stream into events and then emit events back to YAML.
   *
   * @param in  Stream to read YAML from
   * @param out Stream to write YAML to
   */
  void yamlToYaml(final InputStream in, final PrintStream out) throws IOException {
    Parse parser = new Parse(LoadSettings.builder().build());
    Emitter emitter = new Emitter(DumpSettings.builder().build(), new MyDumperWriter(out));
    for (Event event : parser.parseInputStream(in)) {
      emitter.emit(event);
    }
  }

  public static void main(final String[] args) throws IOException {
    new SnakeEngine2Yaml().yamlToYaml(System.in, System.out);
  }

  class MyDumperWriter implements StreamDataWriter {

    private final PrintStream out;

    public MyDumperWriter(PrintStream out) {
      this.out = out;
    }

    @Override
    public void flush() {
    }

    @Override
    public void write(String s) {
      out.print(s);
    }

    @Override
    public void write(String s, int offset, int len) {
      out.append(s, offset, offset + len);
    }
  }
}
