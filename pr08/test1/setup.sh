#!/bin/bash

#prepare
PWD=`pwd`
WORK_DIR=`dirname $0`
WORK_DIR=`readlink -f $WORK_DIR`
cd $WORK_DIR/execute

#create files

echo 1 2 3 4 >numere.txt
echo 30 >>numere.txt
echo 4 5 6 >>numere.txt


#cleanup
cd $PWD
