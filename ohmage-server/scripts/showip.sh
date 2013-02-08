IPADDR=""
IPADDR=`/usr/lib/ohmage/scripts/getip.sh`

if [ "$IPADDR" = "" ]
then
	echo "  Couldn't detect hostname to find hostname."
else
	echo ""
	echo "  Hostname guess:"
	echo "  https://$IPADDR/"
	echo ""
fi
