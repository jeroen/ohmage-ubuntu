all:
	#move existing packages to a tmp location
	mkdir -p /tmp/tmp-admin-lib
	mkdir -p /mnt/export/opencpu-admin-library
	mv /mnt/export/opencpu-admin-library/* /tmp/tmp-admin-lib/
	
	#build the packages to the opencpu-admin-library
	Rscript ./packages/buildpackages.R
	mv /mnt/export/opencpu-admin-library/* ./packages/build/
	
	#move existing libs back to where they were.
	mv /tmp/tmp-admin-lib/* /mnt/export/opencpu-admin-library/
	rm -Rf /tmp/tmp-admin-lib