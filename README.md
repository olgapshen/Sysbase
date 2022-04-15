> Carthago delenda est!

# Бело-сине-белая скрижаль

*Версия проекта: 3*

Здесь собраны общие полезные ссылки, команды и шаблоны для работы в экосистеме `Linux`.

Подпроекты:

- [Нибелунги](nibelungen/README.md) - `Gitlab CI Docker Runner`
- [OpenSuse](opensuse/README.md) - Особенности работы в `OpenSuse`
- [Scripts](scripts/README.md) - скрипты автоматизации
- [vimide](vimide/README.md) - как кодить в `vim` под `C++`

# Оглавление

- [Бело-сине-белая скрижаль](#бело-сине-белая-скрижаль)
- [Оглавление](#оглавление)
- [Философия](#философия)
  - [Святая война](#святая-война)
  - [Принцип зёрныщка](#принцип-зёрныщка)
- [Стиль кода](#стиль-кода)
- [Locate](#locate)
- [Lynx](#lynx)
- [Python](#python)
- [Сеть](#сеть)
- [Visual Studio Code](#visual-studio-code)
- [C++](#c)
- [Cygwin](#cygwin)
- [Некоторые заметки](#некоторые-заметки)
- [Полезные ссылки](#полезные-ссылки)

# Философия

Прочитайте стандарт [POSIX][14]

## Святая война

Хочу напомнить, что у нас сейчас идёт не только святая война *Рохана* против *Мордора*,
но и в самом *Мордоре* идёт война с б*О*льшим злом, чем он сам, с `Microsoft`-ом.

К сожалению в мире очень сильно `Wind`-овское лобби, но мы победим!

> Carthago delenda est!

> Життя переможе смерть, а світ – темряву

О том, как великий дьявол коррумпирует наше мироздание, можно почитать [тут][9].

## Принцип зёрныщка

Принцип следуя которому развёрстка данной экосистемы
1. максимально формализована (приведена к модели, описана)
2. возможна, обладая лишь иформацией о структурах, без необходимости копировать бизнесс данные
3. максимально автоматизирована
4. происходит из одной точки входа, без необходимости совершать множество ручных действий

"Принцип зёрнышка" в ПО аналогичен тому, как из посажанного семени вырастает дерево.
Многие компании являются идеальными примерами полностью нарушающими *принцип зёрнышка*, но мы победим.

# Стиль кода

После долгих раздумия, и потдержки ~~путина~~ символа `\t` для отступов и отсутствия `\n` вконце файла,
я пересмотрела некоторые аспекты бытия и решительно отстаиваю пробелы для отступов и перенос строки в конце текстовых файлов. О его важности можно почитать [тут][10].

Поставьте галочку в опции `files.insertFinalNewline` в `VS Code`.

# Locate

Важная утилита для поиска динамических библиотек.

Для работы утилиты, нужно запустить с правами `root` команду: `updatedb`,
но перед этим очень важно исключить некоторые пути поиска. В нагем случае: `/var/lib/docker`.

В файле `/etc/updatedb.conf` добавьте `/var/lib/docker` в `PRUNEPATHS`.

Теперь запустите `sudo updatedb`.

# Lynx

Для проверки доступа к сайтам и проверки `ssl` вам стоит установить `lynx`.

> В общем доступность `ssl` и вообще доступность сайта можно проверить и с помощью: `curl [-k] -vvI https://domain.org`, а затем скачать и установить сертификат с помощью `openssl s_client`, как описано в проекте [`Нибелунги`](nibelungen/README.md), но `Lynx` по истене великая вещь, которая сыграет ещё свою роль в вашем таинственном труде `sys`прога/`dep`опса невидимого фронта, особенно при создании образов `Docker`-а

Для перехода на адресс, нажмите `g` и введите или вставьте `url`, затем `Enter`.

Вы можете производить навигацию по странице с помщью клавишь `[вниз, вверх, влево, вправо]`, а так же `Tab`. При заполнении полей форм, `Lynx` сам распознаёт тип поля: `checkbox`, `text` и тд.

`Lynx` спросит вас разрешение на скачивание `cookie` и прочей информации.

Для выхода `q`.

В общем всё очень похоже на `Vim`.

# Python

`Python` имеет большое значение для превращения `Vim` в `IDE`, так как многие плагины основаны на нём.

На `OpenSuse 15.3` команда `python` запустит `python2.x`, но для дел `vim`-ных нам нужен `python3`. В `OpenSuse` нет стандартного `update-alternatives`, как на `Ubuntu`б по этому просто измените ссылки:

```sh
$ cd /usr/bin
$ ls -la | grep python
# Только если мы имеем симлинк, тогда:
$ sudo rm python
$ sudo ln -s python3 python
```

Конечно у вас уже должен быть установлен `Python3`

---
*Небольшое отступление*.

Иногда нужно установить пакеты `Python`-а именно с `Python2`. По умолчанию `pip` в наши дни будет использовать `Python3`.

Можно было бы сделать следующее:

```sh
# Скачать нужный `get_pip.py`
$ curl -O https://bootstrap.pypa.io/pip/2.7/get-pip.py
# Установить `pip` с `Python2`
$ sudo python2 get-pip.py
```

Но, далее вы получите ошибку:

> ImportError: No module named xml.etree.ElementTree

В связи с этим проще просто портировать проект на `Python3`, [вот][12] различия синтаксиса.

---
Часто вам нужно будет узнать список установленных модулей и их версии.
Для этого используйте: `pip freeze | grep <module>`.

Центральные пакеты `Python3`-а устанавливаются по расположжению: `/usr/lib64/python3.<x>/site-packages/`, но при вызове `pip` устновка будет в `/home/<user>/.local/lib/python3.6/site-packages` по этому `pip` нужно запускать без `sudo`.

Вы всегда можете посмотреть данные по модулю с помощью: `pip show <MODULE>`.

# Сеть

В `OpenSuse` используется утилита ~~Schutzstaffel~~ `ss` заместо `netstat`.

Иногда в скриптах будет необходимо получить `PID` процесса, который слушает определённый порт:

```sh
$ PORT=8081
$ IP=0.0.0.0
$ ss -pln | grep $PORT | grep $IP  | awk '{print $7}' | awk -F"," '{print $2}' | awk -F"=" '{print $2}'
# Всё это можно записать строкой в переменную, и тогда
$ PID=$($COMMAND)
# Теперь процесс можно автоматом завершить
$ kill -9 $PID
```

# Visual Studio Code

Навигация по посещённым участкам:

* Назад: `ctrl + alt + -`
* Вперёд: `ctr + shidt + -`

# C++

Для того, что бы автоматом подставить платформонезависимый идентификатор целого числа в формате `sprintf`, исзользуйте следующий шаблон:

```c++
sprintf(buff, "%" PRId64, num);
```
---
Пример экранирования слешей в путях сохранённых в переменных при передачи переменных команде `sed`:

```sh
$ OLD_LIB=/path/to/old/lib
$ NEW_LIB=/path/to/new/lib
$ sed -i "s/${OLD_LIB//\//\\/}/${NEW_LIB//\//\\/}/" file
```

Вызов `cmake` с конкретным `gcc\g++`:

```sh
#!/bin/bash

export CC=/usr/bin/gcc-9
export CXX=/usr/bin/g++-9

rm -rf CMakeFiles/ CMakeCache.txt cmake_install.cmake *_autogen
cmake .
```

# Cygwin

Для установка `cygwin`-а без прав админа запустите из `cmd` `Windows`-а:

```cmd
> setup-x86_64.exe --no-admin
```

# Некоторые заметки

Размеры папок для всех случаев жизни, включая `Docker`:

```sh
#!/bin/bash
for name in `sudo ls -a $1`; do
  sudo du -sh $1/$name
done
```

# Полезные ссылки

* [SSL CRL/OSCP Habr][1]
* [SSL CRL/OSCP Англ.][2]
* [GitLab CI RegExp][3]
* [CMAKE_BUILD_TYPE (Stackoverflow)][4]
* [Архитектуры процессора][5]
* [Тесты в CMake][6]
* [Linux Локаль][7]
* [Переменные в CMake][8]
* [Комбинации клавишь Vim][11]
* [Использование помощи в Vim][13]

[1]: https://habr.com/ru/post/417521
[2]: https://jamielinux.com/docs/openssl-certificate-authority/certificate-revocation-lists.html
[3]: https://docs.gitlab.com/ee/ci/jobs/job_control.html#regular-expressions
[4]: https://stackoverflow.com/questions/48754619/what-are-cmake-build-type-debug-release-relwithdebinfo-and-minsizerel
[5]: https://habr.com/ru/post/316520
[6]: https://habr.com/ru/post/433822/
[7]: https://www.baeldung.com/linux/locale-environment-variables
[8]: https://cliutils.gitlab.io/modern-cmake/chapters/basics/variables.html
[9]: https://www.kommersant.ru/doc/2260861
[10]: https://semakin.dev/2020/05/no_newline_at_end_of_file
[11]: https://codedepth.wordpress.com/2017/08/23/vi-vim-hotkeys/
[12]: https://pythonworld.ru/osnovy/python2-vs-python3-razlichiya-sintaksisa.html
[13]: https://vimhelp.org/helphelp.txt.html#helphelp.txt
[14]: https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/contents.html
