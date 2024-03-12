#!/bin/bash

# Данный файл настраивает среду командной строки;
# Вызовите данный файл из локального ~/.bashrc

# Сконфигурировать сессию для Oracle-а
. /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh

# Просим man не спрашивать о номере раздела
export MAN_POSIXLY_CORRECT=1

# Папки с репозиториями
export REPOS=$HOME/repos
# Папка со сборками
export BUILDS=$HOME/builds
# Путь к репозиторию пользовательских скриптов
export SS_REPO=$REPOS/sysscripts
# Путь к репозиторию Qt
export QT_REPO=$REPOS/qt5
# Путь к репозиторию OpenCV
export CV_REPO=$REPOS/opencv
# Путь к репозиторию OpenSSL
export SL_REPO=$REPOS/openssl
# Папка установки Qt
export QT_HOME=/opt/qt5
# Папка установки OpenCV
export CV_HOME=/opt/opencv
# Папка установки OpenSSL
export SL_HOME=/opt/openssl

PATH=$PATH:$SS_REPO/scripts
PATH=$PATH:$QT_HOME/bin
PATH=$PATH:$CV_HOME/bin
PATH=$PATH:$SL_HOME/bin
PATH=$PATH:$GQ_HOME
export PATH

export QT_REF=v5.15.12-lts-lgpl
export CV_REF=4.6.0
export SL_REF=openssl-3.2.1

export QT_PLUGIN_PATH=$QT_HOME/plugins

# Переконфигурируем Qt
alias qt5config="$QT_REPO/configure \
  -prefix $QT_HOME \
  -confirm-license \
  -opensource \
  -xcb \
  -no-opengl \
  -skip qt3d \
  -skip qtandroidextras \
  -skip qtcanvas3d \
  -skip qtcharts \
  -skip qtdatavis3d \
  -skip qtdocgallery \
  -skip qtgamepad \
  -skip qtlocation \
  -skip qtlottie \
  -skip qtmacextras \
  -skip qtpurchasing \
  -skip qtquick3d \
  -skip qtspeech \
  -skip qttranslations \
  -skip qtwayland \
  -skip qtwebchannel \
  -skip qtwebengine \
  -skip qtwebglplugin \
  -skip qtwebview \
  -skip qtwinextras \
  -nomake examples \
  -nomake tests"

alias cv4config="cmake \
  -DCMAKE_BUILD_TYPE=DEBUG \
  -DCMAKE_INSTALL_PREFIX=$CV_HOME $CV_REPO"

alias sl3config="$SL_REPO/Configure \
  --prefix=$SL_HOME \
  --openssldir=$SL_HOME"

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
