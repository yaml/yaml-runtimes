using System;
using System.IO;
using System.Text;
using YamlDotNet.Core;
using YamlDotNet.RepresentationModel;

internal static class Program
{
    static void Main(string[] commandLineArguments)
    {
        Console.InputEncoding = Console.OutputEncoding = Encoding.UTF8;

        if (commandLineArguments.Length == 0)
        {
            new LibYamlEventStream(new Parser(Console.In)).WriteTo(Console.Out);
        }
        else
        {
            using (var reader = File.OpenText(commandLineArguments[0]))
            {
                new LibYamlEventStream(new Parser(reader)).WriteTo(Console.Out);
            }
        }
    }
}
