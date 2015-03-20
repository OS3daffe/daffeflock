#! /bin/bash

while :
do
  d=$(date +%s%N)
  x=$((d-t))
  t=$(date +"%s%N")
  r=1
  if [ $x -gt 200000000 ]
  then
    echo $x
  fi
  until [ $r -eq 0 ]; do
    # mongo 145.100.108.226/daffe --eval "db.dummy.count()" 2> /dev/null > /dev/null
    mongo 145.100.108.226/daffe --eval "db.dummy.insert({y:1})" 2> /dev/null > /dev/null
    r=$?
  done
done