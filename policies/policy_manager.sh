#!/bin/bash

for p in $(ls /policies/*/*.sh)
do
    echo ${p}
    #bash ${p}
done
