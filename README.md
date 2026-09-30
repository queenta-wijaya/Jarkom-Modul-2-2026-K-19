# Jarkom-Modul-2-2026-K-19
## Anggota Kelompok
| Nama | NRP |
| --- | --- |
| Ni Putu Maqueenta Wijaya | 5027251004 |
| Malikha Syafira Dewi | 5027251032 |
## Pembahasan
## Soal 1
Membuat topologi sesuai yang diminta soal
![img](assets/soal_1.png)<br>
Konfigurasi Node:
1. Rootkit
```bash
auto lo
iface lo inet loopback

# Connection to NAT
auto eth0
iface eth0 inet dhcp

# Switch 1 (Directory & Repository)
auto eth1
iface eth1 inet static
    address 10.73.10.1
    netmask 255.255.255.0

# Switch 4 (Penyaring Abbey)
auto eth2
iface eth2 inet static
    address 10.73.20.1
    netmask 255.255.255.0

# Switch 5 (Penyaring Penny)
auto eth3
iface eth3 inet static
    address 10.73.30.1
    netmask 255.255.255.0

# Switch 6 (Operator Alpha, Beta, Gamma)
auto eth4
iface eth4 inet static
    address 10.73.40.1
    netmask 255.255.255.0

# Switch 7 (Operator Delta, Epsilon)
auto eth5
iface eth5 inet static
    address 10.73.50.1
    netmask 255.255.255.0
```
2. Alpha
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.40.2
    netmask 255.255.255.0
    gateway 10.73.40.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
3. Beta
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.40.3
    netmask 255.255.255.0
    gateway 10.73.40.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
4. Gamma
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.40.4
    netmask 255.255.255.0
    gateway 10.73.40.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
5. Delta
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.50.2
    netmask 255.255.255.0
    gateway 10.73.50.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
6. Epsilon
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.50.3
    netmask 255.255.255.0
    gateway 10.73.50.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
7. Abbey
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.20.2
    netmask 255.255.255.0
    gateway 10.73.20.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
8. Penny
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.30.2
    netmask 255.255.255.0
    gateway 10.73.30.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
9. Prab
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.10.2
    netmask 255.255.255.0
    gateway 10.73.10.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
10. Tedd
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.10.3
    netmask 255.255.255.0
    gateway 10.73.10.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
11. Obladi
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.10.4
    netmask 255.255.255.0
    gateway 10.73.10.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
12. Desmond
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.10.5
    netmask 255.255.255.0
    gateway 10.73.10.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
13. Oblada
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.10.6
    netmask 255.255.255.0
    gateway 10.73.10.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
14. Molly
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.10.7
    netmask 255.255.255.0
    gateway 10.73.10.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
## Soal 2
Mengaktifkan routing dan NAT di Rootkit
```bash
sysctl -w net.ipv4.ip_forward=1
iptables -F
iptables -t nat -F
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -j ACCEPT
```
![img](assets/soal_2-1.png)<br>
![img](assets/soal_2-2.png)<br>
## Soal 3
Membuat divisi/subnet internal terhubung satu sama lain dan bisa mengakses internet. Hal ini bisa dilakukan dengan menambahkan konfigurasi berikut ke semua node non-router (selain rootkit).
```bash
up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
![img](assets/soal_3-1.png)<br>
![img](assets/soal_3-2.png)<br>
## Soal 4
Pertama-tama download bind9 di node Prab
```bash
apt update -o Acquire::ForceIPv4=true
apt install bind9 dnsutils -y -o Acquire::ForceIPv4=true
```
Kemudian konfigurasi node Prab sebagai DNS Master
```bash
cat << 'EOF' > /etc/bind/named.conf.options
options {
        directory "/var/cache/bind";

        forwarders {
                192.168.122.1;
        };

        dnssec-validation auto;
        listen-on-v6 { any; };
};
EOF

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

vault   IN      A       10.73.10.4
vault   IN      A       10.73.10.5
core    IN      A       10.73.10.6
core    IN      A       10.73.10.7

www     IN      CNAME   penny.k19.com.
static  IN      CNAME   abbey.k19.com.

alpha   IN      A       10.73.40.2
beta    IN      A       10.73.40.3
gamma   IN      A       10.73.40.4
delta   IN      A       10.73.50.2
epsilon IN      A       10.73.50.3
EOF

chown -R bind:bind /etc/bind/jarkom
service named restart
```

Selanjutnya download bind9 di node Tedd
```bash
apt update -o Acquire::ForceIPv4=true
apt install bind9 dnsutils -y -o Acquire::ForceIPv4=true
```
Kemudian konfigurasi node Tedd sebagai DNS Slave
```bash
cat << 'EOF' > /etc/bind/named.conf.options
options {
        directory "/var/cache/bind";

        forwarders {
                192.168.122.1;
        };

        dnssec-validation auto;
        listen-on-v6 { any; };
};
EOF

