#!/bin/sh

# test

for var_name in $(seq 1 100); do
  echo \
    "$var_name: Siegfried hielt bei Bruder Gunther" >> siegfrid.txt
done

for var_name in $(seq 1 100); do
  echo \
    "$var_name: Kriemhild hieß die holde Maid" >> kriemhild.txt
done
