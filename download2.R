
if(Sys.getenv("USERNAME")=="andre"){
  dir_project = "C:/repositaries/Survey_Solutions_download"
  dir_functions = file.path(dir_project,"R") #folder where the R scripts are located
  dropbox = "C:/Users/andre/Dropbox/SS"
    dir_ss_downloads = file.path(dropbox, "downloads")
    dir_raw = file.path(dropbox, "raw")
}




#load scripts --------------------------------------------------------------
source(file.path(dir_project,"set_up.R"))
scripts = list.files(dir_functions, recursive = T)

  message("Loading the following functions")
for(script in scripts){
  
  print(script)
  source(file.path(dir_functions, script))
}



# Define credentials ----------------------------------------------------------

 ss_credentials(ssuser = "araupontones",
                sspassword = "Seguridad1",
                sserver = "http://www.pulpodata.solutions",
                dir_ss_downloads = dir_ss_downloads,
                dir_ss_raw = dir_raw)

# get details of all the questionnaires imported in the server ----------------

  SS_getQnsDetails() #this functions saves ss_questionnaires in  the global environment

  
# Get questionnaire ID
  # quid = ss_get_qnID(qn_variable = "elp_pupil",
  #                    qn_version = 3)

  
# generate file  
    
    # post_to_server = ss_generate(quid = ss_get_qnID(
    # qn_variable = "elp_pupil",
    # qn_version = 3),
    # ex_format = "STATA")
    # 
    # post_to_server$response$status_code
    # post_to_server$details$JobId # to get the job ID
    

# export file 
 
    
  ss_export_file(qn_variable= "elp_classroom",
                 qn_version =  ss_questionnaires$Version[ss_questionnaires$Variable == "elp_classroom"],
                 ex_format = "STATA",
                 interview_status = "All"
                 
  )
  
    ss_export_file(qn_variable= "elp_pupil",
                              qn_version = ss_questionnaires$Version[ss_questionnaires$Variable == "elp_pupil"],
                              ex_format = "STATA",
                              interview_status = "All"
                              
    )
                              
    
    ##append
    ss_append()
    