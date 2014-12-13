if(!require(stringr)) install.packages ("stringr")
library(stringr)



# Code to read local files
# fpath = paste(getwd(), "/data/", sep = "")
# fileName = "gourmetFoods.txt"   
# inputFile <- paste(fpath, fileName, sep = "")
# conn  <- file(inputFile, open = "r")
# line=readLines(conn, n = -1L, ok = TRUE, warn = FALSE)
# close(conn)

x <- "https://raw.githubusercontent.com/jwindokun/FinalProject/master/data/gourmetFoods_test.txt"

try ({
  
line=readLines(x, n = -1L, ok = TRUE, warn = FALSE)  

})

df <- data.frame(productID =character(), title = character(), price = as.numeric(character()), userID =character(), profileName = character(),
                 helpfulness = character(), score = as.numeric(character()), time = character(), summary = character(), text = character(),stringsAsFactors=FALSE)

t = character()
n = 1
d <- data.frame(productID =character(), title = character(), price = as.numeric(character()), userID =character(), profileName = character(),
                helpfulness = character(), score = as.numeric(character()), time = character(), summary = character(), text = character(),stringsAsFactors=FALSE)


#for (i in 1:length(line)){
# for the purpose of demonstration will only read in the first 10000 lines of the file  
for (i in 1:1000){  
  
try({
 w = str_split_fixed(line[i], ":", 2)
    if (!is.na(w[1])){
      if (n < 11) {
        d[1, n] = str_trim(w[2])
        n = n + 1
        } else {
        df = rbind(df, d)
        n = 1
      }
    }
 
}, silent = TRUE)
  }



str(df)

#clean the data

df$time = as.POSIXct(as.numeric(df$time), origin="1970-01-01")
df$price[df$price == "unknown"] = 0
df$price = as.numeric(df$price)
df$score = as.numeric(df$score)

for (i in 1 :length(df$helpfulness)){

  e = df$helpfulness[i]
  e = strsplit(e, split = "/", fixed = TRUE)[[1]]
  e = as.numeric(e[1])/as.numeric(e[2])
  if (is.finite(e)) {
        df$helpfulness[i] = e
    } else {

        df$helpfulness[i] = 0
    }
}

df$helpfulness = as.numeric(df$helpfulness)

str(df)
df[1,]







