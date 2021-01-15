## Downloads data from pulpodata.solutions and stores its raw version in the define download and raw folders

#define path where the R project is located
if(Sys.getenv("USERNAME")=="andre"){
  dir_project = "C:/repositaries/Survey_Solutions_download"
}

#define your paths in the set_up.R
  source(file.path(dir_project,"set_up.R"))
  source(file.path(dir_project,"functions.R"))





##' get details of all questionnaires (ID, variable name, etc.)

Questionnaires_details = SS_getQnsDetails(sserver = sserver, sspassword = sspassword, ssuser = ssuser)





#unlink(file.path(dir_ss_downloads, "tracking_3"), recursive = T)
#unlink(file.path(dir_ss_downloads, "tracking_5"), recursive = T)


##Export principal versions 2

ss_export2(sserver = sserver,
          questionnaires = Questionnaires_details,
          ex_format = "STATA",
          qn_variable = "elp_principal",
          qn_version = c(2),
          ssuser = ssuser,
          sspassword = sspassword,
          temporary_dir = temporDir,
          exdir = dir_ss_downloads,
          interview_status = "All"
          )

##Export principal versions 2

ss_export2(sserver = sserver,
           questionnaires = Questionnaires_details,
           ex_format = "STATA",
           qn_variable = "elp_teacher",
           qn_version = c(2),
           ssuser = ssuser,
           sspassword = sspassword,
           temporary_dir = temporDir,
           exdir = dir_ss_downloads,
           interview_status = "All"
)


# export pupil versions 2
ss_export2(sserver = sserver,
           questionnaires = Questionnaires_details,
           ex_format = "STATA",
           qn_variable = "elp_pupil",
           qn_version = c(2),
           ssuser = ssuser,
           sspassword = sspassword,
           temporary_dir = temporDir,
           exdir = dir_ss_downloads,
           interview_status = "All"
)






##Append versions
ss_append(downloadDir = dir_ss_downloads, rawDir = dir_raw)
