#Prabs
apt update -o Acquire::ForceIPv4=true
apt install bind9 dnsutils -y -o Acquire::ForceIPv4=true

cat << 'EOF' > /etc/bind/named.conf.local
zone "k19.com" {
    type master;
    file "/etc/bind/jarkom/k19.com";
    allow-transfer { 10.73.10.3; };
    notify yes;
};
EOF

mkdir -p /etc/bind/jarkom

cat << 'EOF' > /etc/bind/jarkom/k19.com
$TTL    604800
@       IN      SOA     prab.k19.com. root.k19.com. (
                        2026092801 ; Serial
                            604800 ; Refresh
                             86400 ; Retry
                           2419200 ; Expire
                            604800 ) ; Negative Cache TTL
;
@       IN      NS      prab.k19.com.
@       IN      NS      tedd.k19.com.

@       IN      A       10.73.30.2   ; IP penny (Apex)
prab    IN      A       10.73.10.2
tedd    IN      A       10.73.10.3

abbey   IN      A       10.73.20.2
penny   IN      A       10.73.30.2

vault   IN      A       10.73.10.4   ; IP obladi
vault   IN      A       10.73.10.5   ; IP desmond
core    IN      A       10.73.10.6   ; IP oblada
core    IN      A       10.73.10.7   ; IP molly

www     IN      CNAME   penny.k19.com.
static  IN      CNAME   abbey.k19.com.

alpha   IN      A       10.73.40.2
beta    IN      A       10.73.40.3
gamma   IN      A       10.73.40.4
delta   IN      A       10.73.50.2
epsilon IN      A       10.73.50.3
EOF

service named restart

#Tedd
cat << 'EOF' > /etc/bind/named.conf.local
zone "k19.com" {
    type slave;
    masters { 10.73.10.2; };
    file "/var/lib/bind/k19.com";
};
EOF

service named restart

#Alpha
cat << 'EOF' > /etc/resolv.conf
nameserver 10.73.10.2
nameserver 10.73.10.3
nameserver 192.168.122.1
EOF

host -t A k19.com
host -t A www.k19.com