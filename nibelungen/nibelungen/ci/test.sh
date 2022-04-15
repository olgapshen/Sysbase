#!/bin/sh

cd nibelungen/output/

[ -f siegfrid.txt ]  && echo "Found Siegrid" || exit 1
[ -f kriemhild.txt ]  && echo "Found Krimhild" || exit 1