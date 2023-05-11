getwd()

#run previous scripts
source ("Braskie_R_Workshop/tutorial_01/scripts/tutorial1.R")

#view your data and understanding R syntac
ls() # list objects in the working environment
names(demogs) # list the variables in mydata
str(demogs) # list the structure of mydata
dim(demogs) # dimensions of an object
class(demogs) # class of an object (numeric, matrix, data frame, etc)

demogs # print mydata
head(demogs) #the head of the entire dataframe
head(demogs, n=15) #the head of the entire dataframe

head(demogs$SubjID)# the head of jsut the column
tail(demogs$Sex..IDA.) # the tail of just the column 
demogs$Scan.date #pull just a column

demogs$SubjID[10] #the 10th subject
demogs$SubjID[10:15] #the 10-15th subjects
demogs$SubjID[c(10:15,20)]
demogs[demogs$SubjID==9024,]
demogs[1:5,]
demogs[, 1:2]

unique(demogs$Age)
names(duplicated(demogs$Age2))
demogs[names(demogs$Age2)[!duplicated(names(demogs$Age2))]]

duplicated(demogs$Age2)
demogs[duplicated(demogs$Age2)|duplicated(demogs$Age2, fromLast=TRUE),]
duplicates <-demogs[duplicated(demogs$SubjID)|duplicated(demogs$SubjID, fromLast=TRUE),]

#check date structure
str(demogs)
demogs$Scan.Protocol <- as.factor (demogs$Scan.Protocol)
levels(demogs$Scan.Protocol)
demogs$Sex..IDA. <-as.factor(demogs$Sex..IDA.)
levels(demogs$Sex..IDA.)
demogs$Scan.Protocol <-as.ordered
demogs$Age..IDA. <- as.numeric(demogs$Age..IDA.)
demogs$SubjID <-as.character(demogs$SubjID)
demogs$Scan.date <-as.Date(demogs$Scan.date,"%m/%d/%y")
help("as.Date") #getting help

#rename columns
demogs$Age <- demogs$Age..IDA.
str(demogs)
names(demogs)[names(demogs) == 'Age..IDA.'] <- "Age2"
names(demogs)
demogs$Age2 <- ""
names(demogs)
names(demogs)[4] <- "sex"
names(demogs)


#recode data
library("dplyr")
levels(demogs$sex)
demogs$sex2 <-recode(demogs$sex,"M==0;F==1;X=NA")
str(demogs$sex)

demogs$age.bin <- ifelse(demogs$Age >75, "old", "young")


#remove column 

#calculating time difference between two dates
today <- strftime(Sys.Date(),"%m/%d/20%y")
demogs$today <- matrix(today, ncol=1, nrow=2238)
str(demogs$today)
demogs$today <-as.Date(demogs$today,"%m/%d/%y")
str(demogs$today)
demogs$mri2today<-difftime(demogs$Scan.date, demogs$today, units = c("days"))

#division
demogs$mri2today <- demogs$mri2today/365

#absolute
demogs$mri2today <-abs(demogs$mri2today)
demogs$mri2today

#rounding
demogs$mri2today <-round(demogs$mri2today, digits=2)
demogs$mri2today 

#truncating
demogs$mri2today <-trunc(demogs$mri2today)
demogs$mri2today 

#scaling(z-score)
demogs$Age.scaled <-scale(demogs$Age2, center=TRUE)

#inversing (multiplying)
demogs$Age.scaled.inv <-demogs$Age.scaled*-1

#multiplying multiple columns
demogs$SubjID<-as.numeric(demogs$SubjID)
random <- demogs$SubjID*demogs$Age

#subsetting
young <-subset(demogs, age.bin=="young")
old.skyra <-subset(demogs, age.bin=="old"| Scan.Protocol=="Skyra")

#only keep complete cases
fdgstat<-main[!is.na(main$fdg.examdate), ] 

#determing which data to merge depending on scan date

#merging data based on 2 coluns (subject ID and scan date)
new_dataset <- dataset1 %>% right_join(dataset2, by=c("column1","column2"))


