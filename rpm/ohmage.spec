Name: ohmage
Version: 2.14
Release: 28
Source: %{name}-%{version}.tar.gz
License: Apache2
Summary: The Ohmage system for participatory sensing.
Group: Applications/Internet
BuildArch: noarch
Buildroot: %{_tmppath}/%{name}-buildroot
URL: http://www.ohmage.org
Requires: ohmage-server

%description
The Ohmage system. See www.ohmage.org

%package server
Summary: Ohmage server and GWT frontend
Group: Applications/Internet
Requires: patch
Requires: mysql
Requires: mysql-server
Requires: curl
Requires: tomcat
Requires: httpd
Requires: mod_ssl
%description server
Ohmage server and GWT frontend

%package selfreg
Summary: Self registration for Ohmage
Group: Applications/Internet
Requires: ohmage-server
Requires: MTA
%description selfreg
Self registration module for the Ohmage server.

%prep
%setup

%build
echo "War files have been precompiled."

%install
mkdir -p  %{buildroot}/usr/lib/ohmage
mkdir -p  %{buildroot}/var/lib/ohmage
mkdir -p  %{buildroot}/var/log/ohmage
mkdir -p  %{buildroot}/etc/httpd/conf.d/
mkdir -p  %{buildroot}/var/lib/tomcat/webapps/
mkdir -p  %{buildroot}/var/lib/ohmage/images
mkdir -p  %{buildroot}/var/lib/ohmage/documents
mkdir -p  %{buildroot}/var/lib/ohmage/videos
mkdir -p  %{buildroot}/var/log/ohmage/audits
cp -Rf scripts  %{buildroot}/usr/lib/ohmage/
cp -Rf sql  %{buildroot}/usr/lib/ohmage/
cp -Rf warfiles  %{buildroot}/usr/lib/ohmage/
cp scripts/ohmage  %{buildroot}/etc/httpd/conf.d/ohmage.conf

%pre server
rm -Rf /var/lib/tomcat/webapps/app
rm -Rf /var/lib/tomcat/webapps/ohmage
service tomcat stop || true
service httpd stop || true

%post server
chown -Rf tomcat /var/lib/ohmage
chgrp -Rf tomcat /var/lib/ohmage
chown -Rf tomcat /var/log/ohmage
chgrp -Rf tomcat /var/log/ohmage

#create symlinks for tomcat webapps
ln -sf /usr/lib/ohmage/warfiles/app.war /var/lib/tomcat/webapps/app.war || true
ln -sf /usr/lib/ohmage/warfiles/ohmage.war /var/lib/tomcat/webapps/ohmage.war || true

#make scripts executable
cd /usr/lib/ohmage/scripts				
chmod +x *.sh	

#setup database
echo "Setting up Ohmage database..."
cp /etc/my.cnf /usr/lib/ohmage/
echo "" >> /etc/my.cnf
cat /usr/lib/ohmage/scripts/skipgranttables.cnf >> /etc/my.cnf
service mysqld restart
rm /etc/my.cnf
mv /usr/lib/ohmage/my.cnf /etc/my.cnf
/usr/lib/ohmage/scripts/setup-db.sh 
service mysqld restart

#update FQDN
cd /usr/lib/ohmage/scripts
./setfqdn.sh `./getip.sh` || true

#enable ajp connector (already enabled)
#patch -N /etc/tomcat/server.xml enable-tomcat-ajp.patch || true

#Enable HTTP/HTTPS
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp --dport 443 -j ACCEPT
service iptables save

#start services
service tomcat start	
service httpd start	

#try to print IP
/usr/lib/ohmage/scripts/showip.sh

%preun server
service tomcat stop || true
service httpd stop || true

echo "Removing files..."
rm -Rf /var/lib/ohmage/images/*
rm -Rf /var/lib/ohmage/documents/*
rm -Rf /var/lib/ohmage/videos/*
rm -Rf /var/log/ohmage/*	

echo "Removing Ohmage database..."
cp /etc/my.cnf /usr/lib/ohmage/
echo "" >> /etc/my.cnf
cat /usr/lib/ohmage/scripts/skipgranttables.cnf >> /etc/my.cnf
service mysqld restart
rm /etc/my.cnf
mv /usr/lib/ohmage/my.cnf /etc/my.cnf
mysql -u root < /usr/lib/ohmage/sql/wipe/wipedb.sql
service mysqld restart

echo "Removing webapps..."
rm -f /var/lib/tomcat/webapps/app.war
rm -f /var/lib/tomcat/webapps/ohmage.war		
rm -Rf /var/lib/tomcat/webapps/ohmage
rm -Rf /var/lib/tomcat/webapps/app	

%postun server
service tomcat start || true
service httpd start || true

%post selfreg
#update self registration preferences.
mysql -u ohmage -p\&\!sickly -e 'UPDATE ohmage.preference SET p_value="true" where p_key="self_registration_allowed";'
mysql -u ohmage -p\&\!sickly -e 'UPDATE ohmage.preference SET p_value="6Lc1V9ESAAAAAN8l_rFAn5LZWBVcSUEoCEVZzhya" where p_key="recaptcha_public_key";'
mysql -u ohmage -p\&\!sickly -e 'UPDATE ohmage.preference SET p_value="6Lc1V9ESAAAAAJRdzruUdgzcXBP-CQpoeX1sv_Tn" where p_key="recaptcha_private_key";'
clear
echo "Enabled self registration. Make sure your SMTP server is working properly though."
/usr/lib/ohmage/scripts/showip.sh

%postun selfreg
mysql -u ohmage -p\&\!sickly -e 'UPDATE ohmage.preference SET p_value="false" where p_key="self_registration_allowed";' || true
mysql -u ohmage -p\&\!sickly -e 'UPDATE ohmage.preference SET p_value="" where p_key="recaptcha_public_key";' || true
mysql -u ohmage -p\&\!sickly -e 'UPDATE ohmage.preference SET p_value="" where p_key="recaptcha_private_key";' || true
echo "Self registration disabled."

%files

%files server
/usr/lib/ohmage/warfiles
/usr/lib/ohmage/sql
/usr/lib/ohmage/scripts
/etc/httpd/conf.d/ohmage.conf
%dir /var/lib/ohmage
%dir /var/lib/ohmage/images
%dir /var/lib/ohmage/documents
%dir /var/lib/ohmage/videos
%dir /var/log/ohmage
%dir /var/log/ohmage/audits
%dir /usr/lib/ohmage

%files selfreg
