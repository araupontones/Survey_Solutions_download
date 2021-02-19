library(rio)

#' FUNCTION TO APPEND DIFFERENT VERSIONS OF QUESTIONNAIRE AND SAVE IN RAW FOLDER
#' @param dir_ss_downloads Directory where data is downloaded from survey solutions
#' @param dir_ss_raw Directory where data will be appended   



ss_append <- function(...) {
  #' List of all files that have been downloaded
  downloaded_files = list.files(dir_ss_downloads, pattern = ".dta", recursive = T, full.names = T)
  
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
  questionnaires  = unique(str_extract(names(list_files), "([^\\/]+$)"))
  
  
  #'create raw directory in case it does not exists
  if (!file.exists(dir_ss_raw)){dir.create(dir_ss_raw)}
  
  #' append quesitonnaires
  for(q in questionnaires){
    
    exdir = file.path(dir_ss_raw,q)
    print(paste("Creating", exdir))
    #' list with versions of these questoinnaire
    append = list_files[str_detect(names(list_files), q)]
    
    #' append and export
    do.call(plyr::rbind.fill, append) %>%
      export(exdir)
  }
  
}

