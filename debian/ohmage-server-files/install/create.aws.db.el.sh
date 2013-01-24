#create temporary root user
mysql -u root -e "INSERT INTO mysql.user VALUES('%','awstemproot','','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','','','','',0,0,0,0,'','');"

#drop current database
#mysql -u awstemproot -e "drop database ohmage;"

cat ./sql/base/*.sql > mydb.sql
cat ./sql/preferences/default_preferences.sql >> mydb.sql
cat ./sql/settings/*.sql >> mydb.sql
cat ./sql/custom/*.sql >> mydb.sql

#deploy mysql stuff
mysql -u awstemproot < mydb.sql
rm mydb.sql

#create andwellness user and deletes awstemproot
mysql -u awstemproot < create.user.sql

