#drop current database
mysql -u awstemproot -e "drop database ohmage;"
mysql -u awstemproot -e "drop user 'ohmage'@'localhost'"
mysql -u awstemproot -e "drop user awstemproot;"
