#!/bin/bash
# makerun.sh
# Make sure bitrewardsd is always running.
# Add the following to the crontab (i.e. crontab -e)
# */5 * * * * ~/xbrnode/makerun.sh

if ps -A | grep bitrewardsd > /dev/null
then
  exit
else
  ./bitrewardsd -daemon &
fi
