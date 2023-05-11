#get rid of columns you dont need

#recode all -999 to NAs

#combine vitals date and time 

#separate out year in vitals date to match VEGF

#sepate vitals blood pressure to systolic and diastolic

#create bmi
      #get all of height into the same units
      #library(dplyr)
      library(tidyr)

    combine.data %>%
separate(Ht,c('feet', 'inches'), sep = '-', convert = TRUE, remove = FALSE) %>%
  mutate(feet = 12*feet + inches) %>%
  select(-inches)

    #calculate bmi
    
    



#summarize data
summary(vegf.demogs.apoe.left.365)
by(vegf.demogs.apoe.left.365, vegf.demogs.apoe.left.365$vitals_gender, summary)
by(vegf.demogs.apoe.left.365, vegf.demogs.apoe.left.365$vitals_gender, summary)

library(Hmisc)
describe(vegf.demogs.apoe.left.365)

install.packages("pastecs")
library(pastecs)
stat.desc(vegf.demogs.apoe.left.365$vitals_age)
options(scipen = 999, digits = 1)
#remove scientific notation from output
stat.desc(vegf.demogs.apoe.left.365$vitals_age)
options(scipen=0) #turn scientific notation on
stat.desc(vegf.demogs.apoe.left.365$vitals_age)

install.packages("psych")
library(psych)
describeBy(vegf.demogs.apoe.left.365, vegf.demogs.apoe.left.365$vitals_gender)
describeBy(vegf.demogs.apoe.left.365, vegf.demogs.apoe.left.365$vitals_gender, mat=TRUE)
gender.matrix.summary <-describeBy(vegf.demogs.apoe.left.365, vegf.demogs.apoe.left.365$vitals_gender, mat=TRUE)

#https://dabblingwithdata.amedcalf.com/2018/01/02/my-favourite-r-package-for-summarising-data/

#output the description file 
write.csv(gender.matrix.summary,  file="vegf.demogs.apoe.left.365_summarybygender.csv")







-----------------------------------------
  
  #tidyverse - install.packages("tidyverse")
  library(lubridate) #As already recognized by the OP, a year alone does not make up a valid date because month and day are not specified.However, some date and date-time conversion functions, e.g., ymd(), parse_date_time(), in the lubridate package recognize a parameter truncated to allow for parsing of incomplete dates:

#lubridate::ymd(vegf.demogs.apoe.left$year, truncated = 2L)

#https://lubridate.tidyverse.org/
# Date-time data can be frustrating to work with in R. R commands for date-times are generally unintuitive and change depending on the type of date-time object being used. Moreover, the methods we use with date-times must be robust to time zones, leap days, daylight savings times, and other time related quirks, and R lacks these capabilities in some situations. Lubridate makes it easier to do the things R does with date-times and possible to do the things R does not.

vegf.demogs.apoe.left$vegf.year.dt2<-lubridate::ymd(vegf.demogs.apoe.left$year, truncated = 2L)
head(vegf.demogs.apoe.left$vegf.year.dt2)
