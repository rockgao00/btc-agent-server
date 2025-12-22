#!/bin/bash
args=($@)
ctype=${args[0]}
username=${args[1]}
password=${args[2]}
include=${args[3]}
ips=${args[*]:4}

EXPORT_PATH=`pwd`

if [ ! -d $EXPORT_PATH ] ; then
    mkdir -p $EXPORT_PATH
fi

pull_telnet() {
    /usr/bin/expect <<EOD
    set timeout 120
    spawn telnet $ip
    expect "Username:" {
        send "$username\n"
    }
    expect "assword:" {
        send "$password\n"
    }
    expect ">" {
        send "screen-length 0 temporary\n"
    }
    expect ">" {
        send "display arp | include $include\n"
    }
    expect ">" {
        send "quit\n"
    }
    interact
EOD
}

pull_ssh() {
    /usr/bin/expect <<EOD
    set timeout 120
    spawn ssh -oStrictHostKeyChecking=no -oCheckHostIP=no $username@$ip
    expect "assword" {
        send "$password\n"
    }
    expect ">" {
        send "screen-length 0 temporary\n"
    }
    expect ">" {
        send "display arp | include $include\n"
    }
    expect ">" {
        send "quit\n"
    }
    interact
EOD
}

for ip in ${ips[@]}; do
    output="$EXPORT_PATH/$ip-arp.log"
    erroutput="$EXPORT_PATH/$ip-arp-err.log"

    if [ "$ctype" = "ssh" ]; then
    pull_ssh $ip > $output 2> $erroutput
    else
    pull_telnet $ip > $output 2> $erroutput
    fi
done

cat $EXPORT_PATH/*-arp.log|grep GE |awk '{print $1, $2}'|sort -k 1 -u > $EXPORT_PATH/ipmac.log &
