#!/bin/bash
help() {
    echo "This signs a given model assertion json with a given key piping the signed assertion to stdout"
    echo "Usage: $0 JSON KEY"
    echo "    JSON is the model json file"
    echo "    KEY is listed by 'snapcraft list-keys'"
    exit 
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "h" ] || [ "$1" == "help" ]; then
    help
fi


if [ "$#" -ne 2 ]; then
    help
    exit 1
fi


model=$1
key=$2

cat $model | snap sign -k  $key
