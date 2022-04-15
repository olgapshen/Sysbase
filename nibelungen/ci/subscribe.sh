#!/bin/sh

if [ "$#" -ne 1 ]; then
    echo "Передайте путь к папке с неподписанным apk"
    exit 1
fi

echo ANDROID_SDK_ROOT           : $ANDROID_SDK_ROOT
echo ANDROID_BUILD_TOOLS_VERSION: $ANDROID_BUILD_TOOLS_VERSION
echo KEYSTORE                   : $KEYSTORE

if [ -f /data/$KEYSTORE ]; then
    echo "Хранилище ключей найдено"
else
    echo "Хранилище ключей не найдено"
    exit 1
fi

if [ -f /data/$PASSWORD ]; then
    echo "Файл с паролем найден"
else
    echo "Файл с паролем не найден"
    exit 1
fi

APK_DIR=$1
PASSWORD=$(cat /data/$PASSWORD)

if [ -d $APK_DIR ]; then
    echo "Переходим в папку с APK"
    cd $APK_DIR
    pwd
else
    echo "Папка с APK не найдена"
    exit 1
fi

cp app-release-unsigned.apk app-release-forsign.apk
echo $PASSWORD | \
    $ANDROID_SDK_ROOT/build-tools/$ANDROID_BUILD_TOOLS_VERSION/apksigner \
    sign \
    --ks /data/$KEYSTORE \
    app-release-forsign.apk
mv app-release-forsign.apk app-release.apk
$ANDROID_SDK_ROOT/build-tools/$ANDROID_BUILD_TOOLS_VERSION/apksigner \
    verify app-release.apk

if [ $? -ne 0 ]; then
    echo "Ошибка при валидации подписи"
    exit $?
fi