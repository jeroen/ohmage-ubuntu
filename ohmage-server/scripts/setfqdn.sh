#!/bin/bash
IPADDR=$1

if [ "$IPADDR" = "" ]
then
	echo "Please supply argument: ./setfqdn.sh my.hostname.com"
else
	STATEMENT="UPDATE ohmage.preference SET p_value='$IPADDR' where p_key='fully_qualified_domain_name';"
	echo "Setting FQDN to $IPADDR"
	mysql -u ohmage -p\&\!sickly -e "$STATEMENT"	
fi
