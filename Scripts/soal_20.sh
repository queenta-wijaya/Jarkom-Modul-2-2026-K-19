#prab
cat << 'XEOF' > /root/init.sh
#!/bin/bash
# prab - autostart BIND9
pgrep -x named > /dev/null || named -u bind
XEOF
chmod +x /root/init.sh

#tedd
cat << 'XEOF' > /root/init.sh
#!/bin/bash
# tedd - autostart BIND9
pgrep -x named > /dev/null || named -u bind
XEOF
chmod +x /root/init.sh

#obladi dan desmond 
cat << 'XEOF' > /root/init.sh
#!/bin/bash
# vault - autostart Apache2
pgrep -x apache2 > /dev/null || service apache2 start
XEOF
chmod +x /root/init.sh

#penny 
cat << 'XEOF' > /root/init.sh
#!/bin/bash
# penny - autostart PHP-FPM + Apache2
pgrep -x php-fpm8.4 > /dev/null || php-fpm8.4 -D
pgrep -x apache2 > /dev/null || service apache2 start
XEOF
chmod +x /root/init.sh

#oblado dan molly
cat << 'XEOF' > /root/init.sh
#!/bin/bash
# core - autostart PHP-FPM + Nginx
pgrep -x php-fpm8.4 > /dev/null || php-fpm8.4 -D
pgrep -x nginx > /dev/null || nginx
XEOF
chmod +x /root/init.sh

#abbey
cat << 'XEOF' > /root/init.sh
#!/bin/bash
# abbey - autostart Nginx
pgrep -x nginx > /dev/null || nginx
XEOF
chmod +x /root/init.sh

#rootkit 
cat << 'XEOF' > /root/init.sh
#!/bin/bash
# rootkit - IP gateway + routing + NAT (idempotent)
for i in 0 1 2 3 4 5; do ip link set eth$i up; done
ip addr add 10.73.10.1/24 dev eth1 2>/dev/null || true
ip addr add 10.73.20.1/24 dev eth2 2>/dev/null || true
ip addr add 10.73.30.1/24 dev eth3 2>/dev/null || true
ip addr add 10.73.40.1/24 dev eth4 2>/dev/null || true
ip addr add 10.73.50.1/24 dev eth5 2>/dev/null || true

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -C POSTROUTING -o eth0 -j MASQUERADE 2>/dev/null || iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -C FORWARD -j ACCEPT 2>/dev/null || iptables -A FORWARD -j ACCEPT
XEOF
chmod +x /root/init.sh

#uji setelah di restart

# prab dan tedd
pgrep -a named; dig @127.0.0.1 k19.com SOA +short
#Obladi, Desmond, Penny
pgrep -a apache2 | head -2
#Penny, Oblada, Molly
pgrep -a php-fpm | head -2
#Oblada, Molly, Abbey
pgrep -a nginx | head -2
#Rootkit
cat /proc/sys/net/ipv4/ip_forward; iptables -t nat -L POSTROUTING -n

#alpha 
dig abbey.k19.com +short
dig outbound.k19.com +short
curl -I http://www.k19.com/
curl -I http://abbey.k19.com/
curl -s http://www.k19.com/eternal/ | head -3
curl -I http://http.badssl.com/