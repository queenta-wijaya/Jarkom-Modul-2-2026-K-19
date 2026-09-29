#rootkid

# 1. Pasang IP Gateway Internal
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up
ip link set eth3 up
ip link set eth4 up
ip link set eth5 up

ip addr flush dev eth1
ip addr flush dev eth2
ip addr flush dev eth3
ip addr flush dev eth4
ip addr flush dev eth5

ip addr add 10.73.10.1/24 dev eth1
ip addr add 10.73.20.1/24 dev eth2
ip addr add 10.73.30.1/24 dev eth3
ip addr add 10.73.40.1/24 dev eth4
ip addr add 10.73.50.1/24 dev eth5

# 2. Dapatkan IP NAT / WAN di eth0
dhcpcd eth0 2>/dev/null || udhcpc -i eth0 2>/dev/null || true
if ! ip a show eth0 | grep -q "inet "; then
    ip addr add 192.168.122.200/24 dev eth0
    ip route add default via 192.168.122.1 dev eth0 2>/dev/null || true
fi

# 3. Aktifkan Routing & NAT
sysctl -w net.ipv4.ip_forward=1
iptables -F
iptables -t nat -F
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -j ACCEPT

# 4. Set Hostname
hostname rootkit && echo "rootkit" > /etc/hostname

#prabs

# 1. Konfigurasi Network & Hostname
ip link set eth0 up
ip addr flush dev eth0
ip addr add 10.73.10.2/24 dev eth0
ip route add default via 10.73.10.1 dev eth0 2>/dev/null || true
hostname prab && echo "prab" > /etc/hostname

# 2. Set Resolv sementara untuk akses internet/update
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# 3. Ensure BIND9 ter-install
apt update -o Acquire::ForceIPv4=true 2>/dev/null || true
apt install bind9 dnsutils -y -o Acquire::ForceIPv4=true 2>/dev/null || true

# 4. Tulis Options BIND9
cat << 'EOF' > /etc/bind/named.conf.options
options {
        directory "/var/cache/bind";
        forwarders {
                192.168.122.1;
        };
        allow-query { any; };
        listen-on { any; };
        listen-on-v6 { any; };
        auth-nxdomain no;
};
EOF

# 5. Tulis Deklarasi Zone Master
cat << 'EOF' > /etc/bind/named.conf.local
zone "k19.com" {
    type master;
    file "/etc/bind/jarkom/k19.com";
    allow-transfer { 10.73.10.3; };
    notify yes;
};
EOF

# 6. Tulis File Record DNS k19.com Lengkap (Soal 3, 4, 5)
mkdir -p /etc/bind/jarkom

cat << 'EOF' > /etc/bind/jarkom/k19.com
$TTL    604800
@       IN      SOA     prab.k19.com. root.k19.com. (
                        2026092802 ; Serial
                            604800 ; Refresh
                             86400 ; Retry
                           2419200 ; Expire
                            604800 ) ; Negative Cache TTL
;
; Name Servers
@       IN      NS      prab.k19.com.
@       IN      NS      tedd.k19.com.

; Apex Domain (Penny)
@       IN      A       10.73.30.2

; --- PENGECUALIAN NODE DNS SERVER ---
prab    IN      A       10.73.10.2
tedd    IN      A       10.73.10.3

; --- DOMAIN ENTITAS INDIVIDUAL ---
rootkit IN      A       10.73.10.1
abbey   IN      A       10.73.20.2
penny   IN      A       10.73.30.2
obladi  IN      A       10.73.10.4
desmond IN      A       10.73.10.5
oblada  IN      A       10.73.10.6
molly   IN      A       10.73.10.7
alpha   IN      A       10.73.40.2
beta    IN      A       10.73.40.3
gamma   IN      A       10.73.40.4
delta   IN      A       10.73.50.2
epsilon IN      A       10.73.50.3

; --- LOAD BALANCING REPOSITORIES ---
vault   IN      A       10.73.10.4
vault   IN      A       10.73.10.5
core    IN      A       10.73.10.6
core    IN      A       10.73.10.7

; --- ALIAS CNAME ---
www     IN      CNAME   penny.k19.com.
static  IN      CNAME   abbey.k19.com.
EOF

# 7. Restart BIND9 & Set Resolv Akhir
service named restart
cat << 'EOF' > /etc/resolv.conf
nameserver 10.73.10.2
nameserver 10.73.10.3
nameserver 192.168.122.1
EOF

#tedd

# 1. Konfigurasi Network & Hostname
ip link set eth0 up
ip addr flush dev eth0
ip addr add 10.73.10.3/24 dev eth0
ip route add default via 10.73.10.1 dev eth0 2>/dev/null || true
hostname tedd && echo "tedd" > /etc/hostname

# 2. Set Resolv sementara untuk akses internet/update
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# 3. Ensure BIND9 ter-install
apt update -o Acquire::ForceIPv4=true 2>/dev/null || true
apt install bind9 dnsutils -y -o Acquire::ForceIPv4=true 2>/dev/null || true

# 4. Tulis Options BIND9
cat << 'EOF' > /etc/bind/named.conf.options
options {
        directory "/var/cache/bind";
        forwarders {
                192.168.122.1;
        };
        allow-query { any; };
        listen-on { any; };
        listen-on-v6 { any; };
        auth-nxdomain no;
};
EOF

# 5. Tulis Deklarasi Zone Slave
cat << 'EOF' > /etc/bind/named.conf.local
zone "k19.com" {
    type slave;
    masters { 10.73.10.2; };
    file "/var/lib/bind/k19.com";
};
EOF

# 6. Clean zone cache & Restart BIND9
rm -f /var/lib/bind/k19.com
service named restart

# 7. Set Resolv Akhir
cat << 'EOF' > /etc/resolv.conf
nameserver 10.73.10.2
nameserver 10.73.10.3
nameserver 192.168.122.1
EOF

# alpha

ip link set eth0 up
ip addr flush dev eth0
ip addr add 10.73.40.2/24 dev eth0
ip route add default via 10.73.40.1 dev eth0 2>/dev/null || true
hostname alpha && echo "alpha" > /etc/hostname

cat << 'EOF' > /etc/resolv.conf
nameserver 10.73.10.2
nameserver 10.73.10.3
nameserver 192.168.122.1
EOF

host k19.com
host www.k19.com
host obladi.k19.com

