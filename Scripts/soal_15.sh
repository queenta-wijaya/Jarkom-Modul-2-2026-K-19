#penny
apt install php8.4-fpm -y -o Acquire::ForceIPv4=true
a2enmod proxy_fcgi

mkdir -p /var/www/eternal
cat << 'XEOF' > /var/www/eternal/index.php
<?php echo "Eternal - PHP aktif, versi " . PHP_VERSION . "\n"; ?>
XEOF

cat << 'XEOF' > /etc/apache2/sites-available/10-www.conf
<VirtualHost *:80>
    ServerName www.k19.com

    ProxyRequests Off
    ProxyPreserveHost On
    RequestHeader set X-Real-IP expr=%{REMOTE_ADDR}

    Alias /eternal /var/www/eternal
    <Directory /var/www/eternal>
        Options -Indexes +FollowSymLinks
        AllowOverride None
        Require all granted
        DirectoryIndex index.php index.html
        <FilesMatch "\.php$">
            SetHandler "proxy:unix:/run/php/php8.4-fpm.sock|fcgi://localhost"
        </FilesMatch>
    </Directory>

    <Location "/admin">
        AuthType Basic
        AuthName "Admin Area"
        AuthUserFile /etc/apache2/.htpasswd
        Require valid-user
    </Location>

    <Proxy "balancer://vault">
        BalancerMember http://10.73.10.4:80
        BalancerMember http://10.73.10.5:80
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPass        "/eternal" "!"
    ProxyPass        "/" "balancer://vault/"
    ProxyPassReverse "/" "balancer://vault/"
</VirtualHost>
XEOF

php-fpm8.4 -D
apachectl configtest
service apache2 restart

#abbey 
mkdir -p /var/www/orion
echo "Orion - halaman statis" > /var/www/orion/index.html
echo '<?php echo "PHP TIDAK boleh dieksekusi di sini\n"; ?>' > /var/www/orion/test.php

cat << 'XEOF' > /etc/nginx/sites-available/reverse-proxy
upstream core {
    server 10.73.10.6:80;
    server 10.73.10.7:80;
}

server {
    listen 80 default_server;
    server_name abbey.k19.com _;
    return 302 http://static.k19.com$request_uri;
}

server {
    listen 80;
    server_name static.k19.com;

    location = /orion { return 301 /orion/; }
    location /orion/ {
        alias /var/www/orion/;
        index index.html;
    }

    location / {
        proxy_pass http://core;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
XEOF

nginx -t
nginx -s reload

#uji alpha
curl -s http://www.k19.com/eternal/ | head -3
curl -i http://static.k19.com/orion/
curl -i http://static.k19.com/orion/test.php