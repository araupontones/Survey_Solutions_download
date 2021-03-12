#Set up for fieldwork data management
#locale("pt",decimal_mark = ",")
#Sys.setlocale("LC_ALL","Portuguese_Brazil.1252")


library(pacman)

#Load packages
p_load(lubridate, tidyverse, httr, rio, glue, RCurl,sf, leaflet, leaflet.extras)



#' TOKENS ----------------------------------------------------------------------
#' 
#' Survey Solutions



#PATHS ------------------------------------------------------------------------




temporDir = tempdir()

