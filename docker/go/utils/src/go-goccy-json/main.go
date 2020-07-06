package main

import (
	"bytes"
	"fmt"
	"github.com/goccy/go-yaml"
	"github.com/goccy/go-yaml/lexer"
	"github.com/goccy/go-yaml/parser"
	"github.com/goccy/go-yaml/token"
	"io"
	"io/ioutil"
	"os"
)

func main() {

	bytes, err := ioutil.ReadAll(os.Stdin)
	if nil != err {
		panic(err)
	}

	tokens := lexer.Tokenize(string(bytes))
	astFile, err := parser.Parse(tokens, 0)
	if nil != err {
		panic(err)
	}
	if astFile == nil {
		panic("Didn't get a parsed file back!")
	}
	if len(astFile.Docs) == 0 {
		panic(fmt.Sprintf("Found %v docs, expected 1", len(astFile.Docs)))
	}

	for _, doc := range astFile.Docs {
		for parseableToken := doc.Body.GetToken(); parseableToken != nil; parseableToken = parseableToken.Next {
			switch parseableToken.Type {
			case token.MappingKeyType:
			case token.MappingStartType:
				var out map[string]interface{}
				unmarshalAndReencode(bytes, out)
				return
			case token.LiteralType:
			case token.StringType:
				var out string
				unmarshalAndReencode(bytes, out)
				return
			case token.SequenceStartType:
			case token.SequenceEntryType:
				var out []interface{}
				unmarshalAndReencode(bytes, out)
				return
			default:
				fmt.Println("Token: ", parseableToken.Type)
			}
		}
	}
}

func unmarshalAndReencode(data []byte, v interface{}) {
	dec := yaml.NewDecoder(bytes.NewBuffer(data), yaml.UseOrderedMap())
	if err := dec.Decode(&v); err != nil {
		if err == io.EOF {
			return
		}
		panic(err)
	}

	if err := yaml.NewEncoder(os.Stdout, yaml.JSON()).Encode(v); nil != err {
		panic(err)
	}
}
