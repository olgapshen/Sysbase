#!/bin/bash

# Данный файл настраивает среду командной строки для сборки Qt;
# Интегрируйте содержимое данного файла в основной env.sh

# Папки с репозиториями
export REPOS=$HOME/repos
# Папка со сборками
export BUILDS=$HOME/builds
# Папка с установками
export INSTALLS=/opt
# Имя проекта Qt
export QT_SLUG=qt5
# Имя проекта OpenCV
export CV_SLUG=opencv
# Имя проекта OpenSSL
export SL_SLUG=openssl
# Имя проекта LLVM
export LL_SLUG=llvm-project

APPS="$APPS $QT_SLUG"
APPS="$APPS $CV_SLUG"
APPS="$APPS $SL_SLUG"
APPS="$APPS $LL_SLUG"

PATH=$PATH:$INSTALLS/$QT_SLUG/bin
PATH=$PATH:$INSTALLS/$CV_SLUG/bin
PATH=$PATH:$INSTALLS/$SL_SLUG/bin
export PATH

# Если подключить данную папку, TLS в сисеме перестаёт работать; возможно это
# решилось бы при штатной установке проекта; с другной стороны это может
# совершенно сломать всю систему;
# TODO: решить этот вопрос
#LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$INSTALLS/$SL_SLUG/lib64
#export LD_LIBRARY_PATH

export QT_REF=v5.15.12-lts-lgpl
export CV_REF=4.6.0
export SL_REF=openssl-3.2.1
export LL_REF=llvmorg-16.0.1

export QT_PLUGIN_PATH=$INSTALLS/$QT_SLUG/plugins

# Переконфигурируем Qt
alias qt5config="$REPOS/$QT_SLUG/configure \
  -prefix $INSTALLS/$QT_SLUG \
  -confirm-license \
  -opensource \
  -recheck \
  -I /opt/openssl/include \
  -ssl \
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
  -DCMAKE_INSTALL_PREFIX=$INSTALLS/$CV_SLUG $REPOS/$CV_SLUG"

alias sl3config="$REPOS/$SL_SLUG/Configure \
  --prefix=$INSTALLS/$SL_SLUG \
  --openssldir=$INSTALLS/$SL_SLUG"

alias ll16config="cmake \
  -B . \
  -S $REPOS/$LL_SLUG/llvm \
  -DLLVM_ENABLE_PROJECTS=clang \
  -DLLVM_ENABLE_RUNTIMES=libcxx;libcxxabi \
  -DCMAKE_BUILD_TYPE=DEBUG \
  -DCMAKE_INSTALL_PREFIX=$INSTALLS/$LL_SLUG"
