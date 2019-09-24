#!/bin/sh

sysevent set ddd_arp_agent-stop

if [ "$?" == "0" ] ; then
  rm -rf /usr/sbin/ddd_arp_agent
  sleep 1
  cp ./ddd_arp_agent /usr/sbin/ 
  sleep 1
  sysevent set ddd_arp_agent-start
fi