cat << 'EOF' > /etc/bind/named.conf.local
zone "k19.com" {
    type slave;
    masters { 10.73.10.2; };
    file "/var/lib/bind/k19.com";
};
EOF

service named restart
```
Terakhir lakukan konfigurasi dan pengujian dari non-router lain (contoh: alpha)
```bash
cat << 'EOF' > /etc/resolv.conf
nameserver 10.73.10.2
nameserver 10.73.10.3
nameserver 192.168.122.1
EOF

# Pengujian
host -t A k19.com
host prab.k19.com
host tedd.k19.com
```
![img](assets/soal_4.png)<br>
## Soal 5
Pertama jalankan ini di node Prab
```bash
cat << 'EOF' > /etc/bind/jarkom/k19.com
$TTL    604800
@       IN      SOA     prab.k19.com. root.k19.com. (
                        2026092802 ; Serial (Sudah dinaikkan agar Slave Sync)
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

service named restart
```
Selanjutnya jalankan ini di Tedd
```bash
rm -f /var/lib/bind/k19.com
service named restart
```
Terakhir jalankan testing di node lain (contoh: Alpha)
```bash
host alpha.k19.com
host delta.k19.com
host obladi.k19.com
host molly.k19.com
```
![img](assets/soal_5.png)<br>
## Soal 6
Jalankan perintah berikut di node Alpha
```bash
host -t SOA k19.com 10.73.10.2
host -t SOA k19.com 10.73.10.3
```
![img](assets/soal_6.png)<br>
## Soal 7
Pertama, konfigurasi node Prab dengan menaikkan nomor serial SOA
```bash
cat << 'EOF' > /etc/bind/jarkom/k19.com
$TTL    604800
@       IN      SOA     prab.k19.com. root.k19.com. (
                        2026092803 ; Serial (Naikkan angka serial)
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

; Gerbang Utama / Reverse Proxy
abbey   IN      A       10.73.20.2
penny   IN      A       10.73.30.2

; Area Vault (Web Statis - Round Robin)
vault   IN      A       10.73.10.4
vault   IN      A       10.73.10.5
obladi  IN      A       10.73.10.4
desmond IN      A       10.73.10.5

; Area Core (Web Dinamis - Round Robin)
core    IN      A       10.73.10.6
core    IN      A       10.73.10.7
oblada  IN      A       10.73.10.6
molly   IN      A       10.73.10.7

; Operator Clients
alpha   IN      A       10.73.40.2
beta    IN      A       10.73.40.3
gamma   IN      A       10.73.40.4
delta   IN      A       10.73.50.2
epsilon IN      A       10.73.50.3

; Alias CNAME
www     IN      CNAME   penny.k19.com.
static  IN      CNAME   abbey.k19.com.
EOF

named-checkzone k19.com /etc/bind/jarkom/k19.com
service named restart
```
Kemudian restart pada node Tedd
```bash
rm -f /var/lib/bind/k19.com
service named restart
```
Terakhir lakukan testing pada node Alpha dan Delta
```bash
cat << 'EOF' > /etc/resolv.conf
nameserver 10.73.10.2
nameserver 10.73.10.3
nameserver 192.168.122.1
EOF

host www.k19.com
host static.k19.com
host vault.k19.com
host core.k19.com
```
![img](assets/soal_7-alpha.png)<br>
![img](assets/soal_7-delta.png)<br>
## Soal 8
Pertama tambahkan deklarasi reverse zone di node Prab
```bash
cat << 'EOF' >> /etc/bind/named.conf.local

zone "10.73.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/10.73.10.in-addr.arpa";
    allow-transfer { 10.73.10.3; };
    also-notify { 10.73.10.3; };
    notify yes;
};

zone "20.73.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/20.73.10.in-addr.arpa";
    allow-transfer { 10.73.10.3; };
    also-notify { 10.73.10.3; };
    notify yes;
};

zone "30.73.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/30.73.10.in-addr.arpa";
    allow-transfer { 10.73.10.3; };
    also-notify { 10.73.10.3; };
    notify yes;
};
EOF
```
Selanjutnya buat file database PTR untuk masing-masing reverse zone
```bash
# File Reverse Zone 10.73.10 (Vault & Core)
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

2       IN      PTR     prab.k19.com.
3       IN      PTR     tedd.k19.com.
4       IN      PTR     obladi.k19.com.
5       IN      PTR     desmond.k19.com.
6       IN      PTR     oblada.k19.com.
7       IN      PTR     molly.k19.com.
EOF

