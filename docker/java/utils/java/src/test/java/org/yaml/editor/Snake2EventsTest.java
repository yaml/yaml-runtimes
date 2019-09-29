package org.yaml.editor;

import org.junit.Test;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;

import static org.junit.Assert.assertEquals;

public class Snake2EventsTest {
    private void checkConversion(final String input, final String expected) throws IOException {
        final StringWriter sw = new StringWriter();
        new Snake2Events().yamlToEvents(new ByteArrayInputStream(input.getBytes(StandardCharsets.UTF_8)), sw);
        assertEquals(expected, sw.toString());
    }

    @Test
    public void testEmptyStream() throws IOException {
        checkConversion("", "+STR\n-STR\n");
    }

    @Test
    public void testEmptyDocument() throws IOException {
        checkConversion("---", "+STR\n+DOC ---\n=VAL :\n-DOC\n-STR\n");
    }

    @Test
    public void testSequence() throws IOException {
        checkConversion("- a\n- [b, 'c']", "+STR\n+DOC\n+SEQ\n=VAL :a\n+SEQ []\n=VAL :b\n=VAL 'c\n-SEQ\n-SEQ\n-DOC\n-STR\n");
    }

    @Test
    public void testMapping() throws IOException {
        checkConversion("a:\n  ? b\n  : c", "+STR\n+DOC\n+MAP\n=VAL :a\n+MAP\n=VAL :b\n=VAL :c\n-MAP\n-MAP\n-DOC\n-STR\n");
    }

    @Test
    public void testAnchor() throws IOException {
        checkConversion("- &abc 1\n- *abc", "+STR\n+DOC\n+SEQ\n=VAL &abc :1\n=ALI *abc\n-SEQ\n-DOC\n-STR\n");
    }

    @Test
    public void testTag() throws IOException {
        checkConversion("- !!str true\n- !foo false", "+STR\n+DOC\n+SEQ\n=VAL <tag:yaml.org,2002:str> :true\n=VAL <!foo> :false\n-SEQ\n-DOC\n-STR\n");
    }
}
