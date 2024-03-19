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
# Папка с установками
export INSTALLS=/opt
# Имя проекта пользовательских скриптов
export SS_SLUG=sysscripts
# Имя проекта Qt
#export QT_SLUG=qt5
# Имя проекта OpenCV
export CV_SLUG=opencv
# Имя проекта OpenSSL
#export SL_SLUG=openssl
# Имя проекта LLVM
#export LL_SLUG=llvm-project

#APPS="$APPS $QT_SLUG"
APPS="$APPS $CV_SLUG"
#APPS="$APPS $SL_SLUG"
#APPS="$APPS $LL_SLUG"

PATH=$PATH:$REPOS/$SS_SLUG/scripts
#PATH=$PATH:$INSTALLS/$QT_SLUG/bin
PATH=$PATH:$INSTALLS/$CV_SLUG/bin
#PATH=$PATH:$INSTALLS/$SL_SLUG/bin
PATH=$PATH:$INSTALLS/$GQ_SLUG
export PATH

# Предполагается, что LD_LIBRARY_PATH всегда пуст в начале
LD_LIBRARY_PATH=$ORACLE_HOME/lib
# Если подключить данную папку, TLS в сисеме перестаёт работать; возможно это
# решилось бы при штатной установке проекта; с другной стороны это может
# совершенно сломать всю систему;
# TODO: решить этот вопрос
#LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$INSTALLS/$SL_SLUG/lib64
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib:/usr/lib
export LD_LIBRARY_PATH

#export QT_REF=v5.15.12-lts-lgpl
export CV_REF=4.6.0
#export SL_REF=openssl-3.2.1
#export LL_REF=llvmorg-16.0.1

#export QT_PLUGIN_PATH=$INSTALLS/$QT_SLUG/plugins

# Переконфигурируем Qt
#alias qt5config="$REPOS/$QT_SLUG/configure \
#  -prefix $INSTALLS/$QT_SLUG \
#  -confirm-license \
#  -opensource \
#  -recheck \
#  -I /opt/openssl/include \
#  -ssl \
#  -xcb \
#  -no-opengl \
#  -skip qt3d \
#  -skip qtandroidextras \
#  -skip qtcanvas3d \
#  -skip qtcharts \
#  -skip qtdatavis3d \
#  -skip qtdocgallery \
#  -skip qtgamepad \
#  -skip qtlocation \
#  -skip qtlottie \
#  -skip qtmacextras \
#  -skip qtpurchasing \
#  -skip qtquick3d \
#  -skip qtspeech \
#  -skip qttranslations \
#  -skip qtwayland \
#  -skip qtwebchannel \
#  -skip qtwebengine \
#  -skip qtwebglplugin \
#  -skip qtwebview \
#  -skip qtwinextras \
#  -nomake examples \
#  -nomake tests"

alias cv4config="cmake \
  -DCMAKE_BUILD_TYPE=DEBUG \
  -DCMAKE_INSTALL_PREFIX=$INSTALLS/$CV_SLUG $REPOS/$CV_SLUG"

#alias sl3config="$REPOS/$SL_SLUG/Configure \
#  --prefix=$INSTALLS/$SL_SLUG \
#  --openssldir=$INSTALLS/$SL_SLUG"

#alias ll16config="cmake \
#  -B . \
#  -S $REPOS/$LL_SLUG/llvm \
#  -DLLVM_ENABLE_PROJECTS=clang \
#  -DLLVM_ENABLE_RUNTIMES=libcxx;libcxxabi \
#  -DCMAKE_BUILD_TYPE=DEBUG \
#  -DCMAKE_INSTALL_PREFIX=$INSTALLS/$LL_SLUG"

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
