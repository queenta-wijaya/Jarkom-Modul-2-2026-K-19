#Alpha
host -t SOA k19.com 10.73.10.2
host -t SOA k19.com 10.73.10.3
dig @10.73.10.3 k19.com AXFR

#Tedd
dig @10.73.10.2 k19.com AXFR