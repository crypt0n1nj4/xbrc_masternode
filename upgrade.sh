#!/bin/bash
# upgrade.sh
# Make sure smartcash is up-to-date
# Add the following to the crontab (i.e. crontab -e)
# 0 0 */1 * * ~/smartnode/upgrade.sh

apt update

if apt list --upgradable | grep -v grep | grep wired > /dev/null
then
  wire-cli stop && sleep 10
  rm ~/.wire/peers.*
  apt install wired -y && ./wired -daemon &
else
  exit
fi
