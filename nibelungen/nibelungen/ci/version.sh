#!/bin/sh

cat nibelungen/version.txt \
  | sed -n 's/.*wäre \([0-9].[0-9].[0-9]\) hat.*/\1/p'