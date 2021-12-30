package org.yaml.editor;

import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.emitter.Emitter;
import org.yaml.snakeyaml.events.DocumentStartEvent;
import org.yaml.snakeyaml.events.Event;
import org.yaml.snakeyaml.reader.UnicodeReader;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.io.Writer;
import java.util.HashMap;
import java.util.Map;

public class Snake2Yaml {
    /**
     * Convert a YAML character stream into events and then emit events back to YAML.
     *
     * @param in  Stream to read YAML from
     * @param out Stream to write YAML to
     */
    void yamlToYaml(final InputStream in, final PrintStream out) throws IOException {
        Yaml input = new Yaml();
        DumperOptions options = new DumperOptions();
        Emitter emitter = new Emitter(new Out(out), options);
        for (Event event : input.parse(new UnicodeReader(in))) {
            if (event.is(Event.ID.DocumentStart)) {
                DocumentStartEvent start = (DocumentStartEvent) event;
                if (start.getTags() != null && tagsAreTheSame(start.getTags())) {
                    emitter.emit(new DocumentStartEvent(null, null, start.getExplicit(), start.getVersion(),
                            new HashMap<>()));
                } else {
                    emitter.emit(event);
                }
            } else {
                emitter.emit(event);
            }
        }
    }

    /**
     * Check if the tags are only default and can be ignored when dumping
     * We have to compensate issue in SnakeYAML - the tags should be empty
     * Probably, something to fix in SnakeYAML
     *
     * @param tags - tags in the DocumentStartEvent
     * @return true when only default tags are present
     */
    private boolean tagsAreTheSame(Map<String, String> tags) {
        if (tags.size() != 2) return false;
        if (!tags.containsKey("!") || !tags.containsKey("!!")) return false;
        else return true;
    }

    public static void main(final String[] args) throws IOException {
        new Snake2Yaml().yamlToYaml(System.in, System.out);
    }

    private class Out extends Writer {
        private PrintStream out;

        public Out(PrintStream out) {
            this.out = out;
        }

        @Override
        public void write(char[] cbuf, int off, int len) throws IOException {
            for (int i = off; i < len; i++) {
                out.write(cbuf[i]);
            }
        }

        @Override
        public void flush() throws IOException {
        }

        @Override
        public void close() throws IOException {
        }
    }
}
