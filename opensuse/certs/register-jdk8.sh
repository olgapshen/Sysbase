#!/bin/bash

set -o errexit -o nounset

CRT_FOLDR=$1
CRT_ALIAS=$2
CRT_FILNM=$CRT_ALIAS.crt
CRT_FILPT=$CRT_FOLDR/$CRT_FILNM
echo "Adding: $CRT_FILNM"

[[ -v DRY_RUN ]] && exit 0

$JDK_PATH/bin/keytool \
    -import \
    -noprompt \
    -keystore $JDK_PATH/lib/security/cacerts \
    -storepass changeit \
    -alias $CRT_ALIAS \
    -file $CRT_FILPT

exit 0
