#!/bin/bash
list=$(sudo lastb |awk '{print $3}'|sort |uniq -c|awk '{if ($1 > 10) print $2}')
for ip in ${list}
do
  echo ALL: ${ip} >> /etc/hosts.deny
  echo > /var/log/btmp
done
