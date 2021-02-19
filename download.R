
##Set paths

  
    dir_functions ="R"  #folder where the R scripts are located
    survey_dir = "C:/Users/andre/Dropbox/SS" ## directory of the survey
    dir_ss_downloads = file.path(survey_dir, "downloads") ## directory to download the data
    dir_raw = file.path(survey_dir, "raw") ## directory to store the raw data


    survey_so_user = "araupontones"
    survey_so_pass = "Seguridad1"
    surve_so_server =  "http://www.pulpodata.solutions"


    
#load scripts - this runs the functions to download the data (No Action needed) --------------------------------------------------------------
    source(file.path(dir_project,"set_up.R"))
    scripts = list.files(dir_functions, recursive = T)
    
    message("Loading the following functions")
    for(script in scripts){
      
      message(script)
      source(file.path(dir_functions, script))
    }
    
    


# Define credentials- (No action needed) ----------------------------------------------------------

 ss_credentials(ssuser = survey_so_user,
                sspassword =  survey_so_pass,
                sserver = surve_so_server ,
                dir_ss_downloads = dir_ss_downloads, 
                dir_ss_raw = dir_raw)


# get details of all the questionnaires imported in the server ----------------

  SS_getQnsDetails() #this functions saves ss_questionnaires in  the global environment


#export interviews (ACTION: define the parameters of your query, each query must be called by it self)
    
  ss_export_file(qn_variable= "elp_classroom",
                 qn_version = 6,
                 ex_format = "stata",
                 interview_status = "All"
                 
  )
  
    ss_export_file(qn_variable= "elp_principal",
                              qn_version = 6,
                              ex_format = "stata",
                              interview_status = "All"
                              
    )
                              
    
##append and save in raw folder -----------------------------------------------------------------------
    ss_append()
    
    
    