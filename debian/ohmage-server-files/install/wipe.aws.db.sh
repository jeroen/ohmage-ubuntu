#create temporary root user
service mysql stop
mysqld --skip-grant-tables &
sleep 3s #give mysql some time to load
mysql -u root -e  "INSERT INTO mysql.user VALUES('%','awstemproot','','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','','','','',0,0,0,0);"
pkill mysql
service mysql start

#drop current database
mysql -u awstemproot -e "drop database andwellness;"
mysql -u awstemproot -e "drop user 'andwellness'@'localhost'"
mysql -u awstemproot -e "drop user awstemproot;"

#restart
service mysql restart
