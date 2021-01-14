## Functions used during the data collection (fieldwork) stage


## FUNCTIONS TO DOWNLOAD ----------------------------------------------------------------------------

#' FUNCTION TO GET QUESTIONNAIRE DETAILS
#' 
#' Survey solutions API for getting questionnaire details
#' The return file is a tibble with all the details of all the questionnaires in the server
#' @param sserver Survey solutions server address
#' @param ssuser Survey solutions API user
#' @param sspassword Survey Solutions APU user password
#' @param sslimit limit of return questionnaires to be displated (max is 40)


SS_getQnsDetails = function(sserver, ssuser, sspassword, sslimit = 40, ...){
  
  ## define url to contact the server
  apiQuestionnaires = sprintf("%s/api/v1/questionnaires", sserver)
  
  ## define a temporary json file
  MyJsonFile <- tempfile(fileext = ".json")
  
  ## get all questionnaires from the server
  Qn_Details = GET(apiQuestionnaires,
                   authenticate(ssuser, sspassword),
                   query = list(limit = sslimit),
                   write_disk(MyJsonFile, overwrite = T))
  
  ## stop if status of request is not 200
  if (Qn_Details$status_code != 200) {
    
    stop(paste("Status Code:", Qn_Details$status_code))
    
  } else {
    
    ## convert response into a tibble
    response_json <- jsonlite::fromJSON(MyJsonFile)
    
    
    table_qndetails <-tibble(response_json$Questionnaires) %>%
      mutate(LastEntryDate = ymd_hms(str_replace(LastEntryDate, "T", " ")))
    
    return(table_qndetails)
    
    
  }
  
  
} 

#' FUNCTION TO GET HISTORY OF INTERVIEWS OF A SPECIFIC QUESTIONNAIRE
#' 
#' @param sserver SS server
#' @param sspassword SS API password
#' @param ssuser SS API user
#' @param qn_variable variable of questionnaire
#' @param version version of questionnaire
#' @param questionnaires trible with info of all questionnaires in the server

ss_getInterviews <- function(ssserver, sspassword, ssuser, qn_variable ="tracking", version =1, questionnaires, ...){
  
  ## Get the ID of the given questionnaire
  quid = questionnaires %>% filter(Variable==qn_variable) %>% .$QuestionnaireId %>% unique()
  
  ## define API query
  apiInterviews = sprintf("%s/api/v1/questionnaires/%s/%s/interviews", sserver, quid,version)
  
  ## define temp json file
  Myjson <- tempfile(fileext = ".json")
  
  ## Get information of all the interviews of the given quesitonnaire
  interviews_respnse <- GET(apiInterviews, authenticate(ssuser, sspassword),
                            query = list(limit=3500, offset=1),
                            write_disk(Myjson, overwrite = T))
  
  ## return the all the interviews in a tible format 
  response_json <- jsonlite::fromJSON(Myjson)
  
  interviews = tibble(response_json$Interviews) 
  #%>%
  # mutate(LastEntryDate = ymd_hms(str_replace(LastEntryDate,"T", " ")))
  
  return(interviews)
}


#' #' FUNCTION TO EXPORT QUESTIONNAIRES
#' #' 
#' #' @param sserver SS server
#' #' @param questionnaires tiblle with information of questionnaires in server
#' #' @param qn_variable Variable that identifies questionnaire in server
#' #' @param qn_version Version of questionnaire to download
#' #' @param ssuser SS API user
#' #' @param sspassword SS API password
#' #' @param ex_format format of export 
#' 
#' 
#' 
#' 
#' ss_export = function(sserver, questionnaires ,qn_variable, 
#'                      qn_version, 
#'                      ssuser, sspassword,
#'                      ex_format = "stata",
#'                      temporary_dir = tempdir(),
#'                      exdir = tempdir()){
#'   
#'   
#'   for(version in qn_version){
#'     
#'     
#'     
#'     ## get questionnaire ID
#'     quid = questionnaires %>% filter(Variable == qn_variable & Version == version) %>% .$QuestionnaireIdentity
#'     
#'     
#'     ## generate export in the server
#'     apiGenerate <- sprintf("%s/api/v1/export/%s/%s/start", sserver,
#'                            "Stata",quid)
#'     
#'     
#'     generate <- POST(apiGenerate, authenticate(ssuser, sspassword)) 
#'     
#'     Sys.sleep(2)
#'     
#'     ## export data
#'     apiExport =  sprintf("%s/api/v1/export/%s/%s", sserver, ex_format, quid)
#'     
#'     response_export <- GET(apiExport, authenticate(ssuser, sspassword), user_agent("andres.arau@outlook.com"))
#'     #Sys.sleep(5)
#'     Sys.sleep(3)
#'     
#'     
#'     ## define names of zip files and exit directory
#'     
#'     ## (this is the name of the file)
#'     unzip_name = paste0(qn_variable,"_", version)
#'     zip_name = paste0(unzip_name,".zip")
#'     
#'     zipfile = file.path(temporary_dir,zip_name)
#'     
#'     ## directory where .zip is going to be extracted
#'     outputdir = file.path(exdir, unzip_name )
#'     
#'     if (!file.exists(outputdir)){
#'       
#'       dir.create(outputdir)
#'       
#'     }
#'     
#'     
#'     #open connection to write data in temporary directory
#'     filecon <- file(zipfile, "wb") 
#'     #write data contents to download file!! change unzip folder to temporary file when in shiny
#'     writeBin(response_export$content, filecon) 
#'     #close the connection
#'     close(filecon)
#'     
#'     
#'     ## unzip data into the export directory 
#'     unzip(zipfile=zipfile, overwrite = TRUE, 
#'           exdir = outputdir, 
#'           unzip = "internal"
#'     )
#'     
#'     
#'     print(zipfile)
#'     print(paste("Exporting questionnaire:", qn_variable, "Version:", version))
#'     print(paste("Exporting data to:", outputdir))
#'     
#'     
#'     
#'   }
#'   
#'   
#'   
#' }



