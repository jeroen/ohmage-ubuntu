#!/bin/bash
#
# dependencies
# sudo apt-get install git ant openjdk-6-jdk openjdk-6-jre unzip git


### create dir that will contain .war files
mkdir -p warfiles


### Compile server:
git clone git://github.com/cens/ohmageServer.git -b ohmage-2.14 
cd ohmageServer
sed -i 's/\/opt\/ohmage\/logs\/ohmage.log/\/var\/log\/ohmage\/ohmage.log/g' web/WEB-INF/classes/log4j.properties
ant clean dist-no_ssl
mv ./dist/*.war ../warfiles/
cd ..
rm -Rf ohmageServer


### Compile front-end
git clone git://github.com/cens/ohmageFrontEnd.git -b master
cd ohmageFrontEnd
ant clean build buildwar-nossl
cp ./*.war ../warfiles/
cd ..
rm -Rf ohmageFrontEnd

