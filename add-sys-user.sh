#!/bin/bash

set -e

help() {
    echo "This configues a core img  by addiing a systmer user assertion."
    echo "(You should also disabled console-conf.)"
    echo "Usage: $0 IMG SYSUSERASSERT, where IMG is the .img file created by ubuntu-image ad SYSUSERASSERT is a valid signed system-user assertion for this model."
    exit 
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "h" ] || [ "$1" == "help" ]; then
    help
fi

if [ $(id -u) -ne 0 ] ; then
    echo "ERROR: needs to be executed as root"
    exit 1
fi

if [ "$#" -ne 2 ]; then
    echo "ERROR, here's help:"
    help
fi

image_name=$1
sys_user_assert=$2
echo "image: $image_name"
echo "system-user assert: $sys_user_assert"

trap finish EXIT 

function finish() {
    kpartx -d $image_name 2>&1 > /dev/null
}

rm -rf mnt
mkdir mnt

kpartx -a $image_name

sleep 2.0
loop_path=`findfs LABEL=writable`

echo "loop_path: $loop_path"

mount $loop_path mnt

# Disable console-conf for the first boot
mkdir -p mnt/system-data/var/lib/snapd/seed/assertions
cp $sys_user_assert mnt/system-data/var/lib/snapd/seed/assertions/

umount $loop_path 

echo "done: $image_name"
