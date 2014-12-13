
if(!require(RCurl)) install.packages ("RCurl")
library(RCurl)
if(!require(rjson)) install.packages ("rjson")
library(rjson)

# Code to read local file

# fpath = paste(getwd(), "/data/", sep = "")
# fileName = "gourmetFoods.RData" 
# w = load(paste(fpath, fileName, sep = "")   

githubURL = "https://github.com/jwindokun/FinalProject/raw/master/data/gourmetFoods.RData"

try ({
  
  load(url(githubURL))
  
})


api_key = "45319ace2f7c43fc55d05c2f973ba6261a5de4f0"


api = paste("http://access.alchemyapi.com/calls/text/TextGetTextSentiment?apikey=", api_key, "&outputMode=json", "&text=", sep = "")

gourmetFoodsAPI = gourmetFoods

gourmetFoodsAPI[1,]

#for i in 1:nrow(gourmetfoodsAPI){
for (i in 1:2){

    if (length(gourmetFoodsAPI$text[i]) > 0) {


        phrase = URLencode(gourmetFoodsAPI$text[i])
        api_url = paste(api, phrase, sep="")
        result = getURI(api_url)
        r = fromJSON(result)
        gourmetFoodsAPI$apitextType[i] = ifelse(!is.null(r$docSentiment$type), r$docSentiment$type, "")
        gourmetFoodsAPI$apitextScore[i] = ifelse(!is.null(r$docSentiment$score), r$docSentiment$score, 0)
    }


    if (length(gourmetFoodsAPI$summary[i]) > 0) {
        phrase = URLencode(gourmetFoodsAPI$summary[i])
        api_url = paste(api, phrase, sep="")
        result = getURI(api_url)
        r = fromJSON(result)
        gourmetFoodsAPI$apisummaryType[i] = ifelse(!is.null(r$docSentiment$type), r$docSentiment$type, "")
        gourmetFoodsAPI$apisummaryScore[i] = ifelse(!is.null(r$docSentiment$score), r$docSentiment$score, 0)
    }

    Sys.sleep(2)
}



gourmetFoodsAPI[1,]

#cat("\014") 
