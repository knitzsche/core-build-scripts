package main

import (
	"encoding/base64"
	"fmt"
	"io/ioutil"
	"os"
)

func main() {

	str, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		fmt.Println("error:", err)
	}
	input := string(str)
	data, err := base64.StdEncoding.DecodeString(input)
	if err != nil {
		fmt.Println("error:", err)
		return
	}
	fmt.Printf("%s\n", data)
}
