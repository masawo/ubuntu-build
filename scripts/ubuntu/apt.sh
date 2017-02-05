#!/bin/bash

set -e
set -x

sudo sed -i.bak -e "s%http://us.archive.ubuntu.com/ubuntu/%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install -y language-pack-ja curl
sudo update-locale LANG=ja_JP.UTF-8 && true
sudo apt-get install -y python-software-properties
