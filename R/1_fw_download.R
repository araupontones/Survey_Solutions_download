## Downloads data from muvapob.com and stores its raw version in the C drive
source("5.R/fieldwork/fw_set_up.R")
source("5.R/fieldwork/0_fw_functions.R")





##' get details of all questionnaires (ID, variable name, etc.)

Questionnaires_details = SS_getQnsDetails(sserver = sserver, sspassword = "Seguridad1", ssuser = "araupontones")





#unlink(file.path(dir_ss_downloads, "tracking_3"), recursive = T)
unlink(file.path(dir_ss_downloads, "tracking_5"), recursive = T)
unlink(file.path(dir_ss_downloads, "agregado_2"), recursive = T)
unlink(file.path(dir_ss_downloads, "agregado_3"), recursive = T)
unlink(file.path(dir_ss_downloads, "agregado_4"), recursive = T)
unlink(file.path(dir_ss_downloads, "individual_2"), recursive = T)
unlink(file.path(dir_ss_downloads, "individual_3"), recursive = T)
unlink(file.path(dir_ss_downloads, "individual_4"), recursive = T)




##Export individual versions 5

ss_export(sserver = sserver,
          questionnaires = Questionnaires_details,
          qn_variable = "individual",
          qn_version = c(5),
          ssuser = ssuser,
          sspassword = sspassword,
          temporary_dir = temporDir,
          exdir = dir_ss_downloads)

#' Export agregado vesions 2 and 3
ss_export(sserver = sserver,
          questionnaires = Questionnaires_details,
          qn_variable = "agregado",
          qn_version = c(5),
          ssuser = ssuser,
          sspassword = sspassword,
          temporary_dir = temporDir,
          exdir = dir_ss_downloads)





##Append versions
ss_append(downloadDir = dir_ss_downloads, rawDir = dir_raw)
