using System;
using System.IO;
using System.Text;
using YamlDotNet.Core;
using YamlDotNet.Core.Events;

internal static class Program
{
    static void Main(string[] commandLineArguments)
    {
        Console.InputEncoding = Console.OutputEncoding = Encoding.UTF8;

        if (commandLineArguments.Length == 0)
        {
            ConvertToLibYamlStyleAnnotatedEventStream(Console.In, Console.Out);
        }
        else
        {
            using (var reader = File.OpenText(commandLineArguments[0]))
            {
                ConvertToLibYamlStyleAnnotatedEventStream(reader, Console.Out);
            }
        }
    }

    private static void ConvertToLibYamlStyleAnnotatedEventStream(TextReader textReader, TextWriter textWriter)
    {
        var parser = new Parser(textReader);

        while (parser.MoveNext())
        {
            switch (parser.Current)
            {
                case AnchorAlias anchorAlias:
                    textWriter.Write("=ALI *");
                    textWriter.Write(anchorAlias.Value);
                    break;
                case DocumentEnd documentEnd:
                    textWriter.Write("-DOC");
                    if (!documentEnd.IsImplicit) textWriter.Write(" ...");
                    break;
                case DocumentStart documentStart:
                    textWriter.Write("+DOC");
                    if (!documentStart.IsImplicit) textWriter.Write(" ---");
                    break;
                case MappingEnd _:
                    textWriter.Write("-MAP");
                    break;
                case MappingStart mappingStart:
                    textWriter.Write("+MAP");
                    if (mappingStart.Style == MappingStyle.Flow) textWriter.Write(" {}");
                    WriteAnchorAndTag(mappingStart);
                    break;
                case Scalar scalar:
                    textWriter.Write("=VAL");
                    WriteAnchorAndTag(scalar);

                    switch (scalar.Style)
                    {
                        case ScalarStyle.DoubleQuoted: textWriter.Write(" \""); break;
                        case ScalarStyle.SingleQuoted: textWriter.Write(" '"); break;
                        case ScalarStyle.Folded: textWriter.Write(" >"); break;
                        case ScalarStyle.Literal: textWriter.Write(" |"); break;
                        default: textWriter.Write(" :"); break;
                    }

                    foreach (char character in scalar.Value)
                    {
                        switch (character)
                        {
                            case '\b': textWriter.Write("\\b"); break;
                            case '\t': textWriter.Write("\\t"); break;
                            case '\n': textWriter.Write("\\n"); break;
                            case '\r': textWriter.Write("\\r"); break;
                            case '\\': textWriter.Write("\\\\"); break;
                            default: textWriter.Write(character); break;
                        }
                    }
                    break;
                case SequenceEnd _:
                    textWriter.Write("-SEQ");
                    break;
                case SequenceStart sequenceStart:
                    textWriter.Write("+SEQ");
                    if (sequenceStart.Style == SequenceStyle.Flow) textWriter.Write(" []");
                    WriteAnchorAndTag(sequenceStart);
                    break;
                case StreamEnd _:
                    textWriter.Write("-STR");
                    break;
                case StreamStart _:
                    textWriter.Write("+STR");
                    break;
            }
            textWriter.WriteLine();
        }

        void WriteAnchorAndTag(NodeEvent nodeEvent)
        {
            if (!string.IsNullOrEmpty(nodeEvent.Anchor))
            {
                textWriter.Write(" &");
                textWriter.Write(nodeEvent.Anchor);
            }
            if (!string.IsNullOrEmpty(nodeEvent.Tag))
            {
                textWriter.Write(" <");
                textWriter.Write(nodeEvent.Tag);
                textWriter.Write(">");
            }
        }
    }
}
