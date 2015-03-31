#!/bin/bash

DAFFE_3=54.74.144.100
DAFFE_4=54.145.165.251
DAFFE_5=54.177.53.81
DAFFE_6=175.41.186.101

echo "pinging DAFFE 3"
ping -c 100 $DAFFE_3
echo "==============================================="
echo "pinging DAFFE 4"
ping -c 100 $DAFFE_4
echo "==============================================="
echo "pinging DAFFE 5"
ping -c 100 $DAFFE_5
echo "==============================================="
echo "pinging DAFFE 6"
ping -c 100 $DAFFE_6
echo "==============================================="