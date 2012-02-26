#!/bin/bash
#
# dependencies
# sudo apt-get install git ant openjdk-6-jdk openjdk-6-jre unzip

# Download server source
rm -Rf awsserver cens-ohmageServer*
wget https://github.com/cens/ohmageServer/zipball/master -O ohserver.zip
unzip ohserver.zip
rm ohserver.zip
mv cens-ohmageServer* ohserver

# Download frontend source
rm -Rf ohfrontend cens-ohmageFrontEnd*
wget https://github.com/cens/ohmageFrontEnd/zipball/master -O ohfrontend.zip
unzip ohfrontend.zip
rm ohfrontend.zip
mv cens-ohmageFrontEnd* ohfrontend

#create dir that will contain .war files
mkdir -p warfiles

#compile server code
cd ohserver
ant clean dist
mv ./dist/*.war ../warfiles/
ant clean dist-no_ssl
mv ./dist/*.war ../warfiles/
cd ..
rm -Rf ohserver

#compile frontend
cd ohfrontend
ant clean build buildwar
ant clean build buildwar-nossl
cp ./*.war ../warfiles/
cd ..
rm -Rf ohfrontend

