#Dari rootkit
ip addr add 10.73.10.1/24 dev eth1 2>/dev/null
ip addr add 10.73.20.1/24 dev eth2 2>/dev/null
ip addr add 10.73.30.1/24 dev eth3 2>/dev/null
ip addr add 10.73.40.1/24 dev eth2 2>/dev/null
ip addr add 10.73.50.1/24 dev eth5 2>/dev/null

#Dari alpha
ping 8.8.8.8 -c 3
ping 10.73.10.2 -c 3