#prab 
ZONE=/etc/bind/jarkom/k19.com
sed -i -E '/^outbound[[:space:]]/d' $ZONE
echo "outbound        IN      CNAME   http.badssl.com." >> $ZONE
sleep 1
CUR=$(grep -m1 ';[[:space:]]*Serial' $ZONE | awk '{print $1}')
NEW=$(date +%y%m%d%H%M)
[ "$NEW" -le "$CUR" ] && NEW=$((CUR+1))
sed -i -E "s/^([[:space:]]*)${CUR}([[:space:]]*;[[:space:]]*Serial)/\1${NEW}\2/" $ZONE
named-checkzone k19.com $ZONE
rndc reload k19.com > /dev/null 2>&1 || { pkill named; sleep 1; named -u bind; sleep 1; }
rndc notify k19.com > /dev/null 2>&1
sleep 3
echo -n "Serial prab: "; dig @10.73.10.2 k19.com SOA +short | awk '{print $3}'
echo -n "Serial tedd: "; dig @10.73.10.3 k19.com SOA +short | awk '{print $3}'
dig @10.73.10.2 outbound.k19.com +short
dig @10.73.10.3 outbound.k19.com +short

#uji alpha 
dig outbound.k19.com +short
curl -I http://outbound.k19.com/
curl -s http://outbound.k19.com/ | grep -i title
curl -s -H "Host: http.badssl.com" http://outbound.k19.com/ | grep -i title
curl -s -H "Host: http.badssl.com" http://outbound.k19.com/

