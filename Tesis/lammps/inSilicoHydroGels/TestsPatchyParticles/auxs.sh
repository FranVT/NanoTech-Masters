#!/bin/bash

for it in $(seq 1 15);
do
    seedo=$((1234+$it));
    echo "$seedo"
done
