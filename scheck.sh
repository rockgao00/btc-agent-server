#!/bin/bash

while true
do
  flagdhcpdead=`systemctl status kea-dhcp4-server.service | grep Stopped -c`
  flagdhcpwarn=`systemctl status kea-dhcp4-server.service | grep WARN -c`
  if [[ $flagdhcpdead -ne 0 ]]
  then
     `sudo systemctl restart kea-dhcp4-server.service`
      sudo echo `date` - "kea-dhcp4-server.service restart" | sudo tee -a /data/scheck/log/dhcp_dead.log
  elif [[ $flagdhcpwarn -ne 0 ]]
  then
      `sudo systemctl restart kea-dhcp4-server.service`
       sudo echo `date` - "kea-dhcp4-server.service restart" | sudo tee -a /data/scheck/log/dhcp_warn.log
  else
      echo "kea-dhcp4-server.service is running..." >> /dev/null
  fi

  flagfiredead=`systemctl status firewalld.service | grep Stopped -c`
  if [[ $flagfiredead -ne 0 ]]
  then
     `sudo systemctl restart firewalld.service`
      sudo echo `date` - "firewalld.service restart" | sudo tee -a /data/scheck/log/firewalld_dead.log
  else
      echo "firewalld.service is running..." >> /dev/null
  fi

  sleep 5s
done


