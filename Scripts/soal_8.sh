#Prabs
cat << 'EOF' > /etc/bind/named.conf.local
zone "k19.com" {
    type master;
    file "/etc/bind/jarkom/k19.com";
    allow-transfer { 10.73.10.3; };
    notify yes;
};

zone "10.73.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/10.73.10.in-addr.arpa";
    allow-transfer { 10.73.10.3; };
    notify yes;
};

zone "20.73.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/20.73.10.in-addr.arpa";
    allow-transfer { 10.73.10.3; };
    notify yes;
};

zone "30.73.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/30.73.10.in-addr.arpa";
    allow-transfer { 10.73.10.3; };
    notify yes;
};
EOF

# File Reverse Subnet 10.73.10.0/24 (Vault & Core)
cat << 'EOF' > /etc/bind/jarkom/10.73.10.in-addr.arpa
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

4       IN      PTR     obladi.k19.com.
5       IN      PTR     desmond.k19.com.
6       IN      PTR     oblada.k19.com.
7       IN      PTR     molly.k19.com.
EOF

# File Reverse Subnet 10.73.20.0/24 (Abbey)
cat << 'EOF' > /etc/bind/jarkom/20.73.10.in-addr.arpa
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

2       IN      PTR     abbey.k19.com.
EOF

# File Reverse Subnet 10.73.30.0/24 (Penny)
cat << 'EOF' > /etc/bind/jarkom/30.73.10.in-addr.arpa
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

2       IN      PTR     penny.k19.com.
EOF

named-checkconf
service named restart

#Tedd
cat << 'EOF' > /etc/bind/named.conf.local
zone "k19.com" {
    type slave;
    masters { 10.73.10.2; };
    file "/var/lib/bind/k19.com";
};

zone "10.73.10.in-addr.arpa" {
    type slave;
    masters { 10.73.10.2; };
    file "/var/lib/bind/10.73.10.in-addr.arpa";
};

zone "20.73.10.in-addr.arpa" {
    type slave;
    masters { 10.73.10.2; };
    file "/var/lib/bind/20.73.10.in-addr.arpa";
};

zone "30.73.10.in-addr.arpa" {
    type slave;
    masters { 10.73.10.2; };
    file "/var/lib/bind/30.73.10.in-addr.arpa";
};
EOF

rm -f /var/lib/bind/*.in-addr.arpa
service named restart

#Alpha
host 10.73.10.4
host 10.73.10.5
host 10.73.10.6
host 10.73.10.7

host 10.73.20.2
host 10.73.30.2

host 10.73.10.4 10.73.10.3
host 10.73.20.2 10.73.10.3