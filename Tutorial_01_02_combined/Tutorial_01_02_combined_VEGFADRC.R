#Goal of the Project
   1. Is CSF VEGF associated with hippocampal subfield volumes in 


## Set up working directory
getwd() #check where your current working directory is
setwd("/Volumes/GoogleDrive/My Drive/R_Scripts/Braskie_R_Workshop/Tutorial_01_02_combined/") #input correct path
getwd() #verify the directory is correct


## Install Packages
install.packages("openxlsx")
library(openxlsx)

## Import files
demogs <- read.csv("VascularCohortStudy-VitalsAll_DATA_2023-03-14_1440.csv")
apoe <-read.csv("VascularCohortStudy-ApoEAll_DATA_2023-03-14_1506.csv")
vegf<-read.xlsx("ADRC_VEGF data_12-16-21FIN.xlsx")
options(digits = 20)
options(digits = 4)
vegf

## Check File Structure and column header of subject ids - The goal is  that We want all this data in the same dataframe
str(demogs)
str(apoe)
table(apoe$apoe)
str(vegf) #notice that the subject ID capitalization and underscore/period is different, so we want to rename it 

#Rename column headers
names(vegf)[1] <- "uds_id"
str(vegf)
names(vegf)[3] <- "VEGF-A"
names(vegf)[4] <- "VEGF-B"
names(vegf)[5] <- "VEGF-B"
str(vegf)

#check for duplicates in subject group of interest
unique(vegf$uds_id)
length(unique(vegf$uds_id))
duplicated(vegf$uds_id)
vegf[duplicated(vegf$uds_id),] #identifies which are the problem subjects

#remove duplicates in subject group of interest (VEGF dataset)
vegf.nodup<- vegf[!duplicated(vegf$uds_id),] #NOT Operator “!”
vegf[1,] #row 1
vegf[, 1] #column 1

#remove duplicates in other datasets (we will in the next session learn how to filter and search within a column to match IDs)
length(unique(demogs$uds_id))
library(scales)
percent(length(unique(demogs$uds_id))/length(demogs$uds_id), accuracy = .01)
demogs.nodup<- demogs[!duplicated(demogs$uds_id),] 

apoe.nodup<- apoe[!duplicated(apoe$uds_id),] 

#complete cases
demogs.complete <- demogs.nodup[complete.cases(demogs.nodup),]#remove rows with missing values in any 
str(demogs)
demogs.complete2 <- demogs.nodup[complete.cases(demogs.nodup[ , c('vitals_gender', 'vitals_dob')]), ] #remove rows with NA in specific columns of data frame

#remove row based on condition
demogs.nodup.999 <- demogs.nodup[demogs.nodup$vitals_weight != -999, ]     
demogs.nodup.999 <- demogs.nodup[demogs.nodup$vitals_weight != -999 & demogs.nodup$vitals_pulse != -999, ]     


#join the dataframes based on VEGF data (unique)
library("plyr")
vegf.demogs.left<-join(vegf.nodup, demogs.nodup, by="uds_id", type="left") #left: all rows in x, adding matching columns from y
vegf.demogs.right<-join(vegf.nodup, demogs.nodup, by="uds_id", type="right") #right: all rows in y, adding matching columns from x
vegf.demogs.right<-join(vegf.nodup, demogs.nodup, by="uds_id", type="full") #full: all rows in x with matching columns in y, then the rows of y that don't match x.

vegf.demogs.inner<-join(vegf.nodup, demogs.nodup, by="uds_id", type="inner") #inner: only rows with matching keys in both x and y

vegf.demogs.match.all<-join(vegf.nodup, demogs, by="uds_id", type="left", match="all") #how should duplicate ids be matched? Either match just the "first" matching row, or match "all" matching rows. Defaults to "all" for compatibility with merge, but "first" is significantly faster.

vegf.demogs.match.first<-join(vegf.nodup, demogs, by="uds_id", type="left", match="first") #how should duplicate ids be matched? Either match just the "first" matching row, or match "all" matching rows. Defaults to "all" for compatibility with merge, but "first" is significantly faster.

#combine all three dataframes
vegf.demogs.apoe.left<-join(vegf.demogs.left, apoe.nodup, by="uds_id", type="left")
str(vegf.demogs.apoe.left)


