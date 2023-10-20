#!/bin/bash

printhint() {
    echo "Используйте -h для справки"
    echo "  rsync.sh -h"
}

if [[ "$#" -eq 1 ]] && [[ $1 = "-h" ]]; then
    echo "Синхронизация с удалённым сервером"
    echo "  rsync.sh -h"
    echo "  rsync.sh <REMOTE_PATH> from|to [-y]"
    echo "    from  синхронизация с сервера"
    echo "    to    синхронизация на сервер"
    echo "    -y    запустить в реальности, не в режиме dry run"
    exit 0
elif [[ "$#" -eq 2 ]] || [[ "$#" -eq 3 ]]; then
    REMOTE_PATH=$1
    [[ "${REMOTE_PATH}" != */ ]] && REMOTE_PATH="${REMOTE_PATH}/"

    DIRECTION=$2

    if [[ $DIRECTION = "from" ]]; then
        FROM=$REMOTE_PATH
        TO="."
    elif [[ $DIRECTION = "to" ]]; then
        TO=$REMOTE_PATH
        FROM="."
    else
        printhint
        exit 1
    fi

    if [[ "$#" -eq 3 ]] && [[ $3 = "-y" ]]; then
        echo "Запускаем в реальном режиме"
        ARG=""
    elif [[ "$#" -eq 3 ]]; then
        printhint
        exit 1
    else
        ARG="-n"
    fi
else
    printhint
    exit 1
fi

if [[ -f .rignore ]]; then
    ARG="$ARG --exclude-from=.rignore"
fi

# При передаче с Linux-а на Windows нужно вместо опции -a
# использовать только -r
rsync \
  -avzh \
  $ARG \
  --exclude .rignore \
  --exclude .git \
  --delete \
  $FROM \
  $TO

