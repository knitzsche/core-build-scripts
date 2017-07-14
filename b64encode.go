package main

import (
	"bufio"
	"encoding/base64"
	"fmt"
	"io/ioutil"
	"os"
)

func main() {
	fmt.Printf("%s\n", os.Args[1])
	str, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		fmt.Println("error:", err)
	}
	encoder := base64.NewEncoder(base64.StdEncoding, os.Stdout)
	encoder.Write(str)
	fmt.Println("\n")
	encoder.Close()

	fin := os.Args[2]

	f, err := os.Create(fin)
	if err != nil {
		fmt.Println("error:", err)
	}
	w := bufio.NewWriter(f)

	encoder2 := base64.NewEncoder(base64.StdEncoding, w)
	encoder2.Write(str)
	w.Flush()
}
