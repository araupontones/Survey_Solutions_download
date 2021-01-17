#' FUNCTION TO GET QUESTIONNAIRE DETAILS
#' 
#' Survey solutions API for getting questionnaire details
#' The return file is a tibble with all the details of all the questionnaires in the server
#' @param sserver Survey solutions server address (defined by ss_define_credentials.R)
#' @param ssuser Survey solutions API user (defined by ss_define_credentials.R)
#' @param sspassword Survey Solutions APU user password (defined by ss_define_credentials.R)
#' @param sslimit limit of return questionnaires to be displated (max is 40)


SS_getQnsDetails = function(sslimit = 40, ...){
  
  ## define url to contact the server
  apiQuestionnaires = sprintf("%s/api/v1/questionnaires", sserver)
  
  ## define a temporary json file
  MyJsonFile <- tempfile(fileext = ".json")
  
  ## get all questionnaires from the server
  Qn_Details = GET(apiQuestionnaires,
                   authenticate(ssuser, sspassword),
                   query = list(limit = sslimit),
                   write_disk(MyJsonFile, overwrite = T)
                   )
  
  ## stop if status of request is not 200
  if (Qn_Details$status_code != 200) {
    
    stop(paste("Status Code:", Qn_Details$status_code))
    
  } else {
    
    ## convert response into a tibble
    response_json <- jsonlite::fromJSON(MyJsonFile)
    
    
    table_qndetails <-tibble(response_json$Questionnaires) %>%
      mutate(LastEntryDate = ymd_hms(str_replace(LastEntryDate, "T", " ")))
    
    #return(table_qndetails)
    #save questionnaire details in the global environment
    assign("ss_questionnaires", table_qndetails, .GlobalEnv)
    message(paste(
                  "ss_questionnaires has been saved in the environment. It cointains all the information of the questionaires imported in",
                  sserver))
    
    
  }
  
  
} 
