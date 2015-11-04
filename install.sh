#!/bin/sh

git submodule update --init --recursive
p=$(pwd)
cd
ln -sr "$p"/.vimrc
cd "$p"

