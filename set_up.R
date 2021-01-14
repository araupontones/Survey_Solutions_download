#Set up for fieldwork data management
#locale("pt",decimal_mark = ",")
#Sys.setlocale("LC_ALL","Portuguese_Brazil.1252")


library(pacman)

#Load packages
p_load(lubridate, tidyverse, httr, rio, glue, RCurl,sf, leaflet, leaflet.extras)



#' TOKENS ----------------------------------------------------------------------
#' 
#' Survey Solutions

ssuser = "araupontones"
sspassword = "Seguridad1"
sserver = "http://www.pulpodata.solutions"


#PATHS ------------------------------------------------------------------------

if(Sys.getenv("USERNAME")=="andre"){
  
  dropbox = "C:/Users/andre/Dropbox/SS"
}

dir_ss_downloads = file.path(dropbox, "downloads")
dir_raw = file.path(dropbox, "raw")


temporDir = tempdir()

