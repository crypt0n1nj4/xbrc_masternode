#!/bin/bash
# checkdaemon.sh
# Make sure the daemon is not stuck.
# Add the following to the crontab (i.e. crontab -e)
# */30 * * * * ~/xbrnode/checkdaemon.sh

previousBlock=$(cat ~/xbrnode/blockcount)
currentBlock=$(bitrewardsd getblockcount)

wire-cli getblockcount > ~/wirenode/blockcount

if [ "$previousBlock" == "$currentBlock" ]; then
  bitrewardsd stop
  sleep 10
  ./bitrewardsd -daemon
fi