# File Reverse Zone 20.73.10 (Abbey)
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

# File Reverse Zone 30.73.10 (Penny)
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
```
Restart
```bash
chown -R bind:bind /etc/bind/jarkom
service named restart
```
Selanjutnya deklarasi ketiga reverse zone sebagai type slave di node Tedd
```bash
cat << 'EOF' >> /etc/bind/named.conf.local

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
```
Restart
```bash
rm -f /var/lib/bind/*.in-addr.arpa
service named restart
```
Terakhir lakukan pengujian di node Alpha
```bash
host 10.73.10.4
host 10.73.10.5
host 10.73.10.6
host 10.73.10.7

host 10.73.20.2
host 10.73.30.2
```
![img](assets/soal_8.png)<br>
## Soal 9
Pertama lakukan konfigurasi di Obladi
```bash
apt update -o Acquire::ForceIPv4=true
apt install apache2 -y -o Acquire::ForceIPv4=true

# Buat direktori dan file sampel
mkdir -p /var/www/html/arsip
echo "File Arsip Vault Obladi 1" > /var/www/html/arsip/berkas1.txt
echo "File Arsip Vault Obladi 2" > /var/www/html/arsip/berkas2.txt

# Konfigurasi Autoindex untuk folder /arsip/
cat << 'EOF' > /etc/apache2/conf-available/arsip-autoindex.conf

    Options +Indexes

EOF
```
Aktifkan konfigurasi di Oblada
```bash
a2enconf arsip-autoindex
apachectl configtest
service apache2 restart
```
Kemdian lakukan konfigurasi di Desmond
```bash
apt update -o Acquire::ForceIPv4=true
apt install apache2 -y -o Acquire::ForceIPv4=true

# Buat direktori dan file sampel
mkdir -p /var/www/html/arsip
echo "File Arsip Vault Desmond 1" > /var/www/html/arsip/berkas1.txt
echo "File Arsip Vault Desmond 2" > /var/www/html/arsip/berkas2.txt

# Konfigurasi Autoindex untuk folder /arsip/
cat << 'EOF' > /etc/apache2/conf-available/arsip-autoindex.conf

    Options +Indexes

EOF
```
Aktifkan konfigurasi di Desmond
```bash
a2enconf arsip-autoindex
apachectl configtest
service apache2 restart
```
Terakhir lakukan testing di Alpha
```bash
curl -s http://obladi.k19.com/arsip/
curl -s http://desmond.k19.com/arsip/
curl -s http://vault.k19.com/arsip/
```
![img](assets/soal_9-obladi.png) <br>
![img](assets/soal_9-desmond.png) <br>
![img](assets/soal_9-vault.png) <br>
## Soal 10
Pertama lakukan konfigurasi di Oblada
```bash
apt update -o Acquire::ForceIPv4=true
apt install nginx php-fpm -y -o Acquire::ForceIPv4=true
service php$(ls /etc/php/ 2>/dev/null | tail -n 1)-fpm start 2>/dev/null || service php-fpm start 2>/dev/null || true

mkdir -p /var/www/html
echo "PD9waHAKZWNobyAiSGFsYW1hbiBQcm9maWwgRW50aXRhcyAtIE9CTEFEQS4gTm9kZTogb2JsYWRhLmsxOS5jb20gKDEwLjczLjEwLjYpXG4iOzsgCj8+" | base64 -d > /var/www/html/profil.php
chmod 644 /var/www/html/profil.php

nginx -t
service nginx restart
```
Kemudian lakukan konfigurasi di Molly
```bash
apt update -o Acquire::ForceIPv4=true
apt install nginx php-fpm -y -o Acquire::ForceIPv4=true
service php$(ls /etc/php/ 2>/dev/null | tail -n 1)-fpm start 2>/dev/null || service php-fpm start 2>/dev/null || true

mkdir -p /var/www/html
echo "PD9waHAKZWNobyAiSGFsYW1hbiBQcm9maWwgRW50aXRhcyAtIE1PTExZLiogTm9kZTogbW9sbHkuazE5LmNvbSAoMTAuNzMuMTAuNylcbiI7Owo/Pg==" | base64 -d > /var/www/html/profil.php
chmod 644 /var/www/html/profil.php

nginx -t
service nginx restart
```
Terakhir lakukan testing di node Alpha
```bash
curl http://oblada.k19.com/profil
curl http://molly.k19.com/profil
curl http://core.k19.com/profil
```
![img](assets/soal_10.png)<br>
## Soal 11
## Soal 12
## Soal 13
## Soal 14
## Soal 15
## Soal 16
## Soal 17
## Soal 18
## Soal 19
## Soal 20