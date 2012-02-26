#!/bin/sh

. ./addDelUtil.sh

# -------------------------------------------------------
# 1 class 1 campaign all roles
# school: addams
# class: cs101
# campaign: advertisement
# users: 15 users 
one_class_one_campaign_allroles()
{
    class_add "urn:class:ca:lausd:Addams_HS:CS101:Fall:2011" Addams_HS_CS101_Fall_2011 "state:CA, district:LAUSD, school:Addams High School, class:CS101, term:Fall, year:2011"
    campaign_add "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement" "CS101_Fall_2011_Media" "objective: observe, collect and analyze advertisement pattern in the community" "running" "shared" "2011-04-19 23:16:57" "/opt/aw/campaigns/cs101_advertisement.xml"
    gen_campaign_class_and_default_class_role "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement" "urn:class:ca:lausd:Addams_HS:CS101:Fall:2011"

    # generate 15 users covering all roles combination
    gen_user_user_class_roles u.addams "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement" "urn:class:ca:lausd:Addams_HS:CS101:Fall:2011" 

}

# -------------------------------------------------------
# 1 class 2 campaign all roles
# school: BoyleHeights
# class: cs102
# campaign: sleep, snack
# users: 15 users having the same roles to both campaigns
one_class_two_campaigns_allroles()
{
    class_add "urn:class:ca:lausd:BoyleHeights_HS:CS102:Spring:2011" BH_HS_CS102_Spring_2011 "state:CA, district:LAUSD, school:Boyle Height High School, class:CS102, term:Spring, year:2011"

    campaign_add "urn:campaign:ca:lausd:BoyleHeights_HS:CS102:Spring:2011:Sleep" "CS102_Spring_2011_Media" "objective: observe, collect and analyze sleep pattern" "running" "shared" "2011-04-19 23:16:57" "/opt/aw/campaigns/cs102_sleep.xml"
    campaign_add "urn:campaign:ca:lausd:BoyleHeights_HS:CS102:Spring:2011:Snack" "CS102_Spring_2011_Media" "objective: observe, collect and analyze snack habbit" "running" "shared" "2011-04-19 23:16:57" "/opt/aw/campaigns/cs102_snack.xml"

    gen_campaign_class_and_default_class_role "urn:campaign:ca:lausd:BoyleHeights_HS:CS102:Spring:2011:Sleep" "urn:class:ca:lausd:BoyleHeights_HS:CS102:Spring:2011"
    gen_campaign_class_and_default_class_role "urn:campaign:ca:lausd:BoyleHeights_HS:CS102:Spring:2011:Snack" "urn:class:ca:lausd:BoyleHeights_HS:CS102:Spring:2011"

    # generate 15 users covering all roles combination
    # add user, user_class, and roles for the first campaign
    gen_user_user_class_roles user.bh "urn:campaign:ca:lausd:BoyleHeights_HS:CS102:Spring:2011:Sleep" "urn:class:ca:lausd:BoyleHeights_HS:CS102:Spring:2011" 
    # skip adding user and user_class for the second campaign
    skip_user=true skip_user_class=true gen_user_user_class_roles user.bh "urn:campaign:ca:lausd:BoyleHeights_HS:CS102:Spring:2011:Snack" "urn:class:ca:lausd:BoyleHeights_HS:CS102:Spring:2011" 
    
}

# -------------------------------------------------------
# 1 class 2 campaign all roles
# school: BoyleHeights
# class: cs102
# campaign: sleep, snack
# users: 30 suers---15 users with access to sleep, 15 users with access to snack
one_class_two_campaigns_allroles_2()
{

    class_add "urn:class:ca:lausd:BoyleHeights_HS:CS102:Spring:2011" BH_HS_CS102_Spring_2011 "state:CA, district:LAUSD, school:Boyle Height High School, class:CS102, term:Spring, year:2011"

    campaign_add "urn:campaign:ca:lausd:BoyleHeights_HS:CS102:Spring:2011:Sleep" "CS102_Spring_2011_Media" "objective: observe, collect and analyze sleep pattern" "running" "shared" "2011-04-19 23:16:57" "/opt/aw/campaigns/cs102_sleep.xml"
    campaign_add "urn:campaign:ca:lausd:BoyleHeights_HS:CS102:Spring:2011:Snack" "CS102_Spring_2011_Media" "objective: observe, collect and analyze snack habbit" "running" "shared" "2011-04-19 23:16:57" "/opt/aw/campaigns/cs102_snack.xml"

    gen_campaign_class_and_default_class_role "urn:campaign:ca:lausd:BoyleHeights_HS:CS102:Spring:2011:Sleep" "urn:class:ca:lausd:BoyleHeights_HS:CS102:Spring:2011"
    gen_campaign_class_and_default_class_role "urn:campaign:ca:lausd:BoyleHeights_HS:CS102:Spring:2011:Snack" "urn:class:ca:lausd:BoyleHeights_HS:CS102:Spring:2011"

    # generate 15 users covering all roles combination
    # add user, user_class, and roles for the first campaign
    gen_user_user_class_roles u.sleep "urn:campaign:ca:lausd:BoyleHeights_HS:CS102:Spring:2011:Sleep" "urn:class:ca:lausd:BoyleHeights_HS:CS102:Spring:2011"
    # add user, user_class, and roles for the second campaign
    gen_user_user_class_roles u.snack "urn:campaign:ca:lausd:BoyleHeights_HS:CS102:Spring:2011:Snack" "urn:class:ca:lausd:BoyleHeights_HS:CS102:Spring:2011" 
    
}

# -------------------------------------------------------
# 2 classes, one campaigns, same students on both classes
two_class_one_campaigns_allroles() {

    # add 2 classes
    class_add "urn:class:ca:lausd:Addams_HS:CS101:Fall:2011" "Addams_HS_CS101_Fall_2011" "state:CA, district:LAUSD, school:Addams High School, class:CS101, term:Fall, year:2011"
    class_add "urn:class:ca:lausd:BoyleHeights_HS:CS102:Spring:2011" "BH_HS_CS102_Spring_2011" "state:CA, district:LAUSD, school:Boyle Height High School, class:CS102, term:Spring, year:2011"

    # add 1 campaign
    campaign_add "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement" "CS101_Fall_2011_Media" "objective: observe, collect and analyze advertisement pattern in the community" "running" "shared" "2011-04-19 23:16:57" "/opt/aw/campaigns/cs101_advertisement.xml"

    # add campaign to both classes
    gen_campaign_class_and_default_class_role "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement" "urn:class:ca:lausd:Addams_HS:CS101:Fall:2011"
    gen_campaign_class_and_default_class_role "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement" "urn:class:ca:lausd:BoyleHeights_HS:CS102:Spring:2011"

    # add users, add user_class and user_roles
    gen_user_user_class_roles user.adv "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement" "urn:class:ca:lausd:Addams_HS:CS101:Fall:2011" 
    # skip adding users, add user_class and user_roles
    skip_user=true skip_role=true gen_user_user_class_roles user.adv "urn:campaign:ca:lausd:Addams_HS:CS101:Fall:2011:Advertisement" "urn:class:ca:lausd:BoyleHeights_HS:CS102:Spring:2011" 
}

# ---------------------------------------------------

# to delete all users, classes, campaigns which will subsequently 
# remove all entries in user_class, campaign_class, user_role_campaigns
delete_all_users_classes_campaigns 

# choose one of the scenarios: 
#one_class_one_campaign_allroles
#one_class_two_campaigns_allroles
#one_class_two_campaigns_allroles_2
two_class_one_campaigns_allroles

