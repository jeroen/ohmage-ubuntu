#run mysql without security:
cp /usr/lib/ohmage/scripts/skipgranttables.cnf /etc/mysql/conf.d/
service mysql restart

#give it some time to load
sleep 3
rm /etc/mysql/conf.d/skipgranttables.cnf

#drop database and user
echo "Deleting Ohmage database..."
mysql -u root < /usr/lib/ohmage/sql/wipe/wipedb.sql

#restart mysql with security
service mysql restart
