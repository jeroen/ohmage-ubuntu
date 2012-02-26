#!/bin/sh

########################################################################################
# DB config 
dbHost="localhost"
dbPort=3306
dbSocket="/opt/aw/dbs/logs/dbsd.sock"
dbUserName="andwellness"
dbPassword="&!sickly"
dbName="andwellness"
salt='$2a$04$r8zKliEptVkzoiQgD833Oe'

# mysql command-line arguments
sql_args=( -h "$dbHost" -P "$dbPort" -S "$dbSocket" -u "$dbUserName" -p"$dbPassword" -D "$dbName" )

# to avoid sql injection problem 
quote()
{
    sed "s/'/''/g" <<< "$1" 
}

# run sql with one line of arguments
sql_run()
{ 
    local status
    mysql "${sql_args[@]}" <<< "$@" 
    status=$?
    return $status
}

# run sql with multi-line statement
sql_run_batch()
{
    mysql "${sql_args[@]}"
}

# -------------- user ----------------
# user_add <login> <password> <privilege>
# the function will bcrypt with password and salt before adding 
# the password into the table.
# default: enabled=1, new_account=0
# Note: the system needs to support python and python_bcrypt library
user_add()
{
    if [[ ${#1} -lt 9 ]] || [[ ${#1} -gt 15 ]] 
    then 
	echo "ERROR: login name must be 5 to 15 characters"
	echo "ERROR: user_add $@"
	exit 1
    fi

    if [[ ${#2} -lt 9 ]] || [[ ${#2} -gt 15 ]]
    then 
	echo "ERROR: password must be 9 to 15 characters"
	echo "ERROR: user_add $@"
	exit 1
    fi
    
    hashpw=$(./bcryptHashpw.py "$2" "$salt")
    sql_command="INSERT INTO user (login_id, password, enabled, new_account, campaign_creation_privilege) VALUES ( '$(quote "$1")', '$(quote $hashpw)', b'1', b'0', b'$(quote "$3")');"

    sql_run "$sql_command" || echo "ERROR: user_add $@"
}

# user_nohash_add <login> <password> <privilege>
# this function assumes that the password passed to the function is already hashed!
user_nohash_add()
{
    if [[ ${#1} -lt 9 ]] || [[ ${#1} -gt 15 ]] 
    then 
	echo "ERROR: login name must be 5 to 15 characters"
	echo "ERROR: user_add $@"
	exit 1
    fi

    sql_command="INSERT INTO user (login_id, password, enabled, new_account, campaign_creation_privilege) VALUES ( '$(quote "$1")', '$(quote "$2")', b'1', b'0', b'$(quote "$3")');"
    sql_run "$sql_command" || echo "ERROR: user_add $@"
}

# user_del <login_id> 
# Remove login_id from user table
user_del()
{
    sql_command="DELETE FROM user WHERE login_id='$(quote "$1")'";
    sql_run "$sql_command" || echo "ERROR: user_del $@"
}

# mapping from number to char string
number_to_string()
{
    array=(a b c d e f g h i j k l)
    num=$1
    limit=${#1}
    str=""
    i=0
    while [[ $i -lt $limit ]] 
    do
	str="${str}${array[${num:$i:1}]}"
	i=$(( $i + 1 ))
    done
    echo $str
}

# user_batch_add <start_id> <end_id> <privilege>
# add a batch of users with login "testuser.<start_id>" to "test.user.<end_id>"
# assuming that the password is "test.password"
user_batch_add()
{
    start_id=$1
    end_id=$2
    privilege="$3"

#    echo "user_batch_add $start_id $end_id $privilege"
    id=$start_id;
    while [[ $id -le $end_id ]]
    do
	user_name="testuser.$(number_to_string $id)"
	user_add "$user_name" "test.password" "$privilege"
	id=$(( $id + 1 ))
    done
}

# user_nohash_batch_add <start_id> <end_id> <privilege>
# add a batch of users with login "testuser.<start_id>" to "test.user.<end_id>"
# the password will be "test.password" with hash "$2a$04$r8zKliEptVkzoiQgD833Oe9z6hJwbvD6V4W/kPqcJZ5cwF.TpKE7u"
user_nohash_batch_add()
{
    start_id=$1
    end_id=$2
    privilege="$3"

    id=$start_id;
    while [[ $id -le $end_id ]]
    do
	user_name="testuser.$(number_to_string $id)"
#	echo "id = $id $user_name testuser.password $privilege"
	user_nohash_add "$user_name" '$2a$04$r8zKliEptVkzoiQgD833Oe9z6hJwbvD6V4W/kPqcJZ5cwF.TpKE7u' "$privilege"
	id=$(( $id + 1 ))
    done
}

# user_batch_del <start_id> <end_id>
# remove users "testuser.<start_id>" to "testuser.<end_id>" 
user_batch_del()
{
    start_id=$1
    end_id=$2

#    echo "user_batch_del $start_id $end_id"
    id=$start_id
    while [[ $id -le $end_id ]]
    do
	user_name="testuser.$(number_to_string $id)"
	user_del $user_name
	id=$(( $id + 1 ))
    done
}

# -------------- class ----------------
# class_add <urn> <name> <properties_json>
# add a class 
class_add()
{
#    sql_command="INSERT INTO class (urn, name, properties) VALUES ( '$(quote "$1")', '$(quote "$2")', '$(quote "$3")' );"
    sql_command="INSERT INTO class (urn, name) VALUES ( '$(quote "$1")', '$(quote "$2")');"
    sql_run "$sql_command" || echo "ERROR: class_add $@"
}

# class_del <urn>
# delete a class with specified urn
class_del()
{
    sql_command="DELETE FROM class WHERE urn='$(quote "$1")'";
    sql_run "$sql_command" || echo "ERROR: class_del $@"
}

# -------------- user_class ----------------
# user_class_add <user_login> <class_urn> <class_role:{SUPERVISOR|NORMAL}>
# add an entry to a user_class table
user_class_add()
{

    sql_run_batch <<EOF || echo "ERROR: user_class_del $@"
INSERT INTO user_class (user_id, class_id, user_class_role_id) 
VALUES (
  (SELECT user.id FROM user WHERE user.login_id='$(quote "$1")'), 
  (SELECT class.id FROM class WHERE class.urn='$(quote "$2")'), 
  (SELECT id FROM user_class_role WHERE user_class_role.role='$(quote "$3")')
);
EOF

}

# user_class_del <user_login> <class_urn>
# delete a user from a class (e.g. removing an entry from user_class_table)
user_class_del()
{
    sql_command="DELETE FROM user_class WHERE user_id IN (select user.id FROM user WHERE user.login_id='$(quote "$1")') AND class_id IN (select class.id FROM class WHERE class.urn='$(quote "$2")')"
    sql_run "$sql_command" || echo "ERROR: user_class_del $@"
}

# -------------- user_personal ----------------
# user_personal_add <login_id> <email_address> <info_json>
# attach a user_personal to a user by 
#  - adding a personal info into user_personal and 
#  - adding an entry to user_user_personal
user_personal_add()
{

    sql_run_batch <<EOF || echo "ERROR: user_personal_add $@"
BEGIN;
INSERT INTO user_personal (email_address, json_data) VALUES ( '$(quote "$2")', '$(quote "$3")' );
INSERT INTO user_user_personal (user_id, user_personal_id) VALUES ( (SELECT user.id FROM user WHERE user.login_id='$(quote "$1")'), LAST_INSERT_ID());
COMMIT;
EOF
}

# user_personal_del <user_login> <email_address>
# remove user_personal entries marked with email_address from a user by 
#  - removing user_personal entry (all entries with user's id and email_address)
#  - removing entries from user_user_personal
user_personal_del()
{
    sql_run_batch <<EOF || echo "ERROR: user_personal_del $@"
DELETE user_personal, user_user_personal 
FROM  user_user_personal INNER JOIN user_personal ON user_user_personal.user_personal_id=user_personal.id
WHERE user_user_personal.user_id in (SELECT id FROM user WHERE login_id='$(quote "$1")') AND
      user_personal.email_address='$(quote "$2")'
;
EOF
}

# -------------- campaign ----------------
# campaign_add <urn> <name> <description> <tags> <running_state> <privacy_state> <timestamp> <xml_location_on_server>
# Note: the xml file has to be stored localling on the database server. 
# add a campaign with a given properties to the table
campaign_add()
{
    sql_run_batch <<EOF || echo "ERROR: campaign_add $@"
INSERT INTO campaign (urn, name, description, running_state, privacy_state, creation_timestamp, xml) 
VALUES ('$(quote "$1")', '$(quote "$2")', '$(quote "$3")', '$(quote "$4")', '$(quote "$5")', '$(quote "$6")', load_file('$(quote "$7")'))
EOF
#load_file('path')
}

# campaign_del <urn>
# delete campaign with specified urn from the campaign table
campaign_del()
{
    sql_command="DELETE FROM campaign WHERE urn='$(quote "$1")'";
    sql_run "$sql_command" || echo "ERROR: campaign_del $@"
}

# ----------------- campaign_class -----------------
# campaign_class_add <campaign_urn> <class_urn>
# add a campaign and class relationship to the campaign_class table
campaign_class_add()
{
    sql_run_batch <<EOF || echo "ERROR: campaign_add $@"
INSERT INTO campaign_class (campaign_id, class_id)
VALUES ( (SELECT id FROM campaign WHERE campaign.urn='$(quote "$1")'), 
         (SELECT id FROM class WHERE class.urn='$(quote "$2")'))
EOF
}

# campaign_class_del <campaign_urn> <class_urn>
# delete a campaign class relationship from the campaign_class table
campaign_class_del()
{
    sql_run_batch <<EOF || echo "ERROR: user_role_campaign_del $@"
DELETE
FROM campaign_class 
WHERE campaign_id in (SELECT id FROM campaign WHERE urn='$(quote "$1")') AND
      class_id in (SELECT id FROM class WHERE urn='$(quote "$2")')
EOF
}

# -------------- campaign_class_default_role ----------------
# campaign_class_default_role_add <campaign_urn> <class_urn> <user_class_role>
campaign_class_default_role_add()
{
    local r1
    local r2
    case "$3" in 
	"privileged")
	    r1="supervisor"
	    r2="participant"
	    ;;
	"restricted")
	    r1="analyst"
	    r2="participant"
	    ;;
	*)
	    "ERROR: campaign_class_default_role_add $@"
    esac

    sql_run_batch <<EOF || echo "ERROR: campaign_class_default_role_add $@"
BEGIN;
INSERT INTO campaign_class_default_role (campaign_class_id, user_class_role_id, user_role_id)
VALUES ( 
  (SELECT id FROM campaign_class WHERE 
      campaign_id in (SELECT id from campaign where campaign.urn='$(quote "$1")') AND
      class_id in (SELECT id from class where class.urn='$(quote "$2")')
   ),
  (SELECT id FROM user_class_role WHERE user_class_role.role='$(quote "$3")'),
  (SELECT id FROM user_role WHERE user_role.role='$r1')
  );

INSERT INTO campaign_class_default_role (campaign_class_id, user_class_role_id, user_role_id)
VALUES ( 
  (SELECT id FROM campaign_class WHERE 
      campaign_id in (SELECT id from campaign where campaign.urn='$(quote "$1")') AND
      class_id in (SELECT id from class where class.urn='$(quote "$2")')
   ),
  (SELECT id FROM user_class_role WHERE user_class_role.role='$(quote "$3")'),
  (SELECT id FROM user_role WHERE user_role.role='$r2')
  );

COMMIT;
EOF
}

# campaign_class_default_role_add <campaign_urn> <class_urn> <user_class_role>
campaign_class_default_role_del()
{
    sql_run_batch <<EOF || echo "ERROR: campaign_class_default_role_del $@"
DELETE 
FROM  campaign_class_default_role
WHERE campaign_class_id in (SELECT id FROM campaign_class WHERE 
        campaign_id in (SELECT id from campaign where campaign.urn='$(quote "$1")') AND
        class_id in (SELECT id from class where class.urn='$(quote "$2")')
        ) AND
      user_class_role_id in (SELECT id FROM user_class_role WHERE user_class_role.role='$(quote "$3")')
EOF
}

# -------------- user_role_campaign ----------------
# user_role_campaign_add <user_login> <campaign_urn> <role>
# Note: we should change the sql script to make sure that 
# (user_id, campaign_id and user_role_id) is unique
user_role_campaign_add()
{
    sql_run_batch <<EOF || echo "ERROR: user_role_campaign_add $@"
INSERT INTO user_role_campaign (user_id, campaign_id, user_role_id)
VALUES ( (SELECT id FROM user WHERE user.login_id='$(quote "$1")'), 
         (SELECT id FROM campaign WHERE campaign.urn='$(quote "$2")'), 
         (SELECT id FROM user_role WHERE user_role.role='$(quote "$3")') )
EOF
}

# user_role_campaign_del <user_login> <campaign_urn> <role>
# delete a user_login with a specific role from a campaign_urn 
user_role_campaign_del()
{
    sql_run_batch <<EOF || echo "ERROR: user_role_campaign_del $@"
DELETE 
FROM  user_role_campaign
WHERE user_role_campaign.user_id in (SELECT id FROM user WHERE login_id='$(quote "$1")') AND
      user_role_campaign.campaign_id in (SELECT id FROM campaign WHERE campaign.urn='$(quote $2)') AND
      user_role_campaign.user_role_id in (SELECT id FROM user_role WHERE user_role.role='$(quote $3)')
EOF
:
}

# --- utilities to generate combination of user roles ---

roles=("supervisor" "author" "participant" "analyst")
initials=(s u p a)
index=(0 1 2 3)
supervisor_index=0

# combo_k <# of items chosen> <arrays of items separated by spaces>
# generate all sets of k combinatoric arrangement out of an array
# e.g. combo_k 3 a b c d e  will generate all possible options of 
# 3 elements out of list ( a b c d e )
n_choose_k() 
{
    local k="$1"
    shift 1
    n=$#

    if [[ $k -ge 0 ]] && [[ $k -le $n ]]
    then 
	if [[ $k -eq 0 ]]
	then
	    echo ""
	    return;
	fi
	local head=$1
	shift

	# all combos excluding the first element
	n_choose_k $k $@ | while read line
	do 
	    echo "$line"
	done

	# all combos including the first element
	n_choose_k $(( $k - 1 )) $@ | while read line
	do
	    echo "$head.$line"
	done
    fi
}

# get_role_combo <min> <max> 
# generate all k combinatoric options where <min> <= k <= max
# from an array of roles (defined above)
# min=1 and max=4 will generate all possible roles
gen_role_combo()
{
    local min="$1"
    local max="$2" 
    local str=""
    shift 2

    if [[ $min -gt 0 ]] && [[ $k -le $# ]]
    then
	local k=$min
	while [[ $k -le $max ]]
	do
	    n_choose_k $k ${index[*]} | {
		while read line
		do 
		    str="$str $line"
		done
		printf '%s' "$str"
	    }
	    k=$(( $k + 1 )) 
	done
    fi
}

# gen_user_user_class_roles <login_prefix> <campaign_urn> <class_urn> 
# Generate all combinations of roles for a user and perform the following functions:
# - add user. If want to skip adding user, define skip_user=true before the function.
# - add user_class. If want to skip adding user_class, define skip_user_class=true before the function.
# - add user_role_campaign. If want to skip adding roles, define skip_role=true before the function.
# Ex: skip_user=true skip_user_class=true gen_user_user_class_roles ... 
gen_user_user_class_roles()
{
    local prefix="$1"
    local campaign_urn="$2"
    local class_urn="$3"

    id_list=( $( gen_role_combo 1 4 ) )
    
    for x in ${id_list[*]}
    do
	index_list=( $(echo "$x" | sed -e 's/\./ /g') )
	suffix=""
	priv="restricted"
	# get user_suffix
	for y in ${index_list[*]} 
	do 
	    suffix="$suffix${initials[$y]}"
	    # if the supervisor role, set pri to privileged
	    if [[ $y -eq $supervisor_index ]] 
	    then 
		priv="privileged"
	    fi
	done 
	login="$prefix.$suffix"

	#-n if non-zero, -z check if zero
	#add users if skip_user is not specified
	if [[ -z "${skip_user}" ]]
	then
	    user_nohash_add $login '$2a$04$r8zKliEptVkzoiQgD833Oe9z6hJwbvD6V4W/kPqcJZ5cwF.TpKE7u' 1
	    #echo user_nohash_add $login '$2a$04$r8zKliEptVkzoiQgD833Oe9z6hJwbvD6V4W/kPqcJZ5cwF.TpKE7u' 1
	fi 
	
	# add user_class if skip_user_class is not specified
	if [[ -z "${skip_user_class}" ]]
	then
	user_class_add $login $class_urn $priv
	#echo "user_class_add $login $class_urn $priv"
	fi

	# add user roles if skip_role is not specified
	if [[ -z "${skip_role}" ]]
	then
	    for y in ${index_list[*]}
	    do
		#add user_role_campaign
		user_role_campaign_add $login $campaign_urn ${roles[$y]}
		#echo user_role_campaign_add $login $campaign_urn ${roles[$y]}
	    done
	fi
	
    done
}

# --- utilities to delete all users, all classes, all campaigns 
#add_campaign_class_and_default_class_role <campaign_urn> <class_urn>
gen_campaign_class_and_default_class_role()
{
    campaign_class_add "$1" "$2"
    campaign_class_default_role_add "$1" "$2" privileged
    campaign_class_default_role_add "$1" "$2" restricted
}
#del_campaign_class_and_default_class_role <campaign_urn> <class_urn>
delete_campaign_class_and_default_class_role()
{
    campaign_class_del "$1" "$2"
    campaign_class_default_role_del "$1" "$2" privileged
    campaign_class_default_role_del "$1" "$2" restricted
}

# --- utilities to delete all users, all classes, all campaigns 
delete_all_users()
{
    sql_run_batch <<EOF || echo "ERROR: delete_all_users $@"
DELETE FROM user
EOF
}

delete_all_classes()
{
    sql_run_batch <<EOF || echo "ERROR: delete_all_classes $@"
DELETE FROM class
EOF
}

delete_all_campaigns()
{
    sql_run_batch <<EOF || echo "ERROR: delete_all_classes $@"
DELETE FROM campaign
EOF
}

delete_all_users_classes_campaigns()
{
    delete_all_users
    delete_all_classes
    delete_all_campaigns
}

########################################################################################

# gen_user_user_class_roles u.cs101 "urn:class:ca:lausd:Addams_HS:CS101:Fall:2011" "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement" 

# delete_all_users_classes_campaigns

