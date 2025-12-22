#!/bin/bash

if [ ! "$BASH_VERSION" ] ; then
    echo "Please do not use sh to run this script ($0), just execute it by bash" 1>&2
    exit 1
fi

#sudo passwd hashmap
#sudo cp -f 50-cloud-init.yaml /etc/netplan/
#sudo netplan apply

sudo chmod 777 *
sudo hostnamectl set-hostname LW-019-Master
sudo sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg
sudo cp -f systemd-networkd-wait-online.service /etc/systemd/system/network-online.target.wants/

sudo dpkg --configure -a
sudo apt-get update
sleep 1s
sudo apt-get install mtr -y
sleep 1s
sudo apt-get install fping
sleep 1s
sudo apt install lm-sensors -y
sleep 1s
sudo apt-get install openssh-server
sleep 1s

sudo systemctl start ssh
sudo systemctl enable ssh

sudo cp -f sysctl.conf /etc/sysctl.conf
sudo sysctl -p 

sleep 2s
#for filebeat server
sudo cp -f limits.conf /etc/security/limits.conf
ulimit -SHn 204800
sudo su
ulimit -SHn 204800
su - hashmap
#ulimit -a

sudo apt install smartmontools -y
sudo smartctl -l devstat /dev/sda
