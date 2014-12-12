

gDate <- "(([[:alpha:]]+)([[:space:]])([0-9]{1,2})([,])([[:space:]])([0-9]{4}))"

#gDate <- "(([[:space:]])(.)([[:space:]])([0-9]{1,2})([,])([[:space:]])([0-9]{4}))"

r

for (i in seq(20,length(r),8)){
  
  strings <- str_trim(r[i])
  date = str_extract(strings, gDate)
  
  while (is.na(date)){
    
    strings <- str_trim(r[i+1])
    date = str_extract(strings, gDate)
    i = i+1
    
  }
  
  
  
  print (date)
  
}



