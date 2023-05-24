#!/bin/bash

CURRENT_DIRECTORY=`pwd`
WORK_DIR=`dirname $0`
WORK_DIR=`readlink -f $WORK_DIR`

cd $WORK_DIR

#function that will compare to file
#param1 is a file 
#param2
compare_file()
{
    file1=$1
    file2=$2
    if ! test $file1; then
        echo "error in compare_file: $1 is not a file" >&2
        return -1
    fi

    if ! test $file2; then
        echo "error in compare_file: $1 is not a file" >&2
        return -1
    fi

    nr1=$(wc -c "$file1" | cut -d' ' -f 1)
    nr2=$(wc -c "$file2" | cut -d' ' -f 1)
    if [ $nr1 -eq $nr2 ]; then
        cmp "$file1" "$file2">/dev/null
        return $?
    fi
    minim=$nr1
    maxim=$nr2
    if [ $nr2 -lt $minim ]; then
         minim=$nr2
         maxim=$nr1
    fi
 
    dif=$((maxim - minim))
    last_ch1=$(tail -c 1 "$file1")
    last_ch2=$(tail -c 1 "$file2")
    
    if [ $dif -ne 1 ]; then
        return 1
    fi 

    if [ "$last_ch1"="\n" -o "$last_ch1"="\n" ]; then
        cmp -n $minim "$file1" "$file2">/dev/null
        return $?
    fi
    cmp "$file1" "$file2">/dev/null
    return $?
}

#defines
output="output"
output_ok="output.ok"
input_param="input_param"

file_name=`cat $input_param | cut -d ' ' -f 2`


cd ./execute/
cat "$file_name" >"$WORK_DIR/$output"
cd $WORK_DIR

# check diff between "output" and "output.ok"
compare_file "$output" "$output_ok"
status=`echo $?`
#rm $output_tree


cd $CURRENT_DIRECTORY
exit $status
