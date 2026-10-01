#alpha 
apt install apache2-utils -y -o Acquire::ForceIPv4=true
ab -n 250 -c 10 http://www.k19.com/
ab -n 250 -c 10 http://static.k19.com/

