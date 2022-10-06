#!/bin/bash

set -o errexit -o nounset

function register_help() {
    echo "Запуск"
    echo "  register-jdk.sh -h"
    echo "    -h             вывод справки"
    echo "  register-jdk.sh <CERT_FLDR> <JAVA_VER> <COMMAND> <CERTIFICATE> [<DRY_RUN>]"
    echo "    <CERT_FLDR>    папка с сертификатами"
    echo "    <JAVA_VER>     версия JDK: 8 или 11"
    echo "    <COMMAND>      комманда: register или unregister"
    echo "    <CERTIFICATE>  имя сертификатат без расширения"
    echo "    <DRY_RUN>      сухая прогонка: d"
    echo "Примечание:"
    echo "  1. Экспортируйте переменную среды JDK_PATH для регистрации"
    echo "     сертификатов в пользовательском JDK."
    echo "  2. Используйте сухую прогонку для проедворительной проверки"
    echo "     параметров"
    echo "Пример"
    echo "  export JDK_PATH=/opt/jdk-17"
    echo "  register-jdk.sh certs 11 register valkovesi"
}

if [ "$#" -eq 1 ] && [ "$1" = "-h" ]; then
    register_help
    exit 0
elif [ "$#" -ge 4 ]; then
    if [ "$#" -eq 5 ]; then
        export DRY_RUN=1
        echo "Сухая прогонка"
    elif [ "$#" -ne 4 ]; then
        register_help
        exit 1
    fi
else
    register_help
    exit 1
fi

if [[ ! -v JDK_PATH ]]; then
    export JDK_PATH=$(dirname $(dirname $(readlink -f $(which java))))
fi

CRT_FLDR=$1
JAV_VERS=$2
REG_COMD=$3
REG_CERT=$4
REG_JAVA="./${REG_COMD}-jdk${JAV_VERS}.sh $CRT_FLDR $REG_CERT"
echo "JDK_PATH           : $JDK_PATH"
echo "Certificates folder: $CRT_FLDR"
echo "Java version       : $JAV_VERS"
echo "Registry command   : $REG_COMD"
echo "Certificate        : $REG_CERT"

eval $REG_JAVA
