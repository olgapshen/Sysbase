#!/bin/sh

if [ "$#" -ne 7 ]; then
    echo "Загрузка артефактов на GitLab:"
    echo "  ./upload.sh token_type token pid package version arch_path arch_name"
    echo "    token_type: тип токена: JOB или PRIVATE"
    echo "    token     : debug для отладочного запуска или token"
    echo "    pid       : идентификатор проекта"
    echo "    package   : имя пакета"
    echo "    version   : версия"
    echo "    arch_path : путь к архиву"
    echo "    arch_name : имя архива"
    exit 1
fi

TOKEN_TYPE=$1
TOKEN=$2
PID=$3
PACKAGE=$4
VERSION=$5
ARCH_PATH=$6
ARCH_NAME=$7

echo TN TYPE: $TOKEN_TYPE
echo PROJ ID: $PID
echo PACKAGE: $PACKAGE
echo VERSION: $VERSION
echo AR_PATH: $ARCH_PATH
echo AR_NAME: $ARCH_NAME

URL="https://gitlab.kalevala.ru/api/v4/projects"
URL="$URL/$PID/packages/generic/$PACKAGE/$VERSION/$ARCH_NAME"


if [ "$TOKEN" != "debug" ]; then
    JSON=$(curl \
        --fail \
        -k \
        --header "$TOKEN_TYPE-TOKEN: $TOKEN" \
        --upload-file $ARCH_PATH \
        $URL)
else
    echo URL: $URL
    JSON="{\"message\":\"201 Created\"}"
fi

if [ $? -ne 0 ]; then
    echo "Ошибка при REST запросе"
    exit $?
fi

echo JSON: $JSON
CODE=$(echo $JSON \
  | sed -n 's/.*:"\([0-9][0-9][0-9]\).*/\1/p')

echo CODE: $CODE

if [ "$CODE" -eq "201" ]; then
    echo Uploaded
    exit 0
else
    echo Error
    exit 1
fi
