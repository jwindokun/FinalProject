if (!require(devtools)) install.packages('devtools')
library(devtools)
if (!require(rvest)) install_github("hadley/rvest")
library(rvest)
library(XML)
library(stringr)


fpath = paste(getwd(), "/data/", sep = "")
fileName = "gourmetFoods.RData"   
inputFile <- paste(fpath, fileName, sep = "")
w = load(inputFile)
str(gourmetFoods)


dfAmazon <- data.frame(userID = character(), reviewerName =  character(), numReviews = numeric(), itemName = character(),
                       itemPrice = numeric(), date = character(), text = character(),stringsAsFactors=FALSE)


# For demonstration purposes will only use the first 10 rows
#for (i in length(gourmetFoods)) {
for (i in 10) {

    try({
    
    userID = gourmetFoods$userID[i]
    website = paste("http://www.amazon.com/gp/cdp/member-reviews/", userID, sep ="") 
    r_site <- html(website)
    r <- r_site %>%
    html_nodes(".small") %>%
    html_text() %>%
    gsub("[\t\n\r\f\v]", "", .)


    #Get the reviewer name
    df <- data.frame(userID = character(), reviewerName =  character(), numReviews = numeric(), itemName = character(),
                     itemPrice = numeric(), date = character(), text = character(),stringsAsFactors=FALSE)


    # First line contains reviewer information
    reviewerName = substr(str_trim(r[1]), start = 13, stop = (nchar(str_trim(r[1])) -10))
   
    # Line 3 contains the total number of reviewsreviews
    numReviews = as.numeric(strsplit(str_trim(r[3]), split = " ", fixed = TRUE)[[1]][3])

   
    # get the items reviewed

    # Line 16 and (with an interval of 8) contains information on the item reviewed)
    n = 1
    for (i in seq(16,length(r),8)){
      
        df[n, "userID"] = ifelse(!is.null(userID), userID, "")
       
        df[n, "reviewerName"] = ifelse(!is.null(reviewerName), reviewerName, "")
        df[n, "numReviews"] =ifelse(!is.null(numReviews), numReviews, 0)

        t = str_split_fixed(str_trim(r[i]), ":", 2)
                
        while (nchar(t[1]) < 4){
          
          t = str_split_fixed(str_trim(r[i + 1]), ":", 2)
          i = i+1
          
        }
                      
        t = str_split_fixed(str_trim(r[i]), "Price:", 2)
        df[n, "itemName"] = ifelse(!is.null(t[1]), t[1], "")
        
        
        
        
        #df[n, "itemPrice"] =ifelse(!is.null(t[2]), as.numeric(str_sub(str_trim(t[2]),2)), 0)
        p = as.numeric(str_sub(str_trim(t[2]),2))
        f <- function(x) is.numeric(x) & !is.na(x)
        #print (f(p))
        df[n, "itemPrice"] =ifelse(f(p), p, 0)
        n = n + 1

    }

  
    # Line 20 and (with an interval of 20 contains information on the date of the review, and the text of the review)
    n = 1
    for (i in seq(20,length(r),8)){
      
        gDate <- "(([[:alpha:]]+)([[:space:]])([0-9]{1,2})([,])([[:space:]])([0-9]{4}))"
        strings <- str_trim(r[i])
        
        date = str_extract(strings, gDate)
        
        while (is.na(date)){
          
          strings <- str_trim(r[i+1])
          date = str_extract(strings, gDate)
          i = i+1
          
        }
        
        
        #date = as.Date(str_extract(strings, gDate), "%B %d, %Y")
        #print (date) 
        f = function (x) is.na(as.Date(as.character(x),format="%B/%m/%Y"))
        
        
        df[n, "date"] = ifelse(f(date), date, "")
             
          
        s = str_split_fixed(str_trim(r[i]), ":", 2)[2]
        s = str_trim(str_split_fixed(s, ")", 2)[2])
        df[n, "text"] = ifelse(!is.null(s), s, "")

        n = n + 1

    }

    dfAmazon = rbind(dfAmazon, df)
    Sys.sleep (2)

    }, silent = TRUE)

}


str(dfAmazon)
dfAmazon[1,]

