## Set up working directory
getwd() #check where your current working directory is
setwd("/Volumes/GoogleDrive/My Drive/R_Scripts/Braskie_R_Workshop/Tutorial_01_02_combined/") #input correct path
getwd() #verify the directory is

## Install Packages
install.packages("openxlsx")
library(openxlsx)

## Import files
demogs <- read.csv("VascularCohortStudy-VitalsAll_DATA_2023-03-14_1440.csv")
apoe <-read.csv("VascularCohortStudy-ApoEAll_DATA_2023-03-14_1506.csv")
vegf<-read.xlsx("ADRC_VEGF data_12-16-21FIN.xlsx")
options(digits = 2)

## Check File Structure and column header of subject ids - The goal is  that We want all this data in the same dataframe

str(demogs)
str(apoe)
table(apoe$apoe)
str(vegf) 

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
vegf.dups <-vegf[duplicated(vegf$uds_id),] #identifies which are the problem subjects
vegf[1,] #row 1
vegf[, 1] #column 1
duplicated(vegf)

vegf.dups <-vegf[duplicated(vegf$uds_id),] #identifies which are the problem subjects
vegf.nodup<- vegf[!duplicated(vegf$uds_id),] #NOT Operator “!”
apoe.nodup<- apoe[!duplicated(apoe$uds_id),] 
demogs.nodup<- demogs[!duplicated(demogs$uds_id),] 

#complete cases
demogs.complete <- demogs.nodup[complete.cases(demogs.nodup),]#remove rows with missing values in any 
demogs.complete2 <- demogs.nodup[complete.cases(demogs.nodup[ , c('vitals_gender', 'vitals_dob')]), ] #remove rows with NA in specific columns of data frame

hist(demogs$vitals_weight)

#remove row based on condition
demogs.nodup.999 <- demogs.complete2[demogs.complete2$vitals_weight != -999, ]     
demogs.nodup.999 <- demogs.complete2[demogs.complete2$vitals_weight != -999 & demogs.complete2$vitals_pulse != -999, ]    

#join the dataframes based on VEGF data (unique)
library("plyr")
vegf.demogs.left<-join(vegf.nodup, demogs.nodup, by="uds_id", type="left") #left: all rows in x, adding matching columns from y
vegf.demogs.right<-join(vegf.nodup, demogs.nodup, by="uds_id", type="right") #right: all rows in y, adding matching columns from x
vegf.demogs.full<-join(vegf.nodup, demogs.nodup, by="uds_id", type="full") #full: all rows in x with matching columns in y, then the rows of y that don't match x.
vegf.demogs.inner<-join(vegf.nodup, demogs.nodup, by="uds_id", type="inner") #inner: only rows with matching keys in both x and y

vegf.demogs.match.all<-join(vegf.nodup, demogs, by="uds_id", type="left", match="all") #how should duplicate ids be matched? Either match just the "first" matching row, or match "all" matching rows. Defaults to "all" for compatibility with merge, but "first" is significantly faster.

vegf.demogs.match.first<-join(vegf.nodup, demogs, by="uds_id", type="left", match="first") #how should duplicate ids be matched? Either match just the "first" matching row, or match "all" matching rows. Defaults to "all" for compatibility with merge, but "first" is significantly faster.

#combine all three dataframes
vegf.demogs.apoe.left<-join(vegf.demogs.left, apoe.nodup, by="uds_id", type="left")
str(vegf.demogs.apoe.left)

#Change dates and check differences between them
str(vegf.demogs.apoe.left$vitals_date)
vegf.demogs.apoe.left$vitals_date.dt <- as.Date((vegf.demogs.apoe.left$vitals_date), format = "%Y")
str(vegf.demogs.apoe.left$vitals_date.dt)
head(vegf.demogs.apoe.left$vitals_date.dt)

vegf.demogs.apoe.left$vitals_date.dt <- as.Date(as.character(vegf.demogs.apoe.left$vitals_date), format = "%Y-%m-%d")
vegf.demogs.apoe.left$vitals_date.dt

str(vegf.demogs.apoe.left$year)
vegf.demogs.apoe.left$vegf.year.dt <- as.Date(as.character(vegf.demogs.apoe.left$year), format = "%Y")
str(vegf.demogs.apoe.left$vegf.year.dt)


#Calculate date difference
vegf.demogs.apoe.left$demogs2vegf.dtdiff <- (vegf.demogs.apoe.left$vitals_date.dt) - (vegf.demogs.apoe.left$vegf.year.dt)
vegf.demogs.apoe.left$demogs2vegf.dtdiff

vegf.demogs.apoe.left$demogs2vegf.dtdiff2<- difftime(vegf.demogs.apoe.left$vitals_date.dt, vegf.demogs.apoe.left$vegf.year.dt,units ="weeks")
vegf.demogs.apoe.left$demogs2vegf.dtdiff2

vegf.demogs.apoe.left$demogs2vegf.dtdiff2<- difftime(vegf.demogs.apoe.left$vitals_date.dt, vegf.demogs.apoe.left$vegf.year.dt,units ="days")
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

Sys.Date()
