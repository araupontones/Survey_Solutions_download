    

#'Define Server credentials
#' @param  ssuser User of ss
#' @param sspassword Password API
#' @param server Server of ss
#' 
ss_credentials = function(ssuser,
         sspassword,
         sserver,
         dir_ss_downloads,
         dir_ss_raw){
  
 names = c("ssuser", "sserver", "sspassword", "dir_ss_downloads", "dir_ss_raw")
 values = c(ssuser,sserver, sspassword, dir_ss_downloads, dir_ss_raw)
 
 #save parameters in global directory
 lapply(seq_along(1:length(names)),
        function(x){
          
          print(names[[x]])
          assign(names[[x]], value = values[[x]], envir = .GlobalEnv)
        }
        
        
        )
  
  
 
  
}







  
  
