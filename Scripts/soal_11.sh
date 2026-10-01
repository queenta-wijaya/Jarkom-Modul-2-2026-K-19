#penny 
aapt update -o Acquire::ForceIPv4=true
apt install apache2 -y -o Acquire::ForceIPv4=true

a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests headers
a2dissite 000-default 2>/dev/null

cat << 'XEOF' > /etc/apache2/sites-available/10-www.conf
<VirtualHost *:80>
    ServerName www.k19.com

    ProxyRequests Off
    ProxyPreserveHost On
    RequestHeader set X-Real-IP expr=%{REMOTE_ADDR}

    <Proxy "balancer://vault">
        BalancerMember http://10.73.10.4:80
        BalancerMember http://10.73.10.5:80
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPass        "/" "balancer://vault/"
    ProxyPassReverse "/" "balancer://vault/"
</VirtualHost>
XEOF

a2ensite 10-www
apachectl configtest
service apache2 restart

#obladi dan #desmond
a2enmod remoteip

#abbey 
apt update -o Acquire::ForceIPv4=true
apt install nginx -y -o Acquire::ForceIPv4=true

rm -f /etc/nginx/sites-enabled/default

cat << 'XEOF' > /etc/nginx/sites-available/reverse-proxy
upstream core {
    server 10.73.10.6:80;
    server 10.73.10.7:80;
}

server {
    listen 80;
    server_name static.k19.com;

    location / {
        proxy_pass http://core;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
XEOF

ln -sf /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/reverse-proxy
nginx -t
pgrep -x nginx > /dev/null && nginx -s reload || nginx

#uji alpha 
for i in 1 2 3 4 5 6; do curl -s -o /dev/null -w "%{http_code}\n" http://www.k19.com/arsip/; done
curl -s http://static.k19.com/profil