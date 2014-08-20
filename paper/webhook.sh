#!/bin/sh

REPO=/path/to/github-paper-collaborator/
OUTPUT=/path/to/files/example.pdf

set -e
cd $REPO/paper
git pull
./build.sh
cp -p output.pdf $OUTPUT
