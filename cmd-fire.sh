#!/bin/bash

if [ ! "$BASH_VERSION" ] ; then
    echo "Please do not use sh to run this script ($0), just execute it by bash" 1>&2
    exit 1
fi

sudo apt install firewalld -y
sudo systemctl start firewalld
sudo systemctl enable firewalld

sudo firewall-cmd --permanent --zone=public --add-service=ftp 
sudo firewall-cmd --permanent --zone=public --add-service=ssh
sudo firewall-cmd --permanent --zone=public --add-service=telnet
 
sudo firewall-cmd --permanent --zone=public --add-port=22/tcp    
sudo firewall-cmd --permanent --zone=public --add-port=3333/tcp  
sudo firewall-cmd --permanent --zone=public --add-port=953/tcp   
sudo firewall-cmd --permanent --zone=public --add-port=53/tcp    
sudo firewall-cmd --permanent --zone=public --add-port=53/udp    
sudo firewall-cmd --permanent --zone=public --add-port=67/udp    
sudo firewall-cmd --permanent --zone=public --add-port=123/udp

sudo firewall-cmd --permanent --zone=public --add-masquerade     
sudo firewall-cmd --add-forward-port=port=25:proto=tcp:toport=3333 --permanent
sudo firewall-cmd --add-forward-port=port=443:proto=tcp:toport=3333 --permanent
sudo firewall-cmd --add-forward-port=port=1000-10000:proto=tcp:toport=3333 --permanent
sudo firewall-cmd --reload

sudo firewall-cmd --list-all

