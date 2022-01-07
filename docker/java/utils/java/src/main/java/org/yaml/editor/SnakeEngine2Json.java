package org.yaml.editor;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.snakeyaml.engine.v2.api.Load;
import org.snakeyaml.engine.v2.api.LoadSettings;

import java.io.IOException;
import java.io.InputStream;

public class SnakeEngine2Json {
    /**
     * Convert a YAML character stream into a JSON character stream.
     * This is not directly in {@see main} to facilitate JUnit tests.
     * @param in Stream to read YAML from
     * @param out Stream to write JSON to
     */
    void yamlToJson(final InputStream in, final Appendable out) throws IOException {
        final Gson gson = new GsonBuilder().setPrettyPrinting().create();
        Load load = new Load (LoadSettings.builder().build());
        for (final Object node : load.loadAllFromInputStream(in)) {
            gson.toJson(node, out);
            out.append('\n');
        }
    }

    public static void main(final String[] args) throws IOException {
        new SnakeEngine2Json().yamlToJson(System.in, System.out);
    }
}
