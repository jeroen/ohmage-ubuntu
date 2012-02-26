#!/bin/sh

# temporary property filename 
CAMPAIGNID=1
FILENAME=data/add-one-user.properties
MANAGEUSER_CLASS=org.andwellness.awuser.ManageUser 
SEED='$2a$04$r8zKliEptVkzoiQgD833Oe'

create_user_file ()
{
    array=(a b c d e f g h i j k l)
    limit=${#1}
    i=0
    fname=''
    while [[ $i -lt $limit ]]
    do 
	fname="${fname}${array[${1:$i:1}]}"
	i=$(( $i + 1 ))
    done

    cat > $FILENAME << EOF
userName=testuser.$fname
password=test.password
campaignId=$CAMPAIGNID
role=researcher
emailAddress=test@test.com
json={first_name:first,last_name:last}
dbUserName=andwellness
dbPassword=&!sickly
dbDriver=com.mysql.jdbc.Driver
dbJdbcUrl=jdbc:mysql://localhost:3306/andwellness
EOF
}

# change the range to something else if more users are needed
for n in {15..16} 
do
    create_user_file $n
#    cat $FILENAME
    echo java -cp lib/*:classes $MANAGEUSER_CLASS add $FILENAME \'$SEED\'
    java -cp lib/*:classes $MANAGEUSER_CLASS add $FILENAME $SEED
done
