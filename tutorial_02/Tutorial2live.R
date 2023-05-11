getwd()
setwd("/Volumes/GoogleDrive/My Drive/R_Scripts/Braskie_R_Workshop/")

#run previous scripts
source ("tutorial_01/scripts/tutorial1.R")

##view your data and understanding R 
ls() # list objects in the working environment
names(demogs) # list the variables in mydata
str(demogs) # list the structure of mydata
dim(demogs) # dimensions of an object
class(demogs) # class of an object (numeric, matrix, data frame, etc)
demogs # print mydata
head(demogs) #the head of the entire dataframe
tail(demogs)
head(demogs, n=15) #the head of the entire dataframe
demogs$SubjID[15] #the 10th subject
demogs$SubjID[10:15] #the 10-15th subjects
demogs$SubjID[c(10:15,20)]

demogs[demogs$SubjID==9095,] #look up why double equal
demogs[1:5,]
demogs[, 1]

demogs$Age..IDA.
unique(demogs$Age..IDA.) #check if there is a way to use this for duplicates
hist(demogs$Age..IDA.)
min(demogs$Age..IDA.)
max(demogs$Age..IDA.)

names(duplicated(demogs$Age..IDA.))
demogs[names(demogs$Age..IDA.)[!duplicated(names(demogs$Age..IDA.))]]

#check data structure
str(demogs)
demogs$Scan.Protocol <- as.factor(demogs$Scan.Protocol)
str(demogs)
demogs$Sex..IDA. <-as.factor(demogs$Sex..IDA.)
levels(demogs$Sex..IDA.)
demogs$Age..IDA. <- as.numeric(demogs$Age..IDA.)
str(demogs)
demogs$SubjID <-as.character(demogs$SubjID)
demogs$Scan.date <-as.Date(demogs$Scan.date,"%Y/%d/%m") #how does case/capitalization impact this?
help("as.Date") #getting help
demogs$Scan.Protocol <-as.ordered(demogs$Scan.Protocol)
levels(demogs$Scan.Protocol)
demogs$Scan.Protocol <- factor(demogs$Scan.Protocol, levels = c("Vida ADNI3", "Vida-1", "Skyra"))
str(demogs)

#Renaming columns 
demogs$Age <- demogs$Age..IDA. #create new column with the same data
str(demogs)
names(demogs)[names(demogs) == 'Age..IDA.'] <- "Age2" #rename the column 
demogs$Age2[5] <- "" #check why it doesnt remove column 
names(demogs)[4] <- "sex"
demogs <- demogs[ -c(5) ] #look into 
stru(demogs)

#recode 
library("dplyr")

levels(demogs$sex)
demogs$sex2 <-recode(demogs$sex, M = "Male", F = "Female", X = "NA") #check why this isnt working
str(demogs)

demogs$age.bin <- ifelse(demogs$Age >75, "old", "young")
demogs$sex2 <- ifelse(demogs$sex == "M", "Male", "Female")
help(ifelse)
str(demogs)

data.frame(colnames(demogs)) #number of column names

#subsetting
demogs <- subset(demogs, select = -c(age.bin) )
demogs <- demogs[ -c(6) ]
str(demogs)
keeps <- c("SubjID","Scan.date", "Age")
demogs.keep = demogs[keeps]

str(demogs)
females <-subset(demogs, sex=="F")
females.or.old <-subset(demogs, sex=="F" | Age > 77)
females.and.old <-subset(demogs, sex=="F" & Age > 77)

#new notes
= is assignment, == is a logical comparison

