rm -Rf ~/Desktop/ohmage-ubuntu
cp -Rf ~/Dropbox/packages/public/ohmage-ubuntu ~/Desktop
cd ~/Desktop/ohmage-ubuntu
rm -Rf .git
rm -Rf manual ohmage-viz packages rpm
rm Makefile

#edit control file
sed -i 's/, r-base-dev (>= 2.15.1)/ /g' debian/control
sed -i 's/, opencpu-dev/ /g' debian/control
head debian/control -n16 > debian/control2
rm debian/control
mv debian/control2 debian/control
debuild -S

