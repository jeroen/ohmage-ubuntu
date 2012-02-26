### DEPRECATED ###
### THIS SCRIPT IS NO LONGER IN USE ###

#COMPILE (on target box)
apt-get update
apt-get upgrade
apt-get install openjdk-6-jre mysql-server tomcat7 patch

#create temporary root user
service mysql stop
mysqld --skip-grant-tables &
sleep 3s #give mysql some time to load
mysql -u root -e  "INSERT INTO mysql.user VALUES('%','awstemproot','','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','','','','',0,0,0,0);"
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

#create andwellness user and deletes awstemproot
mysql -u awstemproot < create.user.sql

#create tomcat keystore 
#use passwd: changeit
#keytool -genkey -alias tomcat -keyalg RSA -keystore /usr/share/tomcat7/.keystore

#enable AJP13 and SSL connector:
nano /etc/tomcat7/server.xml

#put the /opt/aw directory into place
tar xzvf aw.tar.gz -C /opt
chown -Rf tomcat7 /opt/aw
chgrp -Rf tomcat7 /opt/aw

#Deploy WAR files
rm -Rf /var/lib/tomcat7/webapps/ROOT
service tomcat7 stop
cp ./dist/webapp-ohmage-2.7-no_ssl.war /var/lib/tomcat7/webapps/app.war
cp ./dist/MobilizeWeb-nossl.war /var/lib/tomcat7/webapps/ROOT.war
service tomcat7 start


#Apache part
sudo apt-get install apache2 libapache2-mod-jk ssl-cert
sudo a2dissite default
sudo nano /etc/libapache2-mod-jk/workers.properties

# SETTINGS:
# workers.tomcat_home=/var/lib/tomcat7
# workers.java_home=/usr/lib/jvm/java-6-openjdk

# Enable https
cp ohmage-https /etc/apache2/sites-available/
sudo a2enmod ssl
sudo a2ensite ohmage-ssl
sudo service apache2 restart

