#!/bin/bash

set -e

help() {
    echo "This configues a core img to disable console-conf on first boot"
    echo "Usage: $0 IMG, where IMG is the .img file created by ubuntu-image"
    exit 
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "h" ] || [ "$1" == "help" ]; then
    help
fi

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
loop_path=`findfs LABEL=writable`

echo "loop_path: $loop_path"

mount $loop_path mnt

CLOUD_DISABLED=mnt/system-data/etc/cloud/cloud-init.disabled
if [ -e ${CLOUD_DISABLED} ]; then
   echo "Removing cloud-init.disabled file"
   rm -f ${CLOUD_DISABLED}
else
   echo "No embedded cloud-init.disabled file"
fi

umount $loop_path 

echo "done: $image_name"
