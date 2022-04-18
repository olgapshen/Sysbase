> Carthago delenda est!

# OpenSuse

> Данный мануал является частью великого проекта [`Sysscripts`](../README.md) где я расскажу об особенностях
> платформы `OpenSuse` а так же сборки `Qt`

# Оглавление

- [OpenSuse](#opensuse)
- [Оглавление](#оглавление)
  - [Настройки](#настройки)
  - [Системные скрипты](#системные-скрипты)
  - [Терминал](#терминал)
  - [Внешние папки](#внешние-папки)
  - [Настройка сети](#настройка-сети)
  - [Локаль](#локаль)
  - [Zypper](#zypper)
  - [Сертификаты](#сертификаты)
  - [Git](#git)
- [Сборка Qt](#сборка-qt)
  - [Openssl](#openssl)
  - [Репозиторий и готовые сборки](#репозиторий-и-готовые-сборки)
  - [Подготовка](#подготовка)
  - [Подготовка репозитория](#подготовка-репозитория)
  - [Переход на другие ветки и теги](#переход-на-другие-ветки-и-теги)
  - [Сборка](#сборка)
- [Настройка IDE](#настройка-ide)
  - [Guitar](#guitar)
  - [Visual Code](#visual-code)
- [Сборка проектов](#сборка-проектов)
  - [Cmake](#cmake)
  - [Visual Code](#visual-code-1)
  - [Meld](#meld)
- [Некоторые заметки](#некоторые-заметки)
- [Термины и сокращения](#термины-и-сокращения)
- [Полезные ссылки](#полезные-ссылки)

## Настройки

Разработка на `OpenSuse` будет происходить не с пользователем `root` и не с аппликативным пользователем, с которым будет запускаться приложение в рабочем режиме. Разработка будет происходить с обычными пользователями, состоящими в группе `users`.

Для того, что бы вам было удебнее использовать команду `sudo`, добавьте следующую запись в соответствующий системный файл. Предположим, что имя вашего пользователя: `olga`, тогда его часть `Defaults` будет выглядеть так:

```
Defaults targetpw
ALL     ALL=(ALL) ALL
olga    ALL=(ALL) NOPASSWD:ALL
```

Отключите в `OS` систему автообновлений, иначе придётся столкнуться с назойливой и трудно решаемой проблемой:

> PackageKit blockiert zypper. Dies passiert, wenn Sie ein Aktualisierungsmodul oder eine andere Softwareverwaltungsanwendung benutzen, die PackageKit verwendet.  
> PackageKit beenden? [ja/nein] (nein): j  
> PackageKit läuft noch (wahrscheinlich aktiv).

Для отключения, нужно удалить пакет `plasma5-pk-updates`, сначала найдём его точную версию:

```sh
$ rpm -qa | grep -i plasma5-pk-updates
plasma5-pk-updates-lang-0.3.2-bp153.2.2.1.noarch
plasma5-pk-updates-0.3.2-bp153.2.2.1.x86_64
```

Затем удалим их поочерёдно учитывая конкретные версии:

```sh
$ sudo rpm -e plasma5-pk-updates-lang-0.3.2-bp153.2.2.1.noarch
$ sudo rpm -e plasma5-pk-updates-0.3.2-bp153.2.2.1.x86_64
```

Если процесс запущен и не даёт воспользоваться командой `zypper`, найдите и удалите его с помощью `ps -A` и `kill -9`.

Так же полезно отключить сервис индексации файлов:

```sh
$ balooctl suspend
$ balooctl disable
$ balooctl purge
```

Если сервис не отключается, то его можно ликвидировать по старинке:

```sh
$ ps -ef | greps baloo
$ sudo kill -9 <pid>
```

Всегда следите за состоянием системы и старайтесь избегать программ, которые её неоправданно грузят. Вы можете мониторить производительность, с помощью программы: `htop`.

## Системные скрипты

Для удобства разработки повторяющиеся, рутинные операции на `Linux`-е скомпанованы в скрипты и расположены в репозитории `sysscripts`, который необходимо склонировать в папку `$HOME/repos/`:

```sh
$ cd $HOME/repos
$ git clone git@gitlab.belowess.ru.ru:olga/sysscripts.git
```

Ниже мы проставим путь к этому репозиторию в переменную `$PATH`.

## Терминал

Создайте полезные для работы `export`-ы, `alias`-ы и запустите необходимые скрипты в `.bashrc`:

```sh
# $HOME/.bashrc

# Сконфигурировать сессию для Oracle-а
. /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh

# Пользовательские скрипты для git-а
export PATH=$PATH:$HOME/repos/sysscripts
# Просим man не спрашивать о номере раздела
export MAN_POSIXLY_CORRECT=1
# Устанавливаем путь к репозиторию Qt
export QT_REPO=/opt/qt5repo
# Путь к QT_HOME
export QT_HOME=/opt/qt5/qtbase

# Монтируем папку с хоста в случае виртуалки
alias share="sudo mount -t vboxsf share /mnt/share/"
# Удаляем внутренние репозитории не под контролем корневого репозитория
alias untracked="git ls-files --others --exclude-standard | xargs rm -rf"
# Переконфигурируем Qt
alias qt5config="$QT_REPO/configure \
  -confirm-license \
  -developer-build \
  -opensource \
  -nomake examples \
  -nomake tests"
# полностью очищаем папку
alias fullclean="rm -rf ..?* .[!.]* *"
# Просмотр дерева файловой системы
alias countf="find . -type f | wc -l"
# Объём папки
alias sized="du -sh ."
# Подсчёт количества файлов в папке
alias treeless="tree -L 3 | less"
# Сборка образа CentOS
alias buildcent="docker build -f DockerfileCentOS -t belowess_centos ."
# Сборка образа OpenSuse
alias buildsuse="docker build -f DockerfileOpenSuse -t belowess_suse ."
# Запустить контейнер centos в интерактивном режиме - удалить в будущем
alias runcent="docker run -it belowess_centos /bin/bash"
# Запустить контейнер opensuse в интерактивном режиме - удалить в будущем
alias runsuse="docker run -it belowess_opensuse /bin/bash"
# Удалить файлы сгенерированные CMake
alias cmrm="rm -rf CMakeFiles/ CMakeCache.txt cmake_install.cmake pos_autogen"
```

## Внешние папки

При разработке на виртуальной машине, вам необходимо будет монтировать папки, настроенные как общие. Для этого в первую очередь настройте общую папку в конфигурации виртуальной машины.

Для активации `share`-а рекомендуется использовать `alias`: `share` в `~/.bashrc`:

```sh
$ share
```

При необходимости автомонитования на `OpenSuse` это реализуется с помощью `systemd`.

---
Так же, вы можете сделать эти настройки постоянными, внеся нужные изменения в файл `/etc/fstab`. Но это не рекомендуется, так как образ не будет полностью портабельным на реальный хост.

Вот строка для файла `/etc/fstab` в случае `CentOS`.

```
share    /mnt/share   vboxsf    defaults    0 0
```

## Настройка сети

Если вы запускаете виртуальную машину, всегда выберайте тип сети: "сетевой мост".

Выберите имя хоста, к примеру `nordwind`.

---
Настройте в файле `/etc/sysconfig/network` параметр `HOSTNAME` в формате `<HOSTNAME>.domain.central`, к примеру `nordwind.domain.central`.

Проверьте свой `IP` с помощью комманды `ifconfig`, к примеру он: `10.11.9.70`.

Убедитесь, что `IP` будет постоянным.
Иногда, в случаях когда мы не можем сконфигурировать `DHCP`, а в случае виртуальной машины мы используем сетевой мост,
то единственный способ, это установиnь `IP` постоянным через системные файлы.
На `CentOS` к примеру это `/etc/sysconfig/network-scripts/ifcfg-ethX`.

---
Сделайте тоже самое, что для `CentOS` учитывая, что имя хоста в файлу `/etc/hostname`, а `IP` мы находим командой: `ip a`.

Очень полезно отказаться от Вселенского Протокола `ipv6`, убрав нужную галочку в пунктах меню `YaST`. Остальная конфигурация сети не потдерживается через `YaST`, пусть так и остаётся.

Настраиваем `firewall`:

```sh
$ sudo firewall-cmd --zone=public --add-port=1521/tcp
$ sudo firewall-cmd --permanent --zone=public --add-port=1521/tcp
$ sudo firewall-cmd --list-all
```

Опция `--permanent` обеспечивает сохранность конфигурации между перезагрузками.
Для того, что бы опция приминалась сразу, нужен вызов без опции `--permanent`.

Далее проверяем, что порт слушается с помощью команды ~~Schutzstaffel~~ `ss`:

```sh
$ ss -ln | grep 1521
tcp LISTEN 0 128 0.0.0.0:1521 0.0.0.0:*
```

Для вывода процесса, добавьте `-p`.

При трудностях с доступом к `Oracle`-у на виртуальной машине с хоста, учитывая отсутствие прав на физических хостах и отсутствие возможности установить `telnet`, в целях отладки, можно воспользоваться следующим скриптом `python`-а.
Сам же `python` вы можете установить в рамках пользователя без прав администратора. Предположим, что `IP` виртуальной машины с `OpenSUSE` - `10.11.9.112`:

```python
from telnetlib import Telnet
Telnet('10.11.9.112', 1521).interact()
```

---
Добавляем в `/etc/hosts` строку в формате `<IP> <HOSTNAME>.domain.central <HOSTNAME>`, к примеру:

```
10.11.9.70	nordwind.domain.central nordwind
```

## Локаль

Самое страшное во всём этом деле, это вечная и вездесущая кирилическая `ANSI` кодировка `Wind`-ы.
Она сделает вашу жизнь адом, и заставит раскаятся о дне вашего рождения.
С этой кодировкой вы не сможете прочитать ни одного сообщения в консоли.

Во избежании этой кары, при логине внизу экрана `Login Manager`-а есть возможность выбрать нужную локаль (`English`).

Если выбрать **адский ужас** (`Русский`), то переменная `LANG` должна автоматом принять значение `ru_RU.CP1251`.
Так же должен быть соответствующий вывод комманды `locale`, указывающий русскую кодировку во всех аспектах мироздания.

Для перевода в нормальную локаль **НЕ** надо использовать следующую комманду, а как сказано выше, нужно выбирать необходимую локаль при логине с тех случаях когда `Login Manager` это позволяет:

```sh
localedef -c -f UTF-8 -i en_US en_US.UTF-8
```

Важное замечание:

> При логине с `root`-ом, вы сможете изменить локаль в момент ввода пароля.

---
На `OpenSuse` в `Qt Creator` все файлы проекта открываются в битой кодировке, несмотря на то, что все сохранены в `UTF-8`, в чём можно убедиться включив `hex` режим в `vim`.

О включении `hex` режима в `vim` смотрите часть: [Мискеланоус](#Мискеланоус)

При этом на `CentOS` файлы кода (`.cpp`, `.h`) закодированы в русской `ANSI`. `Linux` говорит нам, что это `ISO-8859`, но `Notepad++` сообщает, что это `Windows 1251`.

```sh
$ file main.cpp
main.cpp: C source, ISO-8859 text
```

В ветке `opensuse` все страницы кода перекодированы в `UTF-8`, при этом местами кодировка не прошла успешно. Постепенно все закракозябренные комментарии и строки кода кирилицы в ветке `opensuse` нужно заменить на оригинальные строки кирилицы в `UTF-8` взятые из ветки `dev`. Об этом ниже.

---
У `Oracle`-а есть важная переменная окружения `NLS_LANG`, которая устанавливает кодировку информации отправляемой с `RDBMS` своему клиенту `OCI`. Она тоже должна установиться в **дикий ужас**, но он не так страшен, так как заточён прочными гранями базы данных.

Эта переменная устанавливается в `OS` и передаётся клиенту `БД`.

`NLS_LANG` должна принять значение `AMERICAN_AMERICA.CL8MSWIN12`.

Это значение проставляется в `/etc/profile`:

```sh
export NLS_LANG='AMERICAN_AMERICA.CL8MSWIN1251'
```

## Zypper

**Zypper - система контроля пакетов**.

Возможно вам предётся добавлять какие то внешние репозитории в систему, но более вероятно, что вам придётся ещё и удалять их.

Вот полезные команды:

```sh
# Обновить статус системы управления пакетами
$ sudo zypper refresh
# Если начинают появлятся красные строки с ошибками, значит некоторые репозитории нужно удалить
# Выводим список репозиториев, должна признать, разработчики постарались на славу, и таблица поистине эстетична и информативна
$ sudo zypper repos
# Берём номера битых репозиториев, и удаляем их за раз
# Важно! Если удалить по одному, то надо не забыть каждый раз вновь посмотреть список, так как каждый раз репозитории будут переиндексироваться
$ sudo zypper removerepo 1 2 ...
# Проверяем что всё вернулось к стабильности
$ sudo zypper refresh
```

После атаки Мордора на Рохан `zypper ref` стал очень долгим, по понятным причинам.
Но к счастью те немногие эльфы, что сохранились в Мордоре создали и сохранили локальные репозитории `OpenSuse`.

Базовый `url` у них: `https://mirror.yandex.ru/opensuse`.

Вам в любом случае будет необходимо заменить оригинальный `url` репозиториев на `yandex`-овский.

Переходим в папку: `/etc/zypp/repos.d`, и пользуемся волшебной командой: `sudo vim *`.

В каждом файле меняем `http[s]://download.opensuse.org` на `https://mirror.yandex.ru/opensuse` в свойствах `baseurl` и `gpgkey`. Переходим на следующий файл внутренней командой: `:wn`, в конце обычное `:wq`.

Затем обновляем репозитории: `sudo zypper ref`.

> В яндексе пока нет `security/SELinux/SLE_15_SP3/`, поэтому ставим просто `security/SELinux/SLE_15/`

Поиск пакета по имени содержимого файла:

```sh
$ zypper se --provides --match-substrings libsso
```

Распаковка файлов и скриптов архива `rpm`.

```sh
$ rpm2cpio oracle-xe-11.2.0-1.0.x86_64.rpm | cpio -idmv
$ rpm -qp --scripts oracle-xe-11.2.0-1.0.x86_64.rpm > scripts.sh
```

## Сертификаты

Сертификаты должны распологаться в папке `/opt/certs`. Создаём новый сертификат:

```sh
$ cd /opt/certs
$ openssl req \
  -newkey rsa:4096 -nodes -sha256 -keyout KoshDomain.key \
  -x509 -days 365 -out KoshDomain.crt \
  -addext "subjectAltName = DNS:$HOSTNAME" \
  -subj "/C=RU/ST=Vologda/L=Vologda/O=Belowess/OU=NIT/CN=$HOSTNAME"
```

Проверьте, что поле `subjectAltName` проставилось:

```sh
$ openssl x509 -in KoshDomain.crt -text | less
```

Установим сертификаты в системе:

```sh
$ sudo cp /opt/certspos.crt /usr/share/pki/trust/
$ sudo update-ca-certificates
```

> При изменениях в сертификате, для применения в `Docker registry`, сам `registry` нужно удалить и пересоздать, так же пересоздать секреты. О `Docker registry` написано ниже

## Git

Стоит настроить следующие настройки `Git`-а на рабочей виртуалке `OpenSuse`. Впишите свои *ФИО* и *git_id*:

```sh
$ git config --global init.defaultBranch main
$ git config --global --edit
# Содержимое файла настроки
1 # This is Git's per-user configuration file.
2 [user]
3 # Please adapt and uncomment the following lines:
4    name = <Фамилия Имя Отчество> (<git_id>)
5    email = git_id@belowess.org
6 [init]
7    defaultBranch = main
```

# Сборка Qt

`Qt` можно собрать из двух источников:

1. Репозиторий
2. Скаченный архив

Репозиторий `Qt` представляет из себя композицию из главного репозитория с подмодулями `git`-а. Скаченный архив обычно содержит `working tree` определённого тега всей этой композиции, и находится в формате `.tar.gz`.

> В сети на данный момент официально есть только репозиторий содержащий теги `Qt 5` и `Qt 6` (в рамках одной композиции). Даже после начала *Третьей Мировой Войны* и ограничений от компании `Qt` в отношении *Святого Мордора* на скачивание своих продуктов, доступ к самому [репозиторию][4] под лицензией `LGPL` открыт! Всё `OpenSource`-ное что есть в мире - это доброе, светлое, не потдерживающие мрак и вселенскую ненависть, поэтому ни какие санкции ни когда не ударят по `OpenSource`-ному сообществу, где бы оно не было. **С нами бог, он нас хранит**.

При этом репозитория `Qt 4` в свободном доступе нет, есть только архивы, их можно скачать лишь с сайта `Qt` и скачивание заблокированно. Ещё до блокировки я успела скачать весьма святой для нас архив: `qt-everywhere-opensource-src-4.7.4.tar.gz`, мы можем им пользоваться, так как содержимое под лицензией `LGPL`, но не сможем больше его скачать легально, без прокси и `VPN`. По сему это тархив нужно хранить и расположить где то в централизованном месте.

Я думала (и даже реализовала задуманное) - загрузить содержимое в виде репозитория на `GitHub`, идея особенно привлекательна учитывая, что при создании образа `Docker`-а нужна лишь команда `git clone`. Но я разочаровалась в этой идее, так как репозиторий предполагает наличие всех веток и тегов версий проекта, плюс репозиторий `Qt`, как сказанно выше - это композиция. Такой самопальный статичный репозиторий, который не будет изменяться, слишком не соответствует правилам красоты и эстетики, и решено было оставить код `Qt 4` в виде архивов.

`Qt 4` не собирается на `OpenSuse 15.3` (и `14.x`, и `13.x` скорее всего и ещё и ещё), но собирается на `CentOS 6`. На новой `OS` вы получите следующую ошибку:

> error: flexible array member ‘inotify_event::name’ not at end of ‘struct QMapPayloadNode<int, inotify_event>’

Сборка `Qt 4` необходима для запуска компиляции нынешней версии проекта на `GitLab CI` в контейнере `Docker`-а на `appsrv-1`, и подробно рассмотрена далее.

## Openssl

> В некоторых случаях вам придётся понизить версию `openssl`, так как некоторые версии `qt` не собираются с установленной на `OpenSuse 15.3` версией `openssl 1.1`.

Необходимо понизить версию `OpenSSL` с `1.1` на `1.0`. Глвное сделать это не удалив половину операционной системы. Если вдруг в результате своих действий вы видете большой список пакетов, которые будут удалены, значит вы зашли не туда.

Общая стратегия:

1. Поудалять как можно больше пакетов `ssl 1.1`
2. Безболезнено подминить на `ssl 1.0`

Некоторые замечания:

1. Как уже сказано, опасайтесь удаления большого количества пакетов
2. В `OpenSuse` используется не `ssl`, а `openssl`
3. Как и в других случая, есть 2 вида пакетов
    1. обычный в формате `libopenssl1_0_0`
    2. `dev` в формате `libopenssl-1_0_0-devel`, обратите в нимание не тире перед версией

Посмотрите какие пакеты у вас установлены:

```sh
$ rpm -qa | grep ssl
```

Удалите то, что можно из версий `1.1`.

Запустите установку `dev` версии `1.0`:

```sh
$ sudo zypper in libopenssl-1_0_0-devel
```

Вам скажут о конфликтах и предложат несколько путей решения, согласитесь на первый: удаление `1.1` с понижением версий некоторых пакетов.

Возможно вам придётся вернуть версию `1.1`, тогда выполните следующее пожертвовав пакетом `mokutil`:

```sh
$ rpm -qa | grep ssl
$ sudo rpm -e mokutil
$ sudo rpm -e libopenssl1_0_0
$ sudo rpm -e libopenssl-1_0_0-devel
$ sudo zypper in openssl-1_1
$ sudo zypper in libopenssl-devel
```

## Репозиторий и готовые сборки

> Важная ремарка! По неустановленным причинам, но предположительно в коммерческих целях, `Qt` достаточно трудно собрать из `OpenSource`-ного репозитория (иного у нас нет). Большинство веток и тегов просто не собираются. Проще всего оказывается собрать тот набор исходников, которые можно скачать с [файлового хранилища][6] `release`-ов.

При этом я не нашла *формальной* разницы между содержимым репозитория переключённого на соответствующий тег и содержимым разархивированного репозитория с файлового хранилища `Qt`. *Формальной*, в плане файлов учавствующих в процессе сборки.

**Далее исследование, которое я провела**.

Скрипт сравнений репозитория и распаковоного архива:

```sh
#!/bin/sh

# Файл diff.sh

diff -qr \
  --exclude=".QT-*" \
  --exclude=".git" \
  --exclude=".gitignore" \
  --exclude=".gitattributes" \
  --exclude=".commit-template" \
  --exclude=".tag" \
  $1 \
  $QT_REPO
```

Скачиваем `release`, к примеру `5.15.2` и разархивируем его содержимое в папку: `/opt/qtsrc`, созданную раннее:

```sh
$ cd /opt/qtsrc
$ wget https://download.qt.io/official_releases/qt/5.15/5.15.2/single/qt-everywhere-src-5.15.2.tar.xz
$ tar -xvf qt-everywhere-src-5.15.2.tar.xz
$ ls /opt/qtsrc/qt-everywhere-src-5.15.2
```

Операции делаем во временной папке.

```sh
$ mkdir /tmp/qtdiff
$ cd /tmp/qtdiff
$ vim diff.sh
$ chmod u+x diff.sh
```
Переключаем наш основной репозиторий на соотетствующий тег:

*Подробнее обо всех коммандах работы с репозиторием `Qt` смотрите ниже*.

```sh
$ cd $QT_REPO
$ git checkout v5.15.2
$ git submodule update --init --recursive --force
$ git submodule foreach --recursive "git clean -dfx" && git clean -dfx
$ untracked
$ git status
# Чистим в ручную, всё что не очистилось, как описано ниже
```

Создаём файл сравнения:

```
$ ./diff.sh /opt/qtsrc/qt-everywhere-src-5.15.2 > diff_5.12.2.log
```

Переключаем наш основной репозиторий на иной, к примеру `v5.6.0` тег:

```sh
$ cd $QT_REPO
$ git checkout v5.6.0
# Выполняем соответствующие действия, как в прошлый раз
```

Создаём второй файл сравнения:

```
$ ./diff.sh /opt/qtsrc/qt-everywhere-src-5.15.2 > diff_5.6.0.log
```

Изучив оба файла, можно достаточно точно сказать, что состояния тегов в репозитори соответствют состояниям `release`-ов в файловом хранилище `Qt`.

> Резюмируя сказанное: если вы работаете с репозиторием, переключайте на `teg`-и только в соответствии с версиями архивов с файлового хранилища `release`-ов `Qt`

## Подготовка

> `Qt` можно установить с помощью отдельного файла установщика, но при этом потребуется не рационально большое дисковое пространоство, что идёт в разрез с принципами систем *АПК* и *встроенных* (`embedded`) систем, поэтому, а так же для полного соблюдения `LGPL` мы устанавливаем `Qt` через сборку исходников

Убедитесь, что установлены необходимые пакеты.

`Build essentials`:

```sh
$ sudo zypper in git-core gcc-c++ make
```

`Libxcb`:

```sh
$	sudo zypper in xorg-x11-libxcb-devel xcb-util-devel xcb-util-image-devel xcb-util-keysyms-devel xcb-util-renderutil-devel xcb-util-wm-devel xorg-x11-devel libxkbcommon-x11-devel libxkbcommon-devel libXi-devel
```

`Qt WebKit`:

```sh
$ sudo zypper in flex bison gperf libicu-devel ruby
```

Не устанавливайте `Qt WebEngine` из за конфликтов.

При сборке `Qt WebEngine` вы можете столкнуться с ещё не решённой ошибкой:

> No package 'nss' found  
> Could not run pkg-config.

Следующие комманды **НЕ** помогают:

```sh
$ pip install nss
$ sudo zypper in libnss_nis2
```

## Подготовка репозитория

Склонируйте репозиторий:

```sh
$ cd $QT_REPO
$ git clone git://code.qt.io/qt/qt5.git
$ cd qt5
```

Выберите нужную ветку-версию, или тег и переключитесь на неё (к примеру `5.6`):

```sh
# Выберите ветку
$ git branch -r
# Или тег
$ git tag
# Переключитесь на ветку или тег
$ git checkout v5.15.2
```

Докачиваем недостающие репозитории, и исключаем `WebEngine`. для этого запускаем скрипт `init-repository`.

> Для тегов пятой версии `Qt` скрипт `init-repository` не всегда срабатывает, по-этому далее мы будем использовать так же команду самого `git`-а

```sh
# Запускаем команду git-а
$ git submodule update --init --recursive --force
# Запускаем основной скрипрт и исключаем WebEngine
$ perl init-repository --module-subset=default,-qtwebengine -f
```

Проверить, что всё хорошо, конечно можно командой `git status` и отсутствием красного цвета в выводе.

Папку для сборки `Qt`: `/opt/qt5`.

## Переход на другие ветки и теги

Если вы переходите на другую ветку/тег, то вам нужно очистить данные предыдущего сотояния.

Для этого используется рекурсивная команда:

```sh
$ git submodule foreach --recursive "git clean -dfx" && git clean -dfx
```

При этом несмотря на ключи `-dfx` в репозитори `Qt` могут остаться некоторые удалённые модули и внутренние репозитории внутри модулей `Qt`. Всё это из за статуса проблемных папок - в них есть папки `.git`.

В этом случае мы получим вот такой вывод:

```sh
$ git status
HEAD detached at v5.15.2
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
  (commit or discard the untracked or modified content in submodules)
        modified:   qt3d (untracked content)
        modified:   qttools (untracked content)

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        qt5compat/
        qtcoap/
```

Тогда требуется поочерёдно войти в каждый модуль, найти что не удаляется очистить, и удалить с помощью команды `rm -rf`:

```sh
$ cd qt3d
$ git status
HEAD detached at 34171b1d9
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        src/3rdparty/assimp/src/

$ rm -rf src/3rdparty/assimp/src/
$ cd ..
$ cd qttools
$ git status
...
$ rm -rf src/assistant/qlitehtml/
# Вернёмся обратно
$ cd ..
```

Пройдёмся по всем `Changes not staged for commit` модулям.

Так же, как уже сказано выше, при переходе на новую версию, у вас образуется: `Untracked files`, удалите это модули, командами `rm -rf`:

```sh
$ rm -rf qt5compat/
$ rm -rf qtcoap/
```

Вы можете автоматизировать процесс удаления *оставленных* `git`-ом папок:

```sh
git ls-files --others --exclude-standard | xargs rm -rf
```

Как сказано выше в `~/.bashrc` следует создать `alias`.

## Сборка

Убедитесь, что переменные `QMAKEPATH` и `QMAKEFEATURES` не установлены.

В `.bashrc` установленна переменная `QT_REPO` с путём к репозиторию `Qt`.

Запустите сборку из созданной ранее папки с помощью `alias`-а `qt5config`:

```sh
$ cd /opt/qt5
$ qt5config
```

В случае, если нужно собрать под иную архитектуру, то необходимо добавить параметр `-platform` с требуемой архитектурой в вызове скрипта `configure`.
Список поддерживаемых архитектур, можно узнать следующим листингом:

```sh
$ ls /opt/qtsrc/qt-everywhere-opensource-src-4.7.4/mkspecs
```

Примите условия лицензии. Начнётся конфигурация для последующей сборки.

Начните сборку с максимальным количеством ядер процессоров, для ускорения процесса:

```sh
$ make -j$(nproc)
```

> Если происходит сбой сборки, и вам нужна ошибка, коорая привела к сбою, запустите `make` без параметра `-j`, что бы избежать распаралеливание и оставить ошибку в последних строчках вывода.

Если нужно переключится на другую ветку или тег, к примеру `v6.2.3`, выполните:

```sh
$ cd $QT_REPO
$ git checkout v6.3.2
# По этому используем средства самого git-а
$ git submodule update --init --recursive --force
# Далее оригинальный скрипт инициализации init-repository
# и обязательно с опцией -f
$ perl init-repository -f
$ git submodule foreach --recursive "git clean -dfx" && git clean -dfx
# При необходимости, если всё плохо, сделайте reset --hard
# git submodule foreach --recursive "git reset --hard" && git reset --hard
# Используйте alias untracked для удаления оставленных файлов
$ untracked
$ cd /opt/qt5
# Очистите целивую папку
$ rm -rf ..?* .[!.]* *
# Запускаем скрипт configure в репозитории Qt
$ qt5config
# Перезапускаем сборку
$ make -j$(nproc)
```

> Если вы собираете в распараллеленом режиме (опция `-j`), и сборка в одном из потоков упала, то при возобновлении, хоть и будучи заранее провальной, сборка вновь может занять очень много времени, так как, как это можно предположить, каждый раз создаётся разная последовательность собираемых модулей.

> Очень важно! Что то вроде `$QT_HOME` в данном случае будет папка /opt/qt5/qtbase

В успешно собранном варианте размер папок и количество файлов будут примерно следубщие:

```sh
$ sized
6.8G    .
$ countf
8961
```

# Настройка IDE

## Guitar

[`Git` клиент][20] идеально интегрированный в нашу экосистему.

1. Клонируем `zlib`
2. Клонируем `Guitar`
3. Устанавливаем `libopenssl1_0_0` заместо весии `1_1`
4. Собираем `Guitar`

*По поводу конфликта между версиями `ssl`, смотрите [соответствующую главу](#openssl)*

> Сборка `zlib` происходит из проекта `Guitar`

Ниже общий необходимый набор команд:

```sh
# Соглашаемся на удаление
$ sudo zypper in libopenssl1_0_0
# Переходим в папку с репозиториями
$ cd $HOME/repos
# Клонируем zlib
$ git clone https://github.com/madler/zlib.git
# Клонируем Guitar
$ git clone https://github.com/soramimi/Guitar.git
# Переходим в проект
$ cd Guitar
# Подготавливаем проект
$ ruby prepare.rb
# Конфигурируем zlib
$ qmake zlib.pro
# Собираем zlib
$ make -j$(nproc)
# Конфигурируем Guitar
$ qmake Guitar.pro
# Собираем Guitar
$ make -j$(nproc)
```

Для сборки приложения  с символами отладки, запустите оба `qmake`-а с опциями: `CONFIG+=debug CONFIG+=declarative_debug`:

```sh
$ qmake CONFIG+=debug CONFIG+=declarative_debug zlib.pro
$ make -j$(nproc)
$ qmake CONFIG+=debug CONFIG+=declarative_debug Guitar.pro
$ make -j$(nproc)
```

Если вы до этого уже собирали проекты в режиме `release`, то у вас есть уже скомпилированные `*.o` файлы.
При попытки отладки с `Termdebug` вы получите ошибку при попытке поставить точку останова:

> No source file named ...

В это случае удалите все файлы пораждённые сборкой и пересоберите заново.

## Visual Code

Создайте в корне проекта заигнорированную папку `.vscode`.

Создайте файл `.vscode/c_cpp_properties.json` (путь относительно корня проекта) с содержимым:

```sh
{
  "configurations": [
    {
      "name": "Linux",
      "includePath": [
        "${workspaceFolder}/**",
        "${workspaceFolder}/build/pos_autogen/include/*",
        "${ORACLE_HOME}/rdbms/public",
        "/opt/qt5/include/**"
      ],
      "defines": [],
      "compilerPath": "/usr/bin/gcc",
      "cStandard": "gnu11",
      "cppStandard": "gnu++14",
      "intelliSenseMode": "linux-gcc-x64",
      "configurationProvider": "ms-vscode.cmake-tools"
    }
  ],
  "version": 4
}
```

# Сборка проектов

## Cmake

Модули `Qt` в плане `Cmake` соответствуют следующему шаблону:

```
<prefix>/(lib/<arch>|lib*|share)/cmake/<name>*/                 (U)
```

Но главное это помнить о понятии `qtbase`.
Если `Qt` собран с опцией `-developer-build`, то это папка `qtbase` в корне установки `Qt`.
Корень установки `Qt` у нас всегда `/opt/qt[4|5]`.
Если сборка была без этой опции, то `qtbase` это просто папка корня `Qt`.

В `CMake` нужно установить переменную `CMAKE_PREFIX_PATH` в `qtbase`:

```cmake
set(CMAKE_PREFIX_PATH /opt/qt5)
```

Команды `CMake` для сборки проекта через командную строку находятся в файле: `build.gradle`:

```sh
$ cmake -S . -B build -DCMAKE_BUILD_TYPE:STRING=<debug|release>
$ cmake --build build -j $(nproc)
```

## Visual Code

Установите `plugin`-ы `CMake` и `Cmake Tools` от `twxs` и `Microsoft`. Далее в левой панели появится перспектива `CMake`.
В этой перспективе у вас будут опции конфигурации, сборки, запуска и отладки проекта.

Требуемые плагины для работы в `Visual Studio Code`:

* `Better C++ Syntax` (*Jeff Hykin*)
* `C/C++` (*Microsoft*)
* `C/C++ Extension Pack` (*Microsoft*)
* `C/C++ Themes` (*Microsoft*)
* `CMake` (*twxs*)
* `CMake Tools` (*Microsoft*)
* `Markdown All in One` (*Yu Zhang*)
* `PlantUML` (*jebbs*)
* `Qt tools` (*tonka3000*)
* `Trailing Spaces` (*Shardul Mahadik*)

Навигация по посещённым участкам:

* Назад: `ctrl + alt + -`
* Вперёд: `ctr + shidt + -`

Команды плагина `Cmake-Tools`:

* `Build` - `F7`
* `Debug` - `Ctrl + F5`

## Meld

К сожалению в `Linux`-ах нет настолько удобного инструмента как `TortoiseGit`, который позволяет делать
интерактивное слияние любой ветки в рабочее пространство. Поэтому необходимо использовать `meld`, который устанавливается с помощью
`sudo zypper in meld`.

1. В репозитории переключитесь на ветку **В КОТОРУЮ** планируем слияние: `git checkout <target_branch>`
3. Создайте новую ветку командой `git checkout -b <target_branch>-meld`
4. Переключите индекс на исходную ветку c которой планируем слиять: `git reset --soft <source_branch>`
5. Запустите `Meld` и в интерфейса выберите опцию `Version Control View`
6. Задайте путь к репозиторию
7. При необходимости, перегружайте рабочее пространство в `Meld` клавишей `F5`
8. Совершите интерактивное слияние
9. Закоммитьте изменения командами `git add .` и `git commit ...`
10. Переключитесь на целевую ветку: `git checkout <target_branch>`
11. Совершите слияние из промежуточной ветки командой `git merge <target_branch>-meld`
12. Залейте изменения на `GitLab`, убедитесь, что всё собирается на `CI`

# Некоторые заметки

Полезные команды терминала:

```sh
# Скачивание файла с curl
$ curl -O https://domain.org/file
# Поиск в файловой системе по шаблону имени файла
$ find /some/where -name "startsWith*"
# Сортировать фалы по кол-ву строк
$ find . -type f -name "*.cpp" -exec wc -l {} + | sort -rn
# Команда с помощью которой можно проверить тип системы инициализации
$ ps -s1 | awk '{print $4}'| grep -Ev "CMD"
# Поиск в `yum` по частичному имени пакета
$ yum search <partial-name>
# Взять `fingerprint` с ключа:
$ ssh-keygen -E md5 -lf id_rsa
# Скопировать файл в контейнер Docker-а
$ docker copy <file> <container_id>:/path
# Поиск по содержимому файлов
$ grep -ilR
```
---
Папки с `unit`-ами `systemd` в `OpenSuse`:

1. `/etc/systemd/system/`
2. `/usr/lib/systemd/system`

---

`Qt` `debug` и `release`:

> The project can be built in release mode or debug mode, or both. If debug and release are both specified, the last one takes effect. If you specify the debug_and_release option to build both the debug and release versions of a project, the Makefile that qmake generates includes a rule that builds both versions

# Термины и сокращения

* `SLES` - `SUSE Linux Enterprise Server`
* `EOL` - `End Of Life`
* `EPEL` - `Extra Packages for Enterprise Linux`

# Полезные ссылки

* [Команды imp/exp Oracle-а][1]
* [О сервисах в Linux][2]
* [SystemD][3]
* [README репозитория Qt][4]
* [Описание команды find_package Cmake][5]
* [Готовые релизы Qt 5 и 6][6]
* [Архивы с исходниками Qt 4][7]
* [Сборка Qt 5 и 6 с исходников][8]
* [Шпаргалка с командами Docker][11]
* [Мануал по чистке Docker-а][12]
* [Язык qmake][13]
* [Просто о make][14]
* [Gradle вступление][15]
* [Документация по Linx][18]
* [Cache в GitLab CI][19]
* [Документация по Qt4][22]

[1]: https://docs.oracle.com/cd/B19306_01/server.102/b14215/exp_imp.htm
[2]: https://habr.com/ru/company/otus/blog/424761/
[3]: https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units-ru
[4]: https://code.qt.io/cgit/qt/qt5.git/tree/README.git
[5]: https://cmake.org/cmake/help/latest/command/find_package.html
[6]: https://download.qt.io/official_releases/qt/
[7]: https://wiki.qt.io/Qt_4_versions
[8]: https://wiki.qt.io/Building_Qt_5_from_Git
[11]: https://habr.com/ru/company/flant/blog/336654/
[12]: https://habr.com/ru/post/486200/
[13]: https://doc.qt.io/qt-5/qmake-language.html
[14]: https://habr.com/ru/post/211751/
[15]: https://www.baeldung.com/gradle
[18]: https://lynx.invisible-island.net/lynx_help/Lynx_users_guide.html
[19]: https://mcs.mail.ru/blog/sposoby-keshirovaniya-v-gitlab-ci-rukovodstvo-v-kartinkah
[20]: https://github.com/soramimi/Guitar
[22]: http://qtdocs.narod.ru/4.1.0/doc/html/index.html
