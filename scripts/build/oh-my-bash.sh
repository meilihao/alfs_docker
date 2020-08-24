#!/usr/bin/env bash
set -e

# oh-mt-bash automatically upgrade reports error: which: command not found

echo -e "\n\n+++ start oh-my-bash.sh +++\n\n"

rm -rf ~/.oh-my-bash || true         && \
cp -rf $LFSRoot/sources/oh-my-bash ~ && \
mv ~/oh-my-bash ~/.oh-my-bash        && \
cp ~/.bashrc ~/.bashrc.orig || true  && \
cp ~/.oh-my-bash/templates/bashrc.osh-template ~/.bashrc

echo -e "+++ done oh-my-bash.sh +++\n\n"