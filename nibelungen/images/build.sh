#!/bin/sh

cd gradle
./docker.sh

if [ $? -ne 0 ]; then
    echo "*********************************"
    echo "Не удалось построить образ Gradle"
    echo "*********************************"
    exit $?
fi

cd ../maven
./docker.sh

if [ $? -ne 0 ]; then
    echo "********************************"
    echo "Не удалось построить образ Maven"
    echo "********************************"
    exit $?
fi

cd ../nibelungen
./docker.sh

if [ $? -ne 0 ]; then
    echo "*************************************"
    echo "Не удалось построить образ Nibelungen"
    echo "*************************************"
    exit $?
else
    echo "******************"
    echo "Все образы собраны"
    echo "******************"
fi
