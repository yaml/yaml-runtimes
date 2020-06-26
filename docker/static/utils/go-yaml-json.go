package main

import (
	"encoding/json"
	"fmt"
	"gopkg.in/yaml.v2"
	"io"
	"os"
)

// out of a suddon I hate go
func convert(i interface{}) interface{} {
	switch x := i.(type) {
	case map[interface{}]interface{}:
		m2 := map[string]interface{}{}
		for k, v := range x {
			m2[k.(string)] = convert(v)
		}
		return m2
	case []interface{}:
		for i, v := range x {
			x[i] = convert(v)
		}
	}
	return i
}

type AllMyYaml interface{}

func main() {
	var body AllMyYaml
	d := yaml.NewDecoder(os.Stdin)
	e := json.NewEncoder(os.Stdout)
	for {
		err := d.Decode(&body)
		if err == io.EOF {
			os.Exit(0)
		}
		// other errors: bail out
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}

		err = e.Encode(convert(body))

		// If converting to json fails
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}
	}
}
