## Fedora 18 spec file

#install packaging tools
sudo yum update -y && sudo yum install -y @development-tools fedora-packager

#create sources archive
rm -f ohmage-2.14.tar.gz 
cp -Rf ../ohmage-server /tmp/ohmage-2.14
tar -pczf ohmage-2.14.tar.gz -C /tmp ohmage-2.14
rm -Rf /tmp/ohmage-2.14

#copy to your home directory
cp -f ohmage.spec ~/rpmbuild/SPECS
cp -f ohmage-server-2.14.tar.gz ~/rpmbuild/SOURCES

#build
rpmbuild -ba ~/rpmbuild/SPECS/ohmage.spec