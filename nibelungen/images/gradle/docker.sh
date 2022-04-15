#!/bin/sh

DEF_KEYSTORE=/srv/android_keys/BelowessAPPKey.jks
DEF_PASSWORD=/srv/android_keys/password.txt

if [ ! -f $DEF_KEYSTORE ] || [ ! -f $DEF_PASSWORD ]; then
    if [ "$#" -ne 2 ]; then
        echo "Передайте пути к: хранилищу ключей и файлу с паролем"
        echo "  от квартиры где деньги лежат"
        echo "  файлы могут лежать где угодно"
        echo "  не забудьте примонтировать папку с хранилищем и паролем"
        exit 1
    else
        KEYSTORE=$1
        PASSWORD=$2
    fi
else
    KEYSTORE=$DEF_KEYSTORE
    PASSWORD=$DEF_PASSWORD
fi

if [ -f $KEYSTORE ]; then
    echo "Хранилище найдено"
else
    echo "Хранилище не найдено"
    exit 1
fi

if [ -f $PASSWORD ]; then
    echo "Файл с паролем найден"
else
    echo "Файл с паролем не найден"
    exit 1
fi

./copy.sh

KEYSTORE=$(basename $KEYSTORE)
PASSWORD=$(basename $PASSWORD)

echo KEYSTORE: $KEYSTORE
echo PASSWORD: $PASSWORD

docker build \
    --build-arg ARG_KEYSTORE=$KEYSTORE \
    --build-arg ARG_PASSWORD=$PASSWORD \
    -t belowess_gradle .
