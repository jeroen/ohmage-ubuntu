#!/bin/sh

. ./addDelUtil.sh

# --- add or delete users

# 2 options for adding user : user_add or user_nohash_add
# note the hash for "test.password" is '$2a$04$r8zKliEptVkzoiQgD833Oe9z6hJwbvD6V4W/kPqcJZ5cwF.TpKE7u'
#user_add <login_id> <passwd> <campaign_creation_privilege=[0|1]>
#user_add testuser.baa test.password 1
#user_nohash_add <login_id> <passwd hash> <campaign_creation_privilege=[0|1]>
#user_add testuser.baa '$2a$04$r8zKliEptVkzoiQgD833Oe9z6hJwbvD6V4W/kPqcJZ5cwF.TpKE7u' 1

user_nohash_add testuser.aa '$2a$04$r8zKliEptVkzoiQgD833Oe9z6hJwbvD6V4W/kPqcJZ5cwF.TpKE7u' 1
user_nohash_add testuser.ab '$2a$04$r8zKliEptVkzoiQgD833Oe9z6hJwbvD6V4W/kPqcJZ5cwF.TpKE7u' 1
user_nohash_add testuser.ac '$2a$04$r8zKliEptVkzoiQgD833Oe9z6hJwbvD6V4W/kPqcJZ5cwF.TpKE7u' 1
user_nohash_add testuser.ad '$2a$04$r8zKliEptVkzoiQgD833Oe9z6hJwbvD6V4W/kPqcJZ5cwF.TpKE7u' 1
user_nohash_add testuser.ae '$2a$04$r8zKliEptVkzoiQgD833Oe9z6hJwbvD6V4W/kPqcJZ5cwF.TpKE7u' 0
user_nohash_add testuser.ba '$2a$04$r8zKliEptVkzoiQgD833Oe9z6hJwbvD6V4W/kPqcJZ5cwF.TpKE7u' 1
user_nohash_add testuser.bb '$2a$04$r8zKliEptVkzoiQgD833Oe9z6hJwbvD6V4W/kPqcJZ5cwF.TpKE7u' 1
user_nohash_add testuser.bc '$2a$04$r8zKliEptVkzoiQgD833Oe9z6hJwbvD6V4W/kPqcJZ5cwF.TpKE7u' 1
user_nohash_add testuser.bd '$2a$04$r8zKliEptVkzoiQgD833Oe9z6hJwbvD6V4W/kPqcJZ5cwF.TpKE7u' 1
user_nohash_add testuser.be '$2a$04$r8zKliEptVkzoiQgD833Oe9z6hJwbvD6V4W/kPqcJZ5cwF.TpKE7u' 0

# add a batch of user from id = 100 (testuser.baa) to id = 102 (testuser.bac)
#user_batch_add 100 102 0
#user_batch_del 100 102

# --- add or delete class

class_add urn:class:ca:lausd:Addams_HS:CS101:Fall:2011 Addams_HS_CS101_Fall_2011 '{"state":"CA", "district":"LAUSD", "school":"Addams High School", "class":"CS101", "term":"Fall", "year":2011}'
class_add urn:class:ca:lausd:Boyle_Heights_HS:CS102:Spring:2011 BH_HS_CS102_Spring_2011 '{"state":"CA", "district":"LAUSD", "school":"Boyle Height High School", "class":"CS102", "term":"Spring", "year":2011}'
class_add urn:class:ca:lausd:Carson_HS:CS103:Fall:2011 Carson_HS_CS103_Fall_2011 '{"state":"CA", "district":"LAUSD", "school":"Carson High School", "class":"CS103", "term":"Fall", "year":2011}'
class_add urn:class:ca:lausd:Crenshaw_HS:CS104:Spring:2011 Crenshaw_HS_CS104_Spring_2011 '{"state":"CA", "district":"LAUSD", "school":"Crenshaw High School", "class":"CS104", "term":"Spring", "year":2011}'
class_add urn:class:ca:lausd:Gardena_HS:CS105:Fall:2011 Gardena_HS_CS105_Fall_2011 '{"state":"CA", "district":"LAUSD", "school":"Gardena High School", "class":"CS105", "term":"Fall", "year":2011}'

#class_del urn:class:ca:lausd:Addams_HS:CS101:Fall:2011

# --- add or delete user_class
user_class_add testuser.aa  urn:class:ca:lausd:Addams_HS:CS101:Fall:2011 	  SUPERVISOR
user_class_add testuser.ab  urn:class:ca:lausd:Addams_HS:CS101:Fall:2011 	  NORMAL
user_class_add testuser.ac  urn:class:ca:lausd:Addams_HS:CS101:Fall:2011 	  NORMAL
user_class_add testuser.ad  urn:class:ca:lausd:Addams_HS:CS101:Fall:2011 	  NORMAL
user_class_add testuser.ae  urn:class:ca:lausd:Addams_HS:CS101:Fall:2011 	  NORMAL
user_class_add testuser.ba  urn:class:ca:lausd:Boyle_Heights_HS:CS102:Spring:2011 SUPERVISOR
user_class_add testuser.bb  urn:class:ca:lausd:Boyle_Heights_HS:CS102:Spring:2011 NORMAL
user_class_add testuser.bc  urn:class:ca:lausd:Boyle_Heights_HS:CS102:Spring:2011 NORMAL
user_class_add testuser.bd  urn:class:ca:lausd:Boyle_Heights_HS:CS102:Spring:2011 NORMAL
user_class_add testuser.be  urn:class:ca:lausd:Boyle_Heights_HS:CS102:Spring:2011 NORMAL

# --- add or delete user personal 
#user_personal_add testuser.aa testuser.aa@test.org '{"firstname":"testuser.aa"}' 
#user_personal_add testuser.ab testuser.ab@test.org '{"firstname":"testuser.ab"}'
#user_personal_add testuser.ac testuser.ac@test.org '{"firstname":"testuser.ac"}'
#user_personal_add testuser.ad testuser.ad@test.org '{"firstname":"testuser.ad"}'
#user_personal_add testuser.ae testuser.ae@test.org '{"firstname":"testuser.ae"}'
#user_personal_add testuser.ba testuser.ba@test.org '{"firstname":"testuser.ba"}'
#user_personal_add testuser.bb testuser.bb@test.org '{"firstname":"testuser.bb"}'
#user_personal_add testuser.bc testuser.bc@test.org '{"firstname":"testuser.bc"}'
#user_personal_add testuser.bd testuser.bd@test.org '{"firstname":"testuser.bd"}'
#user_personal_add testuser.be testuser.be@test.org '{"firstname":"testuser.be"}'

# --- add or delete campaign
campaign_add "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement" "CS101_Fall_2011_Media" "objective: observe, collect and analyze advertisement pattern in the community" "running" "shared" "2011-04-19 23:16:57" "/opt/aw/campaigns/advertisement.xml"
campaign_add "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Sleep" "CS101_Fall_2011_Media" "objective: observe, collect and analyze sleep pattern" "running" "shared" "2011-04-19 23:16:57" "/opt/aw/campaigns/sleep.xml"
campaign_add "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Snack" "CS101_Fall_2011_Media" "objective: observe, collect and analyze snack habbit" "running" "shared" "2011-04-19 23:16:57" "/opt/aw/campaigns/snack.xml"

#campaign_del "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement"
#campaign_del "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Sleep"
#campaign_del "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Snack"

# --- add or delete campaign_class
campaign_class_add "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement" urn:class:ca:lausd:Addams_HS:CS101:Fall:2011
campaign_class_add "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Sleep" urn:class:ca:lausd:Addams_HS:CS101:Fall:2011
campaign_class_add "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Snack" urn:class:ca:lausd:Addams_HS:CS101:Fall:2011

#campaign_class_del "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement" urn:class:ca:lausd:Addams_HS:CS101:Fall:2011

# --- add or delete user_role_campaign
user_role_campaign_add testuser.aa urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement supervisor
user_role_campaign_add testuser.ab urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement author
user_role_campaign_add testuser.ab urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement participant
user_role_campaign_add testuser.ac urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement participant
user_role_campaign_add testuser.ad urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement analyst

#user_role_campaign_del testuser.aa urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement supervisor
#user_role_campaign_del testuser.ab urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement author
#user_role_campaign_del testuser.ab urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement participant
#user_role_campaign_del testuser.ac urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement participant
#user_role_campaign_del testuser.ad urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement analyst

