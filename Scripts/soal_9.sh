#Obladi
apt update -o Acquire::ForceIPv4=true
apt install apache2 -y -o Acquire::ForceIPv4=true

mkdir -p /var/www/html/arsip
echo "File Arsip Vault Desmond 1" > /var/www/html/arsip/berkas1.txt
echo "File Arsip Vault Desmond 2" > /var/www/html/arsip/berkas2.txt

# 1. Tulis konfigurasi arsip-autoindex paling bersih (tanpa AllowOverride/Require)
cat << 'EOF' > /etc/apache2/conf-available/arsip-autoindex.conf

    Options +Indexes

EOF

# 2. Kembalikan 000-default.conf ke bentuk paling netral
cat << 'EOF' > /etc/apache2/sites-available/000-default.conf

    DocumentRoot /var/www/html

EOF

# 3. Test config dan restart Apache
apachectl configtest
service apache2 restart

#Desmond
apt update -o Acquire::ForceIPv4=true
apt install apache2 -y -o Acquire::ForceIPv4=true

mkdir -p /var/www/html/arsip
echo "File Arsip Vault Desmond 1" > /var/www/html/arsip/berkas1.txt
echo "File Arsip Vault Desmond 2" > /var/www/html/arsip/berkas2.txt

cat << 'EOF' > /etc/apache2/conf-available/arsip-autoindex.conf

    Options +Indexes

EOF

# 2. Kembalikan 000-default.conf ke bentuk paling netral
cat << 'EOF' > /etc/apache2/sites-available/000-default.conf

    DocumentRoot /var/www/html

EOF

apachectl configtest
service apache2 restart

#Alpha
curl -s http://obladi.k19.com/arsip/
curl -s http://desmond.k19.com/arsip/
curl -s http://vault.k19.com/arsip/