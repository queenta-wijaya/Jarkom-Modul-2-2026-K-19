#prab 
ZONE=/etc/bind/jarkom/k19.com
for h in alpha beta gamma delta epsilon; do
  sed -i -E "/^${h}[[:space:]]+IN[[:space:]]+TXT/d" $ZONE
  echo "${h}   IN      TXT     \"${h}\"" >> $ZONE
done
sleep 1
CUR=$(grep -m1 ';[[:space:]]*Serial' $ZONE | awk '{print $1}')
NEW=$(date +%y%m%d%H%M)
[ "$NEW" -le "$CUR" ] && NEW=$((CUR+1))
sed -i -E "s/^([[:space:]]*)${CUR}([[:space:]]*;[[:space:]]*Serial)/\1${NEW}\2/" $ZONE
chown -R bind:bind /etc/bind/jarkom
named-checkzone k19.com $ZONE
rndc reload k19.com > /dev/null 2>&1 || { pkill named; sleep 1; named -u bind; sleep 1; }
rndc notify k19.com > /dev/null 2>&1
sleep 3

#uji alpha
for h in alpha beta gamma delta epsilon; do dig TXT $h.k19.com +short; done