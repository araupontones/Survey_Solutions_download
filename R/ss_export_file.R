## FUNCTION TO DOWLOAD THE FILE FROM THE SERVER
#' @param  qn_variable variable name of questionnaire
#' @param qn_version versions to download
#' @param interview_status

ss_export_file = function(qn_variable,
                          qn_version,
                          ex_format = "STATA",
                          interview_status = "All",
                          temporary_dir = tempdir(),
                          #dir_ss_downloads = tempdir(),
                          ...){
  
  # post to generate file for every version required by the client
  for(v in qn_version){
  
   
    # function to pass info to the server
    post_to_server =function(){ ss_generate(quid = ss_get_qnID(
      qn_variable = qn_variable,
      qn_version = v),
      ex_format = ex_format)
    }

    #try for the first time 
    first_attempt = post_to_server()
    Sys.sleep(3)
    

    if(first_attempt$response$status_code == 201){
      
      print(paste0(qn_variable,"_",v, " has been genereated succesfully"))
      print(paste("JobID:",first_attempt$details$JobId))
      JobID = first_attempt$details$JobId
      
    } else{
      
      #try again
      message(paste(qn_variable,"first attempt failed, trying again"))
      second_attempt = post_to_server()
      Sys.sleep(5)
      message(paste("Status of second attempt:", second_attempt$response$status_code))
      JobID = second_attempt$details$JobId
    }
    
  
  
    #Define API to export
    apiExport = sprintf("%s/api/v2/export/%s/file", sserver, JobID)
    print(apiExport)
    
    #remove JobID
    rm(JobID)
    
    #export file
        response_export <- GET(apiExport, authenticate(ssuser, sspassword), user_agent("andres.arau@outlook.com"))
        


        ## define names of zip files and exit directory

        ## (this is the name of the file)
        unzip_name = paste0(qn_variable,"_", v)
        zip_name = paste0(unzip_name,".zip")

        zipfile = file.path(temporary_dir,zip_name)

        ## directory where .zip is going to be extracted
        outputdir = file.path(dir_ss_downloads, unzip_name )

        if (!file.exists(outputdir)){

          dir.create(outputdir)

        }
         
         
         #open connection to write data in temporary directory
         filecon <- file(zipfile, "wb") 
         #write data contents to download file!! change unzip folder to temporary file when in shiny
         writeBin(response_export$content, filecon) 
         #close the connection
         close(filecon)
         
         
         ## unzip data into the export directory 
         unzip(zipfile=zipfile, overwrite = TRUE, 
               exdir = outputdir, 
               unzip = "internal"
         )
         
         
         print(zipfile)
         print(paste("Exporting questionnaire:", qn_variable, "Version:", v))
         print(paste("Exporting data to:", outputdir))
     

       
        
        
  
  
  }
}
