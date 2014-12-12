fpath = paste(getwd(),"/data/amazonReviews.RData", sep = "" )

w = load(fpath)
w
# remove NA


# amazonReviews = dfAmazon[ , apply(dfAmazon, 2, function(x) !any(is.na(x) | (is.null(x))))]
# amazonReviews <- amazonReviews[!apply(amazonReviews, 1, function(x) any(x=="")),] 
# 
# file = paste(getwd(), "/data/amazonReviews.csv", sep = "" )
# write.csv(file, x = amazonReviews)
# file = paste(getwd(), "/data/amazonReviews.RData", sep = "" )
# save("amazonReviews", file = file)



fpath ="C:/Users/Jare_2/Desktop/WorkDocs/CUNY/607/FinalProject/Data/processed/gourmet_foods.RData"
w = load(fpath)
w

# file = paste(getwd(), "/data/gourmetFoods.csv", sep = "" )
# write.csv(file, x = df)
# file = paste(getwd(), "/data/gourmetFoods.RData", sep = "" )
# save("df", file = file)


fpath = paste(getwd(),"/data/gourmetFoodsAPI.RData", sep = "" )

w = load(fpath)
w

df = subset(gourmetFoodsAPI, apitextScore != 0)
str(df)

file = paste(getwd(), "/data/gourmetFoodsAPI.csv", sep = "" )
write.csv(file, x = df)
gourmetFoodsAPI = df

file = paste(getwd(), "/data/gourmetFoodsAPI.RData", sep = "" )
save("gourmetFoodsAPI", file = file)









fpath = paste(getwd(),"/data/gourmetFoods1.RData", sep = "" )
w = load(fpath)

df = gourmetFoods

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

gourmetFoods = df
file = paste(getwd(), "/data/goumetFoods.RData", sep = "")
save("gourmetFoods", file = file)







fpath = paste(getwd(),"/data/gourmetFoodsAPI1.RData", sep = "" )
w = load(fpath)

df = gourmetFoodsAPI

df$apisummaryScore = as.numeric(df$apisummaryScore)
df$apitextScore = as.numeric(df$apitextScore)


gourmetFoodsAPI = df
file = paste(getwd(), "/data/goumetFoodAPIs.RData", sep = "")
save("gourmetFoodsAPI", file = file)





