*ANDRES ARAU: October 2019
*andres.arau@outlook.com

/*
What you do:

2. Set parameters in the R scripts set_up.R and download.R
3. Add your file path to the R project

What the dofile does:

1. downloads all the questionnaires you especified in download.R and stores in your download folder
2. Unzip all the versions and appends them in your raw folder

ENJOY!
*/

clear all
set more off

if c(username) == "andre" {
	*global dofiles "C:\Users\andre\Dropbox\10 Data system\01.dofiles"
	global rfiles "C:\repositaries\Survey_Solutions_download"
	local version R-4.0.1
}
*
if c(username) == "Andres" {
	global dofiles "C:\Users\Andres\Dropbox\00 PROJECTS\ACTIVE\09 A3720 - ELP Liberia Phase 2\A3720 - ELP Liberia\10b. Survey_Phase II\10 Data system\01.dofiles"
	local version R-3.6.0
	}
*
if c(username) == "Tayo" {
	global myfolder "C:\Users\Tayo\Dropbox (OPML)\09 A3720 - ELP Liberia Phase 2\A3720 - ELP Liberia\10b. Survey_Phase II\10 Data system\01.dofiles"
	local version R-3.6.1
	}
*

*do "$dofiles/globals.do"
*display "$C"

***-----------------------------------------------------------------------------
***	DOWNLOAD THE DATA
***----------------------------------------------------------------------------*/
*
	display "$rfiles"
	shell "C:/Program Files/R/`version'/bin/R.exe" --vanilla < "$rfiles/download.R"


