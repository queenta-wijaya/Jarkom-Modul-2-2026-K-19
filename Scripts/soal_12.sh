#penny
apt install apache2-utils -y -o Acquire::ForceIPv4=true
a2enmod authn_file auth_basic authz_user

htpasswd -b -c /etc/apache2/.htpasswd prabs 'pakar_pinter_jadi_gob***'

cat << 'XEOF' > /etc/apache2/sites-available/reverse-proxy.conf
<VirtualHost *:80>
    ServerName www.k19.com

    ProxyRequests Off
    ProxyPreserveHost On
    RequestHeader set X-Real-IP "%{REMOTE_ADDR}s"
    RequestHeader set X-Forwarded-For "%{REMOTE_ADDR}s"

    # --- SOAL 12 (baru) ---
    <Location /admin>
        AuthType Basic
        AuthName "Restricted Area"
        AuthUserFile /etc/apache2/.htpasswd
        Require valid-user
    </Location>
    # ----------------------

    <Proxy "balancer://vaultcluster">
        BalancerMember http://10.73.10.4:80
        BalancerMember http://10.73.10.5:80
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPass / balancer://vaultcluster/
    ProxyPassReverse / balancer://vaultcluster/
</VirtualHost>
XEOF

apachectl configtest
service apache2 restart

#obladi 
mkdir -p /var/www/html/admin
echo "Halaman Admin Vault - obladi" > /var/www/html/admin/index.html

#desmond
mkdir -p /var/www/html/admin
echo "Halaman Admin Vault - desmond" > /var/www/html/admin/index.html

#uji alpha
curl -sI http://www.k19.com/admin/ | head -1
curl -sI -u 'prabs:pakar_pinter_jadi_gob***' http://www.k19.com/admin/ | head -1
curl -sI -u 'prabs:salah' http://www.k19.com/admin/ | head -1