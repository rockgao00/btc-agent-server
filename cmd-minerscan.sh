#!/bin/bash

if [ ! "$BASH_VERSION" ] ; then
    echo "Please do not use sh to run this script ($0), just execute it by bash" 1>&2
    exit 1
fi

sudo apt update
sudo apt-get install -y build-essential autotools-dev libtool autoconf automake pkg-config cmake gcc g++ -y
sudo apt install libboost-all-dev -y
sudo apt install libssl-dev libluajit-5.1-dev libcrypto++-dev -y
sudo apt install jq -y
sudo chmod 777 ./minerscan/*
sudo cp -rvf ./minerscan /data/
sudo chmod 644 ./minerscan/crontab
sudo cp -f ./minerscan/crontab /etc/
sudo systemctl restart cron.service
