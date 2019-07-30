#!/bin/bash

#set -e

help() {
    echo "This creates a core img with the the provided model assertion from the stable channel"
    echo "Usage: $0 MODEL_ASSERTION CHANNEL OUTPUT_DIR"
    echo "    MODEL_ASSERTION is a signed model assertion"
    echo "    CHANNEL is the channel from which the image is built"
    echo "    OUTPUT_DIR is where the image is created and should not exist"
    echo "    LOCAL_SNAP is a local snap to add to the image via the --snap LOCAL_SNAP arg"
    exit 
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "h" ] || [ "$1" == "help" ]; then
    help
fi

if [ "$#" -ne 4 ]; then
    help
    exit 1
fi

if [ $(id -u) -ne 0 ] ; then
    echo "ERROR: needs to be executed as root"
    exit 1
fi

model=$1
channel=$2
dir=$3
snap=$4
echo "model: $model"

read -d '' cmd << EOF 
ubuntu-image 
    snap
    --channel $channel 
    -O $dir 
    --snaps $snap
    $model
EOF

echo $cmd
$cmd

echo "built: $dir, with model: $model, from channel: $channel with local snap $snap"
