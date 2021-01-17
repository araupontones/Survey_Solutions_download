 
#' FUNCTION TO GET QN ID
#' @param qn_variable variable name of the questionnaire
#' @param qn_verison version of the questionnaire to find
#' @param questionnaires data base with info of questionnaires (run SS_getQnsDetails () to generate it)
ss_get_qnID = function(qn_variable,
                           qn_version,
                       ...){

      quid = ss_questionnaires %>% filter(Variable == qn_variable & Version == qn_version) %>% .$QuestionnaireIdentity

      return(quid)


    }


