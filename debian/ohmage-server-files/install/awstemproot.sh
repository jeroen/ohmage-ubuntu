mysqld --skip-grant-tables --user=mysql &
sleep 5s #give mysql some time to load
mysql -u root -e "DELETE FROM mysql.user WHERE user = '';"
mysql -u root -e "INSERT INTO mysql.user VALUES('%','awstemproot','','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','','','','',0,0,0,0,'','');"
pkill mysql

