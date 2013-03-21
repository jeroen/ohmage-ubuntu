#to drop current database
#mysql -u root -e "drop database ohmage;"

#cd to sql dir
cd /usr/lib/ohmage/sql

#append all sql stuff
cat ./base/*.sql > dbsetup.sql
cat ./preferences/default_preferences.sql >> dbsetup.sql
cat ./settings/*.sql >> dbsetup.sql
cat ./user/*.sql >> dbsetup.sql
cat ./custom/*.sql >> dbsetup.sql

#run mysql without security:
cp /usr/lib/ohmage/scripts/skipgranttables.cnf /etc/mysql/conf.d/
service mysql restart

#Give it some time to load
sleep 3
rm /etc/mysql/conf.d/skipgranttables.cnf

#create database and user
echo "Setting up Ohmage database..."
mysql -u root < dbsetup.sql
rm dbsetup.sql

#restart mysql with security
service mysql restart
