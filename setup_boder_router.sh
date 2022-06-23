#!/bin/sh

# get openthread source
git clone https://github.com/openthread/ot-br-posix.git --depth 1

# jump to folder source
cd ot-br-posix

# update and setup
./script/bootstrap
#INFRA_IF_NAME=wlan0 ./script/setup
INFRA_IF_NAME=wlan0 BACKBONE_ROUTER=0 OPENTHREAD_CONFIG_BACKBONE_ROUTER_ENABLE=0 OTBR_OPTIONS="-DOTBR_BACKBONE_ROUTER=OFF -DOT_THREAD_VERSION=1.1" ./script/setup
