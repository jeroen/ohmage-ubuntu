all:
	## build the packages to the opencpu-admin-library
	## we do this because Rcpp hardcodes the path to the .so file
	Rscript ./packages/buildpackages.R
	mv /mnt/export/opencpu-admin-library/* ./packages/build/
