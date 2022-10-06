#!/bin/bash

set -o nounset

CRT_FOLDR=$1
CRT_ALIAS=$2
CRT_FILNM=$CRT_ALIAS.crt
CRT_FILPT=$CRT_FOLDR/$CRT_FILNM
echo "Removing: $CRT_FILNM"

[[ -v DRY_RUN ]] && exit 0

$JDK_PATH/bin/keytool \
    -delete \
    -noprompt \
    -keystore $JDK_PATH/lib/security/cacerts \
    -storepass changeit \
    -alias $CRT_ALIAS

exit 0
