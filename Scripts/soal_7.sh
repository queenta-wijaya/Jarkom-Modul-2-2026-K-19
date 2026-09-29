#alpha & delta
cat << 'EOF' > /etc/resolv.conf
nameserver 10.73.10.2
nameserver 10.73.10.3
nameserver 192.168.122.1
EOF

host www.k19.com
host static.k19.com
host vault.k19.com
host core.k19.com