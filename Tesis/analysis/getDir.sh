#!/bin/bash

# Create a file with directories names

file_name=dirs.txt;
rm -f $file_name;
echo $(ls -d tests/system*) >> $file_name;
