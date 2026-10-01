#obladi dan #desmond 
a2enmod remoteip

cat << 'XEOF' > /etc/apache2/conf-available/remoteip.conf
RemoteIPHeader X-Real-IP
RemoteIPInternalProxy 10.73.30.2
XEOF
a2enconf remoteip

if ! grep -rqs "proxy.log" /etc/apache2/sites-enabled /etc/apache2/conf-enabled; then
cat << 'XEOF' > /etc/apache2/conf-available/proxylog.conf
LogFormat "%a host=%{Host}i real=%{X-Real-IP}i xff=%{X-Forwarded-For}i" proxylog
CustomLog ${APACHE_LOG_DIR}/proxy.log proxylog
XEOF
a2enconf proxylog
fi

apachectl configtest
service apache2 restart

#oblada dan molly
c# Cek dulu isi aslinya: cat /etc/nginx/sites-available/default
cat << 'XEOF' > /etc/nginx/conf.d/proxylog.conf
log_format proxylog '$remote_addr host=$host real=$http_x_real_ip xff=$http_x_forwarded_for';
XEOF

cat << 'XEOF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    root /var/www/html;
    index index.php index.html;

    set_real_ip_from 10.73.20.2;
    real_ip_header X-Real-IP;
    access_log /var/log/nginx/access.log;
    access_log /var/log/nginx/proxy.log proxylog;

    location = /profil {
        rewrite ^ /profil.php last;
    }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
XEOF

nginx -t
service nginx restart

#alpha
curl -s -o /dev/null http://www.k19.com/arsip/
curl -s -o /dev/null http://static.k19.com/profil

#cek log obladi dan desmond 
tail -n 3 /var/log/apache2/access.log
tail -n 3 /var/log/apache2/proxy.log
#cek log oblada dan molly
tail -n 3 /var/log/nginx/access.log
tail -n 3 /var/log/nginx/proxy.log