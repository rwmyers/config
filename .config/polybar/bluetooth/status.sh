#!/bin/sh
if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
then
  echo "%{F#66ffffff}"
else
  if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]
  then
    echo ""
  else
    echo " " $(echo info | bluetoothctl | grep 'Name' | sed 's/Name: //' )
  fi
fi