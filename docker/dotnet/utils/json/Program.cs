using System.IO;
using System.Text;
using YamlDotNet.Serialization;

using static System.Console;

internal static class Program
{
    static void Main(string[] commandLineArguments)
    {
        InputEncoding = OutputEncoding = Encoding.UTF8;

        var deserializer = new DeserializerBuilder().Build();
        var yamlObject = deserializer.Deserialize(
            commandLineArguments.Length == 0 ? In : File.OpenText(commandLineArguments[0]));

        var serializer = new SerializerBuilder()
            .JsonCompatible()
            .Build();

        var json = serializer.Serialize(yamlObject);

        WriteLine(json);
    }
}
