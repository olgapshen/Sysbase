#!/bin/sh

if [ "$#" -ne 2 ]; then
    echo "Генерация заголовка для хранилища пакетов"
    echo "  ./title.sh branch version"
    echo "    branch  : ветка на которой находится код сборки"
    echo "    version : версия сборки"
    exit 1
fi

BRANCH=$1
VERSION=$2
TIMESTAMP=$(TZ=Etc/Greenwich date +"%Y%m%d.%H%M%S")

echo $VERSION-$BRANCH-$TIMESTAMP