rankall <- function(outcome, num = "best") {
  ## Read outcome data
  outcome_care <- read.csv("outcome-of-care-measures.csv", colClasses="character")
  
  ## Check that outcome are valid
  valid_outcome<-c("heart attack","heart failure", "pneumonia")
  #if(!state %in% levels(factor(outcome_care$State))) stop("invalid state")
  if(!outcome %in% valid_outcome) stop("invalid outcome")
  
  #Helper strings are created
  s <- strsplit(outcome, " ")[[1]]
  prevar<-paste(toupper(substring(s, 1,1)), substring(s, 2),
                sep="", collapse=".")
  
  vars <- c("State","Hospital.Name",paste("Hospital.30.Day.Death..Mortality..Rates.from.",prevar,sep="") )
  
  #Data extraction and sort by state and outcome
  suppressWarnings(outcome_care[,vars[3]]<-as.numeric(outcome_care[,vars[3]]))
  df<-outcome_care[,vars]
  df_sort<-df[order(df[,vars[1]],df[,vars[3]],df[,vars[2]]),]
  
  ## For each state, find the hospital of the given rank
  if ( num=="best" ){
    helper<-lapply(split(df_sort,df_sort[,1]),function(x)x[which.min(x[,3]),2])}
  if ( num=="worst" ){
    helper<-lapply(split(df_sort,df_sort[,1]),function(x)x[which.max(x[,3]),2])}
  if (is.numeric(num)) {helper<-lapply(split(df_sort,df_sort[,1]),function(x)x[num,2])}

  df_final<-do.call(rbind.data.frame,helper)
  names(df_final)<-"hospital"
  df_final$state<-row.names(df_final)
  
  ## Return a data frame with the hospital names and the
  ## (abbreviated) state name
  df_final
}
