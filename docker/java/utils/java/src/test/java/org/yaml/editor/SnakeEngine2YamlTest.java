package org.yaml.editor;

import static org.junit.Assert.assertEquals;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;
import org.junit.Test;

public class SnakeEngine2YamlTest {

  private void checkConversion(final String input, final String expected) throws IOException {
    ByteArrayOutputStream uu = new ByteArrayOutputStream();
    final PrintStream sw = new PrintStream(uu);
    new SnakeEngine2Yaml().yamlToYaml(
        new ByteArrayInputStream(input.getBytes(StandardCharsets.UTF_8)), sw);
    assertEquals(expected, uu.toString());
  }

  @Test
  public void simpleIntArray() throws IOException {
    checkConversion("- 1\n- 2\n- 3", "- 1\n- 2\n- 3\n");
  }
}
