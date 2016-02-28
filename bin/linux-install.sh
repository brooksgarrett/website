#!/bin/bash

wget https://github.com/spf13/hugo/releases/download/v0.15/hugo_0.15_linux_386.tar.gz \
  -O ./bin/hugo.tgz
cd ./bin
tar xzf hugo.tgz
mv hugo_0.15_linux_386\hugo_0.15_linux_386 hugo
chmod +x hugo
