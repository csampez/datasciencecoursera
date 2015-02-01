rankhospital <- function(state, outcome, num = "best") {
    
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
    ## Check if num is valid 
    suppressWarnings(if (num == "best") return( best(state, outcome)))
    suppressWarnings(if (num == "worst") return ( best(state, outcome, -1))) 
    suppressWarnings(if (max(num) > length(sorted_df[,1]) || !is.numeric(num)) return(NA))
    
    ## Return hospital name in that state with lowest 30-day death
    ## rate
    
    sorted_df[num,"Hospital.Name"]
}
  
 