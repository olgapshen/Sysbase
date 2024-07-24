#!/bin/sh

if [[ $# -ne 1 ]]; then
    echo "Передайте имя пользователя"
    exit 1
fi

curl --max-time 1 -s -i https://yandex.ru || \
  curl --max-time 1 -k -i -s -u $1 \
    $(curl --max-time 1 -k -i -s http://yandex.ru | \
      grep Location | awk '{print $2}' | tr -d '[:space:]')
