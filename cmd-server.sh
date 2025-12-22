#!/bin/bash

if [ ! "$BASH_VERSION" ] ; then
    echo "Please do not use sh to run this script ($0), just execute it by bash" 1>&2
    exit 1
fi

#must use bash server-cmd.sh
master=1
sudo sed -i 's/warp016.lw016z/warp019.lw019z/g' ckproxy.conf

#ckpool
sudo apt-get install build-essential yasm libpq-dev libgsl-dev autoconf automake libtool -y
sudo mkdir -p /data/ckpool_3333/logs

sudo cp ckpool /etc/logrotate.d/
sudo chmod 0644 /etc/logrotate.d/ckpool
sudo chown root:root /etc/logrotate.d/ckpool
sudo cp ckproxy.conf /data/ckpool_3333/
sudo cp ckpool.service /etc/systemd/system/
sudo cp bin/ckpool /data/ckpool_3333/
sudo chmod 777 /data/ckpool_3333/ckpool

sudo systemctl daemon-reload
sudo systemctl start ckpool.service
sudo systemctl enable ckpool.service
sudo systemctl restart ckpool.service

sleep 2s

#dhcp
sudo apt install kea-dhcp4-server -y

if [[ $master -ne 0 ]]
then
	sudo cp -f kea-dhcp4.conf /etc/kea/
else
  sudo cp -f kea-dhcp4_slave.conf /etc/kea/kea-dhcp4.conf 
fi

sudo systemctl daemon-reload
sudo systemctl start kea-dhcp4-server.service
sudo systemctl enable kea-dhcp4-server.service
sudo systemctl restart kea-dhcp4-server.service

sleep 2s

#ntp
sudo systemctl disable systemd-timesyncd
sudo apt-get install -y ntp
sudo cp -f ntp.conf /etc/ntp.conf
sudo systemctl daemon-reload
sudo systemctl start ntp
sudo systemctl enable ntp
sudo systemctl restart ntp

sleep 2s

#bind9
sudo apt install bind9 -y
sudo mv /etc/bind /etc/bind_bk

if [[ $master -ne 0 ]]
then
	sudo cp -rv bind9/bindm/bind /etc/
	sudo chown bind:bind /etc/bind/masters/test.com.zone
	sudo chmod 777 /etc/bind/masters/test.com.zone
else
	sudo cp -rv bind9/binds/bind /etc/
	sudo chown bind:bind /etc/bind/slaves/test.com.zone
	sudo chmod 777 /etc/bind/slaves/test.com.zone
fi

sudo systemctl daemon-reload
sudo systemctl start bind9.service
sudo systemctl enable bind9.service
sudo systemctl restart bind9.service

sleep 2s

#server check
sudo mkdir -p /data/scheck/log
sudo cp -f scheck.service /etc/systemd/system/
sudo cp -f scheck.sh /data/scheck/
sudo chmod 777 /data/scheck/scheck.sh
sudo chmod 777 /etc/systemd/system/scheck.service
sudo systemctl daemon-reload
sudo systemctl start scheck
sudo systemctl enable scheck
sudo systemctl restart scheck

#server cron
sudo cp -f ssh_deny.sh /data/scheck/
sudo chmod 644 crontab
sudo cp -f crontab /etc/
sudo systemctl restart cron.service

#restart check
sudo cp -f rc-local.service /lib/systemd/system/
sudo cp -f rc.local /etc/
sudo chmod +x /etc/rc.local
sudo systemctl daemon-reload
sudo systemctl start rc-local.service
sudo systemctl enable rc-local
sudo systemctl restart rc-local.service

sleep 2s

#status
#sudo ln -s /data /data/proxy
sudo systemctl status rc-local.service 
sudo systemctl status ckpool.service
sudo systemctl status scheck
sudo systemctl status bind9.service
sudo ntpq -p
sudo tail -10 /var/log/ntp.log
sudo tail -10 /var/log/kea-dhcp4.log

#sudo systemctl status kea-dhcp4-server.service
#sudo systemctl status ntp
#nslookup ubuntu.com 10.10.10.252