#' FUNCTION TO EXPORT QUESTIONNAIRES 2 (BECAUSE V1 HAS BEEN DEPRECIATED)
#' 
#' @param sserver SS server
#' @param questionnaires tiblle with information of questionnaires in server
#' @param qn_variable Variable that identifies questionnaire in server
#' @param qn_version Version of questionnaire to download
#' @param ssuser SS API user
#' @param sspassword SS API password
#' @param ex_format format of export 




ss_export2 = function(sserver, 
                      questionnaires ,
                      qn_variable, 
                     qn_version, 
                     ssuser, sspassword,
                     ex_format = "STATA",
                     temporary_dir = tempdir(),
                     exdir = tempdir(),
                     interview_status = "All"){
  
  
  for(version in qn_version){
    
    
    
    ## get questionnaire ID
    quid = questionnaires %>% filter(Variable == qn_variable & Version == version) %>% .$QuestionnaireIdentity
    
    
    ## generate export in the server
    apiGenerate <- sprintf("%s/api/v2/export/", sserver)
    
    
    #generate file in server
    response_generate = POST(apiGenerate,
                             authenticate(ssuser, sspassword),
                             body =   list(ExportType= ex_format,
                                           QuestionnaireId	 = quid,
                                           InterviewStatus = interview_status
                             ),
                             encode = "json"
    )
    
    #get the links of all files generated in the system
    Myjson <- tempfile(fileext = ".json")
    
    response_link = GET(apiGenerate, 
                        authenticate(ssuser, sspassword),
                        query = list(exportType= ex_format,
                                     questionnaireIdentity = quid,
                                     interviewStatus = interview_status
                        ),
                        write_disk(Myjson, overwrite = T)
    )
    
    #arrange the links by date
    response_json_link <- jsonlite::fromJSON(Myjson) %>%
      mutate(CompleteDate = str_replace(CompleteDate,"T", " "),
             CompleteDate = str_remove(CompleteDate, "\\.[^.]*$"),
             CompleteDate = lubridate::ymd_hms(CompleteDate)) %>%
      arrange(desc(CompleteDate))
    
    
    #get the latest link
    apiExport = response_json_link$Links$Download[1]
    
    
    
    response_export <- GET(apiExport, authenticate(ssuser, sspassword), user_agent("andres.arau@outlook.com"))
    #Sys.sleep(5)
    Sys.sleep(3)
    
    
    ## define names of zip files and exit directory
    
    ## (this is the name of the file)
    unzip_name = paste0(qn_variable,"_", version)
    zip_name = paste0(unzip_name,".zip")
    
    zipfile = file.path(temporary_dir,zip_name)
    
    ## directory where .zip is going to be extracted
    outputdir = file.path(exdir, unzip_name )
    
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
    print(paste("Exporting questionnaire:", qn_variable, "Version:", version))
    print(paste("Exporting data to:", outputdir))
    
    
    
  }
  
  
  
}


#' FUNCTION TO APPEND DIFFERENT VERSIONS OF QUESTIONNAIRE AND SAVE IN RAW FOLDER
#' @param downloadDir Directory where data is downloaded from survey solutions
#' @param rawDir Directory where data will be appended   



