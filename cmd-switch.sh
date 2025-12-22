#!/bin/bash

if [ ! "$BASH_VERSION" ] ; then
    echo "Please do not use sh to run this script ($0), just execute it by bash" 1>&2
    exit 1
fi

sudo apt-get install expect -y
sudo mkdir -p /data/switch
sudo cp -f pull_switch_arp_huawei.sh /data/switch/
sudo chmod 644 ./switchcron/crontab
sudo cp -f ./switchcron/crontab /etc/
sudo systemctl restart cron.service

