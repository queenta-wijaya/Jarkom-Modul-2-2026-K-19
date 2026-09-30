# Jarkom-Modul-2-2026-K-19
## Anggota Kelompok
| Nama | NRP |
| --- | --- |
| Ni Putu Maqueenta Wijaya | 5027251004 |
| Malikha Syafira Dewi | 5027251032 |
## Pembahasan
## Soal 1
Membuat topologi sesuai yang diminta soal
![img](assets/soal_1.png)<br>
Konfigurasi Node:
1. Rootkit
```bash
auto lo
iface lo inet loopback

# Connection to NAT
auto eth0
iface eth0 inet dhcp

# Switch 1 (Directory & Repository)
auto eth1
iface eth1 inet static
    address 10.73.10.1
    netmask 255.255.255.0

# Switch 4 (Penyaring Abbey)
auto eth2
iface eth2 inet static
    address 10.73.20.1
    netmask 255.255.255.0

# Switch 5 (Penyaring Penny)
auto eth3
iface eth3 inet static
    address 10.73.30.1
    netmask 255.255.255.0

# Switch 6 (Operator Alpha, Beta, Gamma)
auto eth4
iface eth4 inet static
    address 10.73.40.1
    netmask 255.255.255.0

# Switch 7 (Operator Delta, Epsilon)
auto eth5
iface eth5 inet static
    address 10.73.50.1
    netmask 255.255.255.0
```
2. Alpha
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.40.2
    netmask 255.255.255.0
    gateway 10.73.40.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
3. Beta
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.40.3
    netmask 255.255.255.0
    gateway 10.73.40.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
4. Gamma
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.40.4
    netmask 255.255.255.0
    gateway 10.73.40.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
5. Delta
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.50.2
    netmask 255.255.255.0
    gateway 10.73.50.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
6. Epsilon
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.50.3
    netmask 255.255.255.0
    gateway 10.73.50.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
7. Abbey
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.20.2
    netmask 255.255.255.0
    gateway 10.73.20.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
8. Penny
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.30.2
    netmask 255.255.255.0
    gateway 10.73.30.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
9. Prab
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.10.2
    netmask 255.255.255.0
    gateway 10.73.10.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
10. Tedd
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.10.3
    netmask 255.255.255.0
    gateway 10.73.10.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
11. Obladi
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.10.4
    netmask 255.255.255.0
    gateway 10.73.10.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
12. Desmond
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.10.5
    netmask 255.255.255.0
    gateway 10.73.10.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
13. Oblada
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.10.6
    netmask 255.255.255.0
    gateway 10.73.10.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
14. Molly
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.10.7
    netmask 255.255.255.0
    gateway 10.73.10.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
## Soal 2
Mengaktifkan routing dan NAT di Rootkit
```bash
sysctl -w net.ipv4.ip_forward=1
iptables -F
iptables -t nat -F
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -j ACCEPT
```
![img](assets/soal_2-1.png)<br>
![img](assets/soal_2-2.png)<br>
## Soal 3
