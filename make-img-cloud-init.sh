#!/bin/bash

set -e

help() {
    echo "This creates a core img with the the provided model assertion from the stable channel using a cloudiinit file"
    echo "Usage: $0 MODEL_ASSERTION CHANNEL CLOUD_INITI_FILE OUTPUT_DIR"
    echo "    MODEL_ASSERTION is a signed model assertion"
    echo "    CHANNEL is the channel from which the image is built"
    echo "    CLOUD_INIT_FILE is the cloud init file"
    echo "    OUTPUT_DIR is where the image is created and should not exist"
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
cloud_init=$3
dir=$4

ubuntu-image \
    --channel $channel \
    --cloud-init $cloud_init \
    -O $dir\
    $model

echo "built: $dir, with model: $model, with cloud-init file: $cloud_init, from channel: $channel"