ss_append <- function(downloadDir, rawDir, ...) {
  #' List of all files that have been downloaded
  downloaded_files = list.files(downloadDir, pattern = ".dta", recursive = T, full.names = T)
  
  list_files = lapply(downloaded_files, function(x)({
    
    #'do not return if file is empty
    questionnaire = import(x) 
    if(nrow(questionnaire)>0){
      
      return(questionnaire)
    }
    
  }))
  
  
  names(list_files) <- downloaded_files
  
  #' questionnaires with at least one row
  list_files = list_files[lengths(list_files) != 0]
  questionnaires  = unique(str_extract(names(list_files), "(?<=[0-9]\\/).*"))
  
  
  #'create raw directory in case it does not exists
  if (!file.exists(rawDir)){dir.create(rawDir)}
  
  #' append quesitonnaires
  for(q in questionnaires){
    
    exdir = file.path(rawDir,q)
    print(paste("Creating", exdir))
    #' list with versions of these questoinnaire
    append = list_files[str_detect(names(list_files), q)]
    
    #' append and export
    do.call(plyr::rbind.fill, append) %>%
      export(exdir)
  }
  
}



#'FUNCTION TO READ AND PREPARE Survey solution diagnostics

#' @param dirRaw directory where raw data is saved

ss_diagonostics = function(dirRaw){
  
  ## diagnostics of tracking
  data_diagnostics = import(file.path(dirRaw, "interview__diagnostics.dta")) %>%
    select(interview__key, responsible, interview__duration) %>%
    rename(duration = interview__duration) %>%
    mutate(duration = hms(str_remove(duration, "[0-9]{1,}\\.")),
           duration = round(period_to_seconds(duration) / 60, digits = 0))
  
  return(data_diagnostics)
  
  
  
}

#' FUNTION TO READ Survey solutions actions
#' @param dirRaw Directory where survey solutions raw data is stored


ss_actions = function(dirRaw){
  
  data_actions = import(file.path(dir_raw, "interview__actions.dta")) %>%
    mutate(across(all_of(c("action")), ss_labels),
           date = ymd(date)) %>%
    filter(action == "Completed") %>%
    group_by(interview__key) %>%
    arrange(desc(date)) %>%
    slice(1)%>%
    ungroup() %>%
    select(interview__key, date, time)
  
  return(data_actions)
  
}



### FUNCTIONS USED IN CARPINTERY -----------------------------------------------------------------

#' TO TRANSFORM CATEGORICAL VARIABLES FROM STATA TO R FACTORS
#' @param x vector of variables for which labels will be used 

ss_labels = function(x){
  levels = attributes(x)$labels
  labels = names(levels)
  
  factor(x, 
         levels = levels,
         labels = labels)
  
}

#' TO IDENTIFY DUPLICATES
#' @param x vector in which you want to scan duplicates

ss_duplicates = function(x){ 
  ## identify duplicates
  x %in% x[duplicated(x)]
}


#' To count not answered questions
#'@param db dataset to check for duplicates 
ss_not_answered = function(db){
  
  apply(db, MARGIN = 1, function(x) sum(x=="##N/A##", na.rm = T))
  
}

#'To create link to interview in HQ
#'@param x interview__key or variable used in ss server 

ss_link = function(x){
  
  glue('<a href= "http://www.muvapob.com/Interview/Review/{x}" target="_blank"> LINK</a>')
  
}

#' To export data to the clean directory once it was checked and clean
#' @param  None! this function does not use a parameter it is manually created

ss_export_clean = function(IDagregado, IDindividual){

  raw_agregado %>%
    filter(!interview__key %in% IDagregado) %>%
    export(file.path(file.path(dir_clean, "agregado.rds")))


  raw_roster %>%
    filter(!interview__key %in% IDagregado) %>%
    export(file.path(file.path(dir_clean, "roster_miembros.rds")))



  raw_individual %>%
    filter(!interview__key %in% IDindividual) %>%
    export(file.path(file.path(dir_clean, "individual.rds")))

  raw_children %>%
    filter(!interview__key %in% IDindividual) %>%
    export(file.path(file.path(dir_clean, "fert_children.rds")))

  #message("Data successfully saved in the clean folder")



}

#' TO FORMAT DATA AS IT IS GOING TO BE PRESENTED IN SHINY (FOR INDIVIDUAL AND AGREGADO)
#' @param varStatus The FW status of the interview
#' @param levelsResultado The levels of the fw status (defined in criteria)

ss_data_for_shiny = function(db = . , varStatus, levelsResultado, ...) {
  
  #' select key variables for dashboard
  select(db, all_of(c(vars_dashboard,varStatus, "link"))) %>%
    #'join with data reference
    right_join(data_reference) %>%
    
    relocate(c("cidade", "Bairro", "Sampled", varStatus), .after = hh_id) %>%
  
    #' status as factor to allow sorting
    mutate(., !!varStatus := factor(if_else(is.na(.[[varStatus]]), "SEM VISITAR", as.character(.[[varStatus]])),
                                    levels = levelsResultado,
                                    ordered = T)) %>%
    select(-password, -seq2020)
  
}

#' to clean wrongly coded as not answer
clean_roster_vars = function(x){str_replace_all(x,"##N/A##", "" )}


message("Functions loaded!")
