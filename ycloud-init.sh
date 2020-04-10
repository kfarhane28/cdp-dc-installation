#!/bin/bash
hostrange=$1
yum -y install bind-utils
cat << EOF > /etc/hosts
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF
hostmin=$(echo $hostrange | grep -oP '(?<={)(\d*)')
hostmax=$(echo $hostrange | grep -oP '(?<=\.\.)\d*')
for hostid in $(seq ${hostmin} ${hostmax})
do
  hostn=$(echo $hostrange | sed "s/{[0-9]*\.\.[0-9]*}/${hostid}/g")
  hostnip=$(dig ${hostn} +short)
  echo ${hostnip} ${hostn} >> /etc/hosts
done

grep $(dig $(hostname -f) +short) /etc/hosts | awk '{print $2}' > /etc/hostname
hostname $(cat /etc/hostname)