#Change dates and check differences between them

#By default, the as.Date() function can easily convert character objects to date objects if the character objects are formatted in one of the following ways:
#%Y-%m-%d
#%Y/%m/%d

str(vegf.demogs.apoe.left$vitals_date)

vegf.demogs.apoe.left$vitals_date.dt <- as.Date(as.character(vegf.demogs.apoe.left$vitals_date), format = "%m-%d-%Y")
str(vegf.demogs.apoe.left$vitals_date.dt)
head(vegf.demogs.apoe.left$vitals_date.dt)

vegf.demogs.apoe.left$vitals_date.dt <- as.Date(as.character(vegf.demogs.apoe.left$vitals_date), format = "%Y/%m/%d")
str(vegf.demogs.apoe.left$vitals_date.dt)
head(vegf.demogs.apoe.left$vitals_date.dt)

vegf.demogs.apoe.left$vitals_date.dt <- as.Date(as.character(vegf.demogs.apoe.left$vitals_date), format = "%Y-%m-%d")
str(vegf.demogs.apoe.left$vitals_date.dt)
head(vegf.demogs.apoe.left$vitals_date.dt)

vegf.demogs.apoe.left$vegf.year.dt <- as.Date(as.character(vegf.demogs.apoe.left$year), format = "%Y-%m-%d")
str(vegf.demogs.apoe.left$vegf.year.dt)

vegf.demogs.apoe.left$vegf.year.dt <- as.Date(as.character(vegf.demogs.apoe.left$year), format = "%Y")
str(vegf.demogs.apoe.left$vegf.year.dt)


#Calculate date difference
vegf.demogs.apoe.left$demogs2vegf.dtdiff <- (vegf.demogs.apoe.left$vitals_date.dt) - (vegf.demogs.apoe.left$vegf.year.dt)
vegf.demogs.apoe.left$demogs2vegf.dtdiff

vegf.demogs.apoe.left$demogs2vegf.dtdiff2<- difftime(vegf.demogs.apoe.left$vitals_date.dt, vegf.demogs.apoe.left$vegf.year.dt,units ="weeks")
vegf.demogs.apoe.left$demogs2vegf.dtdiff2

vegf.demogs.apoe.left$demogs2vegf.dtdiff2<- difftime(vegf.demogs.apoe.left$vitals_date.dt, vegf.demogs.apoe.left$vegf.year.dt,units ="days")
vegf.demogs.apoe.left$demogs2vegf.dtdiff2

vegf.demogs.apoe.left$demogs2vegf.dtdiff2<- abs(difftime(vegf.demogs.apoe.left$vitals_date.dt, vegf.demogs.apoe.left$vegf.year.dt,units ="days"))
vegf.demogs.apoe.left$demogs2vegf.dtdiff2



#Calculate absolute difference
vegf.demogs.apoe.left$demogs2vegf.dtdiff.abs <- abs(vegf.demogs.apoe.left$demogs2vegf.dtdiff)
vegf.demogs.apoe.left$demogs2vegf.dtdiff.abs


#calculate age today
str(vegf.demogs.apoe.left)
str(vegf.demogs.apoe.left$vitals_dob)
vegf.demogs.apoe.left$vitals_dob.dt <-as.Date((vegf.demogs.apoe.left$vitals_dob), format = "%Y-%m-%d")
str(vegf.demogs.apoe.left$vitals_dob.dt)

vegf.demogs.apoe.left$age<- Sys.Date() - (vegf.demogs.apoe.left$vitals_dob.dt) 
vegf.demogs.apoe.left$age
vegf.demogs.apoe.left$age <- vegf.demogs.apoe.left$age/365.25
vegf.demogs.apoe.left$age
floor(vegf.demogs.apoe.left$age)
ceiling (vegf.demogs.apoe.left$age)
signif (vegf.demogs.apoe.left$age, digits=4)
round (vegf.demogs.apoe.left$age, digits=1)


   
#subset by demogs to vegf data less than 365 days

vegf.demogs.apoe.left.365 <-subset(vegf.demogs.apoe.left, demogs2vegf.dtdiff.abs > 365)

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
