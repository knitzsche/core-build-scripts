#!/bin/bash

if [ $(id -u) -ne 0 ] ; then
    echo "Error: needs to be executed as root"
    exit 1
fi

if [ -z $1 ]; then
    echo "Error: missing arg: image filename"
    exit 1
fi 

df | grep -q sdb1
if [ "$?" -eq "1" ]; then
    echo "Error: /dev/sdb1 is not mounted. Stopping"
    exit 1
fi
df | grep -q sdb2
if [ "$?" -eq "1" ]; then
    echo "Error: /dev/sdb1 is not mounted. Stopping"
    exit 1
fi

img=$1

if [ ! -e $img ]; then
    echo "Error: image file ${img} does not exist."
    exit 1
fi


dd if=$img of=/dev/sdb bs=32MB
sync

exit 0
