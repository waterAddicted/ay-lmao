#!/bin/bash

#prepare
PWD=`pwd`
WORK_DIR=`dirname $0`
WORK_DIR=`readlink -f $WORK_DIR`
cd $WORK_DIR/execute

#create files

echo 10 20 > numere.txt
echo 30 >> numere.txt
echo 40 50 60 >>numere.txt

#cleanup
cd $PWD
