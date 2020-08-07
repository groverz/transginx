#!/usr/bin/env bash
#===============================================================================
#run.sh
#===============================================================================
#echo "Nickname $(head -c 16 /dev/urandom  | sha1sum | cut -c1-16)" >> /etc/tor/torrc


echo "nameserver 127.0.0.1" > /etc/resolv.conf

iptables -t nat -A OUTPUT -d 127.0.0.1/32 -p udp -m udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A OUTPUT -d 10.192.0.0/10 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j REDIRECT --to-ports 9040

nginx -c /etc/nginx/nginx.conf

/usr/bin/tor -f /etc/tor/torrc

cat