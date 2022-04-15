#!/bin/sh

mkdir -p deps
[ -f ../../../core/target/core.jar ] && rsync -a ../../../core/target/core.jar deps/
[ -f ../../../dependencies/lib/ojdbc8.jar ] && rsync -a ../../../dependencies/lib/ojdbc8.jar deps/
cp ../../ci/upload.sh deps/
cp ../../ci/title.sh deps/
cp ../../ci/clean.py deps/
cp ../requirements.txt deps/