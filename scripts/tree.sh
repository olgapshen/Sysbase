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
# Для подавления вопроса о продолжении установите и экспортируйте следующую
# переменную
# NO_ASK="true"
# export NO_ASK
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

    if [ "$NO_ASK" != "true" ]; then
        read -p "Продолжить? [д/н]: " answer
        if [ "$answer" != "д" ]; then exit 0; fi
    fi

    echo "git push"
    git push
    if [ $? -ne 0 ]; then exit 1; fi
}
