#!/bin/bash
# upgrade.sh
# Make sure bitrewardsd is up-to-date
# Add the following to the crontab (i.e. crontab -e)
# 0 0 */1 * * ~/xbrnode/upgrade.sh

apt update

if apt list --upgradable | grep -v grep | grep bitrewardsd > /dev/null
then
  bitrewardsd stop && sleep 10
  rm ~/.xbitrewards/peers.*
  apt install bitrewardsd -y && ./bitrewardsd -daemon &
else
  exit
fi
