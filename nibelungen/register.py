#!/usr/bin/python3
#
# -*- coding: utf-8 -*-

import os
import sys
import configparser

def help():
    print('Передайте путь к проекту, токен и команду')
    print('Команды могут быть:')
    print(' register    - зарегистрировать')
    print(' dryrun      - сухая прогонка')
    print('Пример:')
    print(' ./register.py /repos/kalevala Ae_o9hd_lz5gLKdbrRSv register')

if len(sys.argv) == 4:
    path  = sys.argv[1]
    token = sys.argv[2]
    command = sys.argv[3]

    path = os.path.join(path, 'reg.ini')

    print('Path     : {}'.format(path))
    print('Token    : {}'.format(token))
    print('Command  : {}'.format(command))

    parser = configparser.ConfigParser()
    parser.read(path)

    desc  = parser.get('CI', 'desc')
    tags  = parser.get('CI', 'tags')
    image = parser.get('CI', 'image')

    print('Desc     : {}'.format(desc))
    print('Tags:    : {}'.format(tags))
    print('Tags     : {}'.format(image))

    cmd = 'docker run --rm -it \
        -v /srv/nibelungen/config:/etc/gitlab-runner \
        gitlab/gitlab-runner:alpine-v13.10.0 register \
        --non-interactive \
        --executor "docker" \
        --docker-image {} \
        --url https://gitlab.belowess.ru/ \
        --registration-token "{}" \
        --tls-ca-file="/etc/gitlab-runner/certs/gitlab.belowess.ru.crt" \
        --description "{}" \
        --tag-list "{}"'
    cmd = cmd.format(image, token, desc, tags)

    if command == 'register':
        os.system(cmd)
    elif command == 'dryrun':
        print()
        print(cmd)
    else:
        print('Неизвестная команда')
else:
    help()
