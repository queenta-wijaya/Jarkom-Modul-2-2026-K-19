#Oblada
apt update -o Acquire::ForceIPv4=true
apt install nginx php-fpm -y -o Acquire::ForceIPv4=true
service php$(ls /etc/php/ 2>/dev/null | tail -n 1)-fpm start 2>/dev/null || service php-fpm start 2>/dev/null || true

mkdir -p /var/www/html
echo "PD9waHAKZWNobyAiSGFsYW1hbiBQcm9maWwgRW50aXRhcyAtIE9CTEFEQS4gTm9kZTogb2JsYWRhLmsxOS5jb20gKDEwLjczLjEwLjYpXG4iOzsgCj8+" | base64 -d > /var/www/html/profil.php
chmod 644 /var/www/html/profil.php

nginx -t
service nginx restart

#Molly
apt update -o Acquire::ForceIPv4=true
apt install nginx php-fpm -y -o Acquire::ForceIPv4=true
service php$(ls /etc/php/ 2>/dev/null | tail -n 1)-fpm start 2>/dev/null || service php-fpm start 2>/dev/null || true

mkdir -p /var/www/html
echo "PD9waHAKZWNobyAiSGFsYW1hbiBQcm9maWwgRW50aXRhcyAtIE1PTExZLiogTm9kZTogbW9sbHkustE5LmNvbSAoMTAuNzMuMTAuNylcbiI7Owo/Pg==" | base64 -d > /var/www/html/profil.php
chmod 644 /var/www/html/profil.php

nginx -t
service nginx restart

#Alpha
curl http://oblada.k19.com/profil
curl http://molly.k19.com/profil
curl http://core.k19.com/profil