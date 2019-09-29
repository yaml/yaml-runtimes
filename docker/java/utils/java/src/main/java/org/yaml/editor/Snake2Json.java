package org.yaml.editor;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.yaml.snakeyaml.Yaml;

import java.io.*;

public class Snake2Json {
    /**
     * Convert a YAML character stream into a JSON character stream.
     * This is not directly in {@see main} to facilitate JUnit tests.
     * @param in Stream to read YAML from
     * @param out Stream to write JSON to
     */
    void yamlToJson(final InputStream in, final Appendable out) throws IOException {
        final Gson gson = new GsonBuilder().setPrettyPrinting().create();
        for (final Object node : new Yaml().loadAll(in)) {
            gson.toJson(node, out);
            out.append('\n');
        }
    }

    public static void main(final String[] args) throws IOException {
        new Snake2Json().yamlToJson(System.in, System.out);
    }
}
