#Tecan output parser
setwd("/Users/tien/Documents/Tecan_parser")
library(gdata)

rawData <- (read.xls("2x_data.xlsx", sheet=1, header=TRUE))

test.df <- data.frame(matrix(nrow=8,ncol=12))

#test <- as.numeric(as.character(droplevels(rawData[[1]])))

df.column = 1
df.row = 1
for (rows in 1:length(rawData[,1])){
  for (columns in 1:length(rawData[1,])){

    if (is.numeric(rawData[rows,columns]) == TRUE){
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
          break()
        },
        error=function(cond){
          message("Error here")
          break()
        },
        finally = {
          test.df[df.row,df.column] <- current_parser
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
      )
    }
    
  }
}

for (columns in 1:length(rawData[1,])){
  for (rows in 1:length(rawData[,1])){
  }
}