#!/bin/bash

set -e

NETPLAN_FILE="00-custom.yaml"

help() {
    echo "This configues a core img to use a specified netplan file." 
    echo "The netplan file in the image is /etc/netplan/${NETPLAN_FILE}"
    echo "This is typically used with console-conf disabled"
    echo ""
    echo "Usage: $0 IMG NEPLANFILE"
    echo "    IMG is the .img file created by ubuntu-image"
    echo "    NEPLANFILE is a path netplan a file"
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
    help
fi


image_name=$1
netplan_path=$2

netplan=$(cat $netplan_path)

if [ -z "$netplan" ]; then
    echo "Error: netplan seems empty. Is your arg pointing to a real netplan file?" 
    exit 1
fi

trap finish EXIT 

function finish() {
    kpartx -d $image_name 2>&1 > /dev/null
}

rm -rf mnt
mkdir mnt

kpartx -a $image_name

sleep 2.0
loop_path=`findfs LABEL=writable`

mount $loop_path mnt

# ADD modified netplan
mkdir -p mnt/system-data/etc/netplan
cat <<EOF > mnt/system-data/etc/netplan/${NETPLAN_FILE}
$netplan
EOF

umount $loop_path 

echo "done: $image_name"
