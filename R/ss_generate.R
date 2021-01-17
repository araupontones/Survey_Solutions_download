

#' FUNCTION TO POST THE GENERATION OF THE FILE
#' @param quid Questionnaire Identity
#' @param ex_format format of file
#' @param interview_status Status of interviews to download
ss_generate =  function(quid,
                        interview_status = "ALL",
                        ex_format = "STATA",
                        ...){

  #'define API
  apiGenerate <- sprintf("%s/api/v2/export/", sserver)
  
  #'create .json file temporarly
  Json_POST = tempfile(fileext = ".json")

  #create file
  response =  POST(apiGenerate,
                   authenticate(ssuser, sspassword),
                   body =   list(ExportType= ex_format,
                                 QuestionnaireId	 = quid,
                                 InterviewStatus = interview_status
                                 #AccessToken = "Hola"
                   ),
                   encode = "json",
                   write_disk(Json_POST, overwrite = T))

  #return response and information from response
  return(
    list(details = jsonlite::fromJSON(Json_POST),
         response = response)
  )

  #checks and messages to use
  
  if( response$status_code == 201){
    
    print(paste("JobID:", details$JobId))
  }
  
  }
