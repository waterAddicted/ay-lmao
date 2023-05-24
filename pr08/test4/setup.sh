#!/bin/bash

#prepare
PWD=`pwd`
WORK_DIR=`dirname $0`
WORK_DIR=`readlink -f $WORK_DIR`
cd $WORK_DIR/execute

#create files

echo 2 2 2 > numere.txt
echo 4 4 4 >> numere.txt
echo 5 5 5 >>numere.txt


#cleanup
cd $PWD
