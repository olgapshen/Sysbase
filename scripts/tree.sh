#!/bin/bash

# ------------------------------------------------------------------------------
# Использование:
#
# fetch A
# fetch B
# merge C A
# merge D B
# merge E C
# merge E D
# merge F E
# ------------------------------------------------------------------------------

function fetch {
    echo "git checkout $1"
    git checkout $1
    if [ $? -ne 0 ]; then exit 1; fi

    echo "git pull"
    git pull
    if [ $? -ne 0 ]; then exit 1; fi

    echo "git push psheom"
    git push psheom
    if [ $? -ne 0 ]; then exit 1; fi
}

function merge {
    echo "git checkout $1"
    git checkout $1
    if [ $? -ne 0 ]; then exit 1; fi

    echo "git pull"
    git pull
    if [ $? -ne 0 ]; then exit 1; fi

    echo "git merge $2"
    git merge $2
    if [ $? -ne 0 ]; then exit 1; fi

    read -p "Продолжить? [д/н]: " answer
    if [ "$answer" != "д" ]; then exit 0; fi

    echo "git push"
    git push
    if [ $? -ne 0 ]; then exit 1; fi
}
