#!/usr/bin/env bash

set -e

cd book-result
cp ../SpecTitle.tex .
# ln -s -f ../figures . # redundant with the support option in pillar.conf
texfot latexmk SpecTitle
