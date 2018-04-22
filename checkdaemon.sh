#!/bin/bash
# checkdaemon.sh
# Make sure the daemon is not stuck.
# Add the following to the crontab (i.e. crontab -e)
# */30 * * * * ~/wirenode/checkdaemon.sh

previousBlock=$(cat ~/wirenode/blockcount)
currentBlock=$(smartcash-cli getblockcount)

wire-cli getblockcount > ~/wirenode/blockcount

if [ "$previousBlock" == "$currentBlock" ]; then
  wire-cli stop
  sleep 10
  ./wired -daemon
fi
