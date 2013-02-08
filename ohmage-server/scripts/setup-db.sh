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

#create database and user
echo "Setting up Ohmage database..."
mysql -u root < dbsetup.sql
rm dbsetup.sql
