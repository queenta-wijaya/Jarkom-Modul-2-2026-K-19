#Prabs
nano /etc/bind/jarkom/k19.com

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

; Apex Domain (Gerbang Aplikasi Dinamis - Penny)
@       IN      A       10.73.30.2

; Host Utama BIND9
prab    IN      A       10.73.10.2
tedd    IN      A       10.73.10.3

; Gerbang Aplikasi / Penyaring
abbey   IN      A       10.73.20.2
penny   IN      A       10.73.30.2

; Repository Vault (Load Balancing Round Robin - Obladi & Desmond)
vault   IN      A       10.73.10.4
vault   IN      A       10.73.10.5

; Repository Core (Load Balancing Round Robin - Oblada & Molly)
core    IN      A       10.73.10.6
core    IN      A       10.73.10.7

; Alias CNAME
www     IN      CNAME   penny.k19.com.
static  IN      CNAME   abbey.k19.com.

; Operator Clients
alpha   IN      A       10.73.40.2
beta    IN      A       10.73.40.3
gamma   IN      A       10.73.40.4
delta   IN      A       10.73.50.2
epsilon IN      A       10.73.50.3

named-checkzone k19.com /etc/bind/jarkom/k19.com
service named restart

#Tedd
service named restart

#Alpha
host -t CNAME www.k19.com
host -t CNAME static.k19.com
host vault.k19.com
host core.k19.com
host alpha.k19.com
host delta.k19.com