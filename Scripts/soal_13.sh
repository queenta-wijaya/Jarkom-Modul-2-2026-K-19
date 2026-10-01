#penny
cat << 'XEOF' > /etc/apache2/sites-available/00-redirect.conf
<VirtualHost *:80>
    ServerName penny.k19.com
    Redirect permanent / http://www.k19.com/
</VirtualHost>
XEOF

a2ensite 00-redirect
apachectl configtest
service apache2 restart

#abbey 
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
curl -I http://10.73.30.2/
curl -I http://penny.k19.com/
curl -I http://10.73.20.2/
curl -I http://abbey.k19.com/