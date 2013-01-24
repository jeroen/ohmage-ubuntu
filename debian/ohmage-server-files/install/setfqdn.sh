if [ -f /usr/bin/ec2metadata ]
then
	EC2IP=`timeout 1 ec2metadata --public-hostname`
else
	EC2IP=""
fi

if [ "$EC2IP" = "" ]
then
	IPADDR=`ifconfig | perl -ple 'print $_ if /inet addr/ and $_ =~ s/.*inet addr:((?:\d+\.){3}\d+).*/$1/g  ;$_=""' | grep -v ^\s*$ | grep -v 127.0.0.1 | head -n 1`
	FQDN="$IPADDR"
else
	FQDN="$EC2IP"
fi

STATEMENT="UPDATE ohmage.preference SET p_value='$FQDN' where p_key='fully_qualified_domain_name';"
echo "Setting FQDN to $FQDN"
mysql -u ohmage -p\&\!sickly -e "$STATEMENT"
