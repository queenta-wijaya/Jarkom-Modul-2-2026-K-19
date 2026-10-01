#prab 
apt update -o Acquire::ForceIPv4=true
apt install dnsmasq -y -o Acquire::ForceIPv4=true

ZONE=/etc/bind/jarkom/k19.com
IP_LAMA=10.73.20.2
IP_BARU=10.73.99.99

naik_serial() {
  CUR=$(grep -m1 ';[[:space:]]*Serial' $ZONE | awk '{print $1}')
  NEW=$(date +%y%m%d%H%M)
  [ "$NEW" -le "$CUR" ] && NEW=$((CUR+1))
  sed -i -E "s/^([[:space:]]*)${CUR}([[:space:]]*;[[:space:]]*Serial)/\1${NEW}\2/" $ZONE
}

reload_zona() {
  named-checkzone k19.com $ZONE
  rndc reload k19.com > /dev/null 2>&1 || { pkill named; sleep 1; named -u bind; sleep 1; }
  rndc notify k19.com > /dev/null 2>&1
  sleep 2
}

# Resolver cache lokal (prab authoritative, jadi cache dibuat dengan dnsmasq port 5353)
pkill dnsmasq 2>/dev/null; sleep 1
dnsmasq --conf-file=/dev/null --port=5353 --listen-address=127.0.0.1 \
  --bind-interfaces --no-resolv --no-hosts --server=127.0.0.1#53 --cache-size=500

# TTL 15 detik dengan IP lama
sed -i -E "s/^abbey[[:space:]].*/abbey   15      IN      A       ${IP_LAMA}/" $ZONE
naik_serial
reload_zona

echo "=== KONDISI 1: sebelum perubahan (harus IP lama $IP_LAMA) ==="
dig @127.0.0.1 -p 5353 abbey.k19.com +noall +answer
T0=$(date +%s)

echo ""
echo ">>> Mengubah abbey.k19.com menjadi $IP_BARU (TTL 15 detik)"
sed -i -E "s/^abbey[[:space:]].*/abbey   15      IN      A       ${IP_BARU}/" $ZONE
naik_serial
reload_zona

echo ""
echo "=== KONDISI 2: jeda < 15 detik (harus MASIH IP lama karena cache) ==="
echo "Selisih sejak cache terisi: $(( $(date +%s) - T0 )) detik"
dig @127.0.0.1 -p 5353 abbey.k19.com +noall +answer

echo ""
echo "=== SINKRONISASI TEDD ==="
SPRAB=$(dig @10.73.10.2 k19.com SOA +short | awk '{print $3}')
STEDD=$(dig @10.73.10.3 k19.com SOA +short | awk '{print $3}')
echo "Serial prab: $SPRAB | Serial tedd: $STEDD"
echo "abbey di tedd: $(dig @10.73.10.3 abbey.k19.com +short)"

# Tunggu sampai TTL habis (>= 16 detik sejak cache terisi)
SISA=$(( 16 - ( $(date +%s) - T0 ) ))
[ "$SISA" -gt 0 ] && sleep $SISA

echo ""
echo "=== KONDISI 3: setelah TTL 15 detik habis (harus IP fiktif $IP_BARU) ==="
echo "Selisih sejak cache terisi: $(( $(date +%s) - T0 )) detik"
dig @127.0.0.1 -p 5353 abbey.k19.com +noall +answer

pkill dnsmasq
#Prab - revert abbey ke IP normal (prab-revert-abbey.sh)
ZONE=/etc/bind/jarkom/k19.com
sed -i -E "s/^abbey[[:space:]].*/abbey   IN      A       10.73.20.2/" $ZONE
sleep 1
CUR=$(grep -m1 ';[[:space:]]*Serial' $ZONE | awk '{print $1}')
NEW=$(date +%y%m%d%H%M)
[ "$NEW" -le "$CUR" ] && NEW=$((CUR+1))
sed -i -E "s/^([[:space:]]*)${CUR}([[:space:]]*;[[:space:]]*Serial)/\1${NEW}\2/" $ZONE
named-checkzone k19.com $ZONE
rndc reload k19.com > /dev/null 2>&1 || { pkill named; sleep 1; named -u bind; sleep 1; }
rndc notify k19.com > /dev/null 2>&1
sleep 3
echo -n "prab: "; dig @10.73.10.2 abbey.k19.com +short
echo -n "tedd: "; dig @10.73.10.3 abbey.k19.com +short

#uji alpha 
dig abbey.k19.com +short
curl -I http://abbey.k19.com/