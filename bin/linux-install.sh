#!/bin/bash

wget https://github.com/spf13/hugo/releases/download/v0.19/hugo_0.19_Linux-32bit.tar.gz \
  -O ./bin/hugo.tgz
cd ./bin
tar xzf hugo.tgz
mv hugo_0.19_linux_386/hugo_0.19_linux_386 hugo
chmod +x hugo
