#because .libPaths() only appends paths, doesn't replace anything.
setLibPaths <- function(newlibs){
	checkfordir <- function(path){
		return(isTRUE(file.info(path)$isdir));
	}	
	newlibs <- newlibs[sapply(newlibs, checkfordir)]
	assign(".lib.loc", newlibs, envir=environment(.libPaths));
}

#removes all lib paths except for base.
setLibPaths("/usr/lib/R/library")

#install in expected dir
destdir <- ("/mnt/export/opencpu-admin-library/")
sourcedir <- paste("file://", getwd(), "/packages/", sep="")

#just in case
dir.create(destdir, showWarnings=FALSE)

#install
install.packages(c("XML", "Mobilize"), type="source", lib=destdir, contriburl=sourcedir)

