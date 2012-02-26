#!/usr/bin/python

import os

# campaign_id 
campaignid=2

# modify start_id and end_id for a range of users that you want to generate 
# note: end_id is not included 
start_id=10
end_id=11

filename="data/add-one-user.properties"
alp_array=["a", "b", "c", "d", "e", "f", "g", "h", "i", "f"]
manageuser_class="edu.ucla.cens.awuser.ManageUser"
seed="$2a$04$r8zKliEptVkzoiQgD833Oe"

    
def create_user_file (userid) :
    suffix = "".join([alp_array[int(c)] for c in "%d" % userid])
    print suffix 
    f = open(filename, "w") 
    f.write("userName=testuser." + suffix + "\n")
    f.write("password=test.password\n")
    f.write("campaignId=%d\n" % campaignid)
    f.write("role=researcher\n")
    f.write("emailAddress=test@test.com\n")
    f.write("json={first_name:first,last_name:last}\n")
    f.write("dbUserName=andwellness\n")
    f.write("dbPassword=&!sickly\n")
    f.write("dbDriver=com.mysql.jdbc.Driver\n")
    f.write("dbJdbcUrl=jdbc:mysql://localhost:3306/andwellness\n")
    f.close()

# the upper bound is not included
for n in range (start_id,end_id):
    create_user_file (n)
    command="java -cp lib/*:classes %s add %s '%s'" % (manageuser_class, filename, seed)
    print command
    os.system(command)
    





