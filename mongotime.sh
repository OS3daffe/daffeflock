#! /bin/bash

while :
do
  d=$(date +%s%N)
  x=$((d-t))
  t=$(date +"%s%N")
  r=1
  # Only when greater then 5000 msec and not the first UNIX time round
  if [ $x -gt 5000000000 ] && [ $x -lt 1425432109876543210 ]
  then
    echo $x
  fi
  until [ $r -eq 0 ]; do
    # mongo 145.100.108.226/daffe --eval "db.dummy.count()" 2> /dev/null > /dev/null
    mongo 54.155.150.78/daffe --eval "db.dummy.insert({y:1})" 2> /dev/null > /dev/null
    r=$?
  done
done

