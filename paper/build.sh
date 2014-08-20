#!/bin/bash
set -e

rm output.* -f

pandoc -S -N --number-sections -o output.tex --self-contained \
  -V documentclass=sigchi --csl=acm-sig-proceedings.csl [0-9]*.md

rubber --pdf output.tex
