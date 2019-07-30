#!/bin/bash

set -e

if [ $(id -u) -ne 0 ] ; then
    echo "ERROR: needs to be executed as root"
    exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "ERROR. you must provide the image file as an arg"
    exit 1
fi

image_name=$1
trap finish EXIT 

function finish() {
    kpartx -d $image_name 2>&1 > /dev/null
}

rm -rf mnt
mkdir mnt

kpartx -a $image_name

sleep 2.0
loop_path=`findfs LABEL=system-boot`

echo "loop_path: $loop_path"

mount $loop_path mnt

echo "The image is now mounted in mnt/"

echo "Press any key to unmount and complete"
read

umount $loop_path 
