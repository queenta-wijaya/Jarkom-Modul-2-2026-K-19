#Obladi
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

# Aktifkan konfigurasinya
a2enconf arsip-autoindex
apachectl configtest
service apache2 restart

#Desmond
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

# Aktifkan konfigurasinya
a2enconf arsip-autoindex
apachectl configtest
service apache2 restart

#Alpha
curl -s http://obladi.k19.com/arsip/
curl -s http://desmond.k19.com/arsip/
curl -s http://vault.k19.com/arsip/