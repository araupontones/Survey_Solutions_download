## Downloads data from muvapob.com and stores its raw version in the C drive
source("set_up.R")
source("functions.R")





##' get details of all questionnaires (ID, variable name, etc.)

Questionnaires_details = SS_getQnsDetails(sserver = sserver, sspassword = "Seguridad1", ssuser = "araupontones")





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
