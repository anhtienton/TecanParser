#Tecan output parser
setwd("/Users/tien/Documents/Tecan_parser")
library(gdata)

rawData <- (read.xls("TEM1_mutants_growth_07022018.xlsx", sheet=1, header=TRUE, fileEncoding="latin1"))

test.df <- data.frame(matrix(nrow=8,ncol=12))

#test <- as.numeric(as.character(droplevels(rawData[[1]])))

df.column = 1
df.row = 1

for (rows in 1:length(rawData[,1])){
  for (columns in 1:length(rawData[1,])){
    
    
    if (is.na(rawData[rows,columns]) == TRUE || nchar(trimws(rawData[rows,columns])) == 0)
      next()
    
    if (is.numeric(rawData[rows,columns]) == TRUE){
      if (rawData[rows,columns] > 3)
        next()
      test.df[df.row,df.column] <- rawData[rows,columns]
      message("Added to df")
      df.column = df.column+1
      if (df.column == 13){
        df.row = df.row+1
        df.column = 1
      }
      if (df.row == 9 && df.column==13){
        df.row=1
        df.column=1
        next()
      }
    }
    else{
      
      out <- tryCatch( 
        {
        current_parser <- as.numeric(as.character(droplevels(rawData[rows,columns])))
        },
        warning=function(cond){
          message("Warning here")
          next()
        },
        error=function(cond){
          message("Error here")
        }
      )
      # return(out)
      if (is.null(out) || out > 3)
        next
      test.df[df.row,df.column] <- out
      message("Added to df")
      df.column = df.column+1
      if (df.column == 13){
        df.row = df.row+1
        df.column = 1
      }
      if (df.row == 9 && df.column==13){
        df.row=1
        df.column=1
        next()
      }
    }
  }
}
columnNames <- 1:12
rowNames <- list()
hours <- length(test.df[,1])/8
for(i in 1:hours){
  for(j in 1:8){
    temp <- paste(c(i,".",j),collapse="")
    rowNames <- c(rowNames,temp)
  }
}
write.table(test.df,file="allData.csv",col.names= columnNames,row.names = rowNames,sep=",")