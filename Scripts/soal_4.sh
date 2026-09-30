#Prabs
apt update -o Acquire::ForceIPv4=true
apt install bind9 dnsutils -y -o Acquire::ForceIPv4=true

# Set Forwarders di /etc/bind/named.conf.options
cat << 'EOF' > /etc/bind/named.conf.options
options {
        directory "/var/cache/bind";

        forwarders {
                192.168.122.1;
        };

        allow-query { any; };
        dnssec-validation auto;
        listen-on-v6 { any; };
};
EOF

# Zone Master di /etc/bind/named.conf.local
cat << 'EOF' > /etc/bind/named.conf.local
zone "k19.com" {
    type master;
    file "/etc/bind/jarkom/k19.com";
    allow-transfer { 10.73.10.3; };
    also-notify { 10.73.10.3; };
    notify yes;
};
EOF

mkdir -p /etc/bind/jarkom

# File Zone minimal untuk Soal 4
cat << 'EOF' > /etc/bind/jarkom/k19.com
$TTL    604800
@       IN      SOA     prab.k19.com. root.k19.com. (
                        2026092801 ; Serial
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

; Host Utama BIND9
prab    IN      A       10.73.10.2
tedd    IN      A       10.73.10.3
EOF

chown -R bind:bind /etc/bind/jarkom
service named restart

#Tedd
apt update -o Acquire::ForceIPv4=true
apt install bind9 dnsutils -y -o Acquire::ForceIPv4=true

# Set Forwarders di /etc/bind/named.conf.options
cat << 'EOF' > /etc/bind/named.conf.options
options {
        directory "/var/cache/bind";

        forwarders {
                192.168.122.1;
        };

        allow-query { any; };
        dnssec-validation auto;
        listen-on-v6 { any; };
};
EOF

# Zone Slave di /etc/bind/named.conf.local
cat << 'EOF' > /etc/bind/named.conf.local
zone "k19.com" {
    type slave;
    masters { 10.73.10.2; };
    file "/var/lib/bind/k19.com";
};
EOF

service named restart

#Alpha
# Uji IP Apex Domain & Name Server
host -t A k19.com
host prab.k19.com
host tedd.k19.com