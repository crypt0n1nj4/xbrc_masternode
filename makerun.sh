#!/bin/bash
# makerun.sh
# Make sure smartcashd is always running.
# Add the following to the crontab (i.e. crontab -e)
# */5 * * * * ~/wirenode/makerun.sh

if ps -A | grep wired > /dev/null
then
  exit
else
  ./wired -daemon &
fi
