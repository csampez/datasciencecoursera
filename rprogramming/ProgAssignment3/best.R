#hist(as.numeric(outcome[,11]))

best <- function(state, outcome, ord=1) {
  
  ## Read outcome data
  outcome_care <- read.csv("outcome-of-care-measures.csv", colClasses="character")
  
  ## Check that state and outcome are valid
  valid_outcome<-c("heart attack","heart failure", "pneumonia")
  if(!state %in% levels(factor(outcome_care$State))) stop("invalid state")
  if(!outcome %in% valid_outcome) stop("invalid outcome")
  
  #Helper strings are created
  s <- strsplit(outcome, " ")[[1]]
  prevar<-paste(toupper(substring(s, 1,1)), substring(s, 2),
                sep="", collapse=".")
  
  vars <- c("Hospital.Name",paste("Hospital.30.Day.Death..Mortality..Rates.from.",prevar,sep="") )
  
  #Data extraction and sort by state and outcome
  hosp_nums<-outcome_care[outcome_care$State==state,vars]
  hosp_nums[,2] <- suppressWarnings(as.numeric(hosp_nums[,2]))
  
  sorted_df<-hosp_nums[order(hosp_nums[,2],hosp_nums[,1]),]
  
  if (ord == -1) return(sorted_df[which.max(sorted_df[,2]),1])
  sorted_df[which.min(sorted_df[,2]),1]
  
}
