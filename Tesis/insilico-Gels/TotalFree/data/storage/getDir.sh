#!/bin/bash

# Create a file with directories names

file_name=dirs.txt;
rm -f $file_name;
echo $(ls -d history/damp_CL_variations/system*) >> $file_name 
#echo $(ls -d storage/var-damp/damp*/system*) >> $file_name
#echo $(ls -d system*) >> $file_name
