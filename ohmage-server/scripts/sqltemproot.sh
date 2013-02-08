cp /usr/lib/ohmage/scripts/skipgranttables.cnf /etc/mysql/conf.d/
service mysql restart
mysql -u root -e "DELETE FROM mysql.user WHERE user = '';"
mysql -u root -e "INSERT INTO mysql.user VALUES('%','awstemproot','','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','','','','',0,0,0,0,'','');"
rm /etc/mysql/conf.d/skipgranttables.cnf
service mysql restart
