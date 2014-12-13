if(!require(sqldf)) install.packages ("sqldf")
library(sqldf)

if(!require(ggplot2)) install.packages ("ggplot2")
library(ggplot2)



# code to load from local file
# fpath = paste(getwd(),"/data/gourmetFoods.RData", sep = "" )
# w = load(fpath)


githubURL = "https://github.com/jwindokun/FinalProject/raw/master/data/gourmetFoods.RData"

try ({
  
  load(url(githubURL))
  
})


t = 5

#Users with the most reviews
sql = "SELECT Count(gourmetFoods.userID) AS numReviews, gourmetFoods.profileName FROM gourmetFoods GROUP BY gourmetFoods.profileName
        HAVING (((gourmetFoods.profileName)<>'unknown')) ORDER BY Count(gourmetFoods.userID) DESC limit 10 ;"

result = sqldf(sql)


ggplot(result, aes(x = reorder(profileName, numReviews), y = numReviews)) + geom_bar(stat="identity", fill="lightblue", colour="black") +
    labs(title = "Number of Reviews per Reviewer (Top Ten Reviewers)", x = "Reviewer", y = "Count") + theme_bw()+
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

Sys.sleep (t)

#Average Review Score by Reviewer
sql = "SELECT Count(gourmetFoods.userID) AS numReviews, gourmetFoods.profileName, Avg(gourmetFoods.score) AS AvgOfscore, Max(gourmetFoods.score) AS MaxOfscore, Min(gourmetfoods.score) AS MinOfscore
        FROM gourmetFoods GROUP BY gourmetFoods.profileName HAVING (((gourmetFoods.profileName)<>'unknown')) ORDER BY Count(gourmetFoods.userID) DESC limit 10;"

result = sqldf(sql)

ggplot(result, aes(x = reorder(profileName, AvgOfscore), y = AvgOfscore)) + geom_bar(stat="identity", fill="green", colour="red") +
    labs(title = "Average Reviewer Score By Reviewer (Top Ten Reviewers)", x = "Reviewer", y = "Average Score") + theme_bw()+
    theme(axis.text.x = element_text(angle = 45, hjust = 1))


Sys.sleep (t)
#Average helpfulness per reviewer

sql = "SELECT gourmetFoods.userID, gourmetFoods.profileName, Avg(gourmetFoods.helpfulness) AS aveOfhelpfulness, Count(gourmetFoods.helpfulness) AS countOfHelpfulness
        FROM gourmetFoods GROUP BY gourmetFoods.userID, gourmetFoods.profileName ORDER BY Avg(gourmetFoods.helpfulness)  DESC , Count(gourmetFoods.helpfulness)
        DESC limit 10;"


result = sqldf(sql)

ggplot(result, aes(x = reorder(profileName, aveOfhelpfulness),  y = aveOfhelpfulness,fill = countOfHelpfulness)) + geom_bar(stat="identity", fill = "brown", colour="red") +
    labs(title = "Average Helpfullness Score By Reviewer (Top Ten Reviewers)", x = "Reviewer", y = "Average Score") + theme_bw()+
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

Sys.sleep (t)
#Ploting Helpfulness score with Reviewer score

ggplot(gourmetFoods, aes(x=gourmetFoods$score,y=gourmetFoods$helpfulness)) + geom_point(position=position_jitter(w=0.1,h=0.0), color ="red") +
    geom_smooth(method="lm", se=FALSE, fill = "blue", size = 2) + ylab('Helpfulness Score') + xlab('Reviewer Score') + ggtitle("Scatter Plot of Helpfullness Score vs Reviwer Score")


# Statistics

fit = lm(helpfulness ~score, data = gourmetFoods)
coef(fit)
anova(fit)
summary(fit)

Sys.sleep (t)
# look at Sentiment Analysis of summary and text



# fpath = paste(getwd(),"/data/gourmetFoodsAPI.RData", sep = "" )
# w = load(fpath)



githubURL = "https://github.com/jwindokun/FinalProject/raw/master/data/gourmetFoodsAPI.RData"

try ({
  
  load(url(githubURL))
  
})



ggplot(gourmetFoodsAPI, aes(x=gourmetFoodsAPI$apisummaryScore,y=gourmetFoodsAPI$apitextScore)) + geom_point(position=position_jitter(w=0.1,h=0.0), color ="red") +
  geom_smooth(method="lm", se=FALSE, fill = "blue", size = 2) + ylab('Text Score') + xlab('Summary Score') + ggtitle("Scatter Plot of Summry Score vs Text Score")

fit = lm(apitextScore ~apisummaryScore, data = gourmetFoodsAPI)
coef(fit)
anova(fit)
summary(fit)

 
