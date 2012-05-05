#create temporary root user
service mysql stop
mysqld --skip-grant-tables &
sleep 5s #give mysql some time to load
mysql -u root -e "DELETE FROM mysql.user WHERE user = '';"
mysql -u root -e "INSERT INTO mysql.user VALUES('%','awstemproot','','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','','','','',0,0,0,0,'','');"
pkill mysql
service mysql start

#drop current database
#mysql -u awstemproot -e "drop database andwellness;"

#deploy mysql stuff
mysql -u awstemproot < andwellness-ddl.sql

#include all of the sql files
rm ./sql-extra/andwellness_preferences.sql ./sql-extra/chipts_preferences.sql ./sql-extra/survey_response_privacy_states-chipts.sql
echo "use andwellness" > extra.sql
cat ./sql-extra/*.sql >> extra.sql
mysql -u awstemproot < extra.sql
rm extra.sql

#create andwellness user and deletes awstemproot
mysql -u awstemproot < create.user.sql

