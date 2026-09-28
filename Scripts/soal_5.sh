#Prabs
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

#Tedd
rm -f /var/lib/bind/k19.com
service named restart

#Alpha
host obladi.k19.com
host desmond.k19.com
host oblada.k19.com
host molly.k19.com