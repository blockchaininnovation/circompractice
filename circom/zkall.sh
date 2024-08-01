#!/bin/bash


rm -rf work/$1

./zkkey.sh $1 12
./zkbuild.sh $1
./zkprove.sh $1 $1
./zkverify.sh $1
./zkcreatesmacon.sh $1
