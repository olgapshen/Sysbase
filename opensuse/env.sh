#!/bin/bash

# Данный файл настраивает среду командной строки;
# Вызовите данный файл из локального ~/.bashrc

# Сконфигурировать сессию для Oracle-а
. /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh

# Просим man не спрашивать о номере раздела
export MAN_POSIXLY_CORRECT=1

# Папки с репозиториями
export REPOS=$HOME/repos
# Имя проекта пользовательских скриптов
export SS_SLUG=sysscripts

PATH=$PATH:$REPOS/$SS_SLUG/scripts
export PATH

# Предполагается, что LD_LIBRARY_PATH всегда пуст в начале
LD_LIBRARY_PATH=$ORACLE_HOME/lib
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib:/usr/lib
export LD_LIBRARY_PATH

# Удаляем внутренние репозитории не под контролем корневого репозитория
alias untracked="git ls-files --others --exclude-standard | xargs rm -rf"
# полностью очищаем папку
alias fullclean="rm -rf ..?* .[!.]* *"
# Просмотр дерева файловой системы
alias countf="find . -type f | wc -l"
# Объём папки
alias sized="du -sh ."
# Подсчёт количества файлов в папке
alias treeless="tree -L 3 | less"
# Удалить файлы сгенерированные CMake
alias cmrm="rm -rf CMakeFiles/ CMakeCache.txt cmake_install.cmake pos_autogen"
