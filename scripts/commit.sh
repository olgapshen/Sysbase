#!/bin/sh

# -----------------------------------------------
# Скрипт для автоматического комита в репозиторий
# -----------------------------------------------

if [ $# -ne 2 ]; then
    echo "Supply commit message and branch name"
    exit 1
fi

echo "Message: $1"
echo "Branch : $2"

if ! git add .; then
    echo "Error on add"
    exit 1
fi

git status

if ! git commit -m "$1"; then
    echo "Error on commit"
    exit 1
fi

if ! git push origin $2; then
    echo "Error on push"
    exit 1
fi

echo "Done"

