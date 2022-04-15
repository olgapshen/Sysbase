#!/bin/sh

# ------------------------------------------------------------
# Скрипт для автоматического слияния из главной ветки после MR
# ------------------------------------------------------------

if [ $# -ne 2 ]; then
    echo "Supply main and child branch names"
    exit 1
fi

echo "Main : $1"
echo "Child: $2"

if ! git fetch --prune; then
    echo "Error on fetch"
    exit 1
fi

if ! git checkout $1; then
    echo "Error on main checkout"
    exit 1
fi

if ! git pull; then
    echo "Error on pull"
    exit 1
fi

if ! git branch -D $2; then
    echo "Error on branch delete"
    exit 1
fi

if ! git checkout -b $2; then
    echo "Error on child checkout"
    exit 1
fi

echo "Done"

