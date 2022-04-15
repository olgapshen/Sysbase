#! /usr/bin/python3

import json
import pytz
import requests
from argparse import ArgumentParser
from datetime import datetime, timedelta

import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

API = 'https://gitlab.belowess.ru/api/v4'
KEEP_FIRST=30

class CleanException(Exception):
    def __init__(self, msg):
        super().__init__(msg)

class FetchAccessDenied(CleanException):
    def __init__(self):
        super().__init__('У токена нет прав на выборку, или токен не передан')

class FetchNotSucceed(CleanException):
    def __init__(self, code):
        super().__init__('Выборка списка не успешна, REST код: {}'.format(code))

class DeleteAccessDenied(CleanException):
    def __init__(self):
        super().__init__('У токена нет прав на удаление')

class DeletionNotSucceed(CleanException):
    def __init__(self, code):
        super().__init__('Pipeline не удалён, REST code: {}'.format(code))

def del_pipe(prid, pipe_id, headers):
    url = '{}/projects/{}/pipelines/{}'.format(API, prid, pipe_id)
    if not dryrun:
        resp = requests.delete(
            url,
            headers=headers,
            verify=False)
        code = resp.status_code

        if code == 403:
            raise DeleteAccessDenied()
        elif code != 204:
            raise DeletionNotSucceed(code)
        else:
            print('Удалено')
    else:
        print(url)

def purge(prid, token, page):
    headers = {'PRIVATE-TOKEN': token}
    url = '{}/projects/{}/pipelines?per_page={}&page={}'.format(API, prid, KEEP_FIRST, page)

    resp = requests.get(
        url,
        headers=headers,
        verify=False)

    code = resp.status_code

    if code == 401:
        raise FetchAccessDenied()
    elif code != 200:
        raise FetchNotSucceed(code)

    pipelines = resp.json()


    if len(pipelines) == 0:
        return False

    for pipeline in pipelines:
        pipe_id = pipeline['id']
        s_finished = pipeline['created_at']

        if page > 1:
            print('To delete: {}:{}'.format(s_finished, pipe_id))
            del_pipe(prid, pipe_id, headers)
        else:
            a_finished = s_finished.split(".")
            s_finished = a_finished[0]
            d_finished = datetime.strptime(s_finished, '%Y-%m-%dT%H:%M:%S')
            d_finished = moscovia.localize(d_finished)
            threshold = datetime.now(tz=moscovia) - timedelta(days=days, hours=hours)

            if d_finished < threshold:
                print('To delete: {}:{}'.format(s_finished, pipe_id))
                del_pipe(prid, pipe_id, headers)
            else:
                print('To keep  : {}:{}'.format(s_finished, pipe_id))

    return True

parser = ArgumentParser(description='Очистка старых pipeline-ов')
parser.add_argument('pid', type=int, help='Идентификатор проекта')
parser.add_argument('token', help='Персональный токен владельца проекта')
parser.add_argument('days', type=int, help='Количество дней')
parser.add_argument('hours', type=int, help='Количество часов')
parser.add_argument('-d', '--dryrun', action='store_true', help='Сухая прогонка')
args = parser.parse_args()

pid     = args.pid
token   = args.token
days    = args.days
hours   = args.hours
dryrun  = args.dryrun

print('PID:    {}'.format(pid))
print('Days:   {}'.format(days))
print('Hours:  {}'.format(hours))

if dryrun:
    print('Dryrun: {}'.format(dryrun))

moscovia = pytz.timezone('Europe/Moscow')

try:
    page = 1
    while purge(pid, token, page):
        page += 1
    exit(0)
except CleanException as e:
    print(str(e))
    exit(1)
