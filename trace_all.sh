#!/bin/bash

DAFFE_3=54.74.144.100
DAFFE_4=54.145.165.251
DAFFE_5=54.177.53.81
DAFFE_6=175.41.186.101

echo "tracing DAFFE 3"
traceroute $DAFFE_3
echo "==============================================="
echo "tracing DAFFE 4"
traceroute $DAFFE_4
echo "==============================================="
echo "tracing DAFFE 5"
traceroute $DAFFE_5
echo "==============================================="
echo "tracing DAFFE 6"
traceroute $DAFFE_6
echo "==============================================="