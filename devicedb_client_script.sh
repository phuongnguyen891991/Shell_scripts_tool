#!/bin/sh

if [ "$1" == "" ] ; then
    return 1
fi

devicedb_client -c getDeviceByMac $1

