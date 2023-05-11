#set up working directory
getwd()
setwd("/Volumes/GoogleDrive/My Drive/R_Scripts/")
getwd()

#install packages
install.packages("plyr")
library(plyr)

#import files

a <- read.csv("Braskie_R_Workshop/tutorial_01/orig_files/df1_corticalthickness.csv")

df1 <- a
str(df1)
head(df1)
remove(a)

df2 <-read.csv("Braskie_R_Workshop/tutorial_01/orig_files/df2_corticalthickness.csv")
demogs <-read.csv("Braskie_R_Workshop/tutorial_01/orig_files/demogs_fordf1df2.csv")

df3 <-rbind(df1, df2)

#Check if column names match in new and old dataset before binding subjects together
install.packages("janitor")
library(janitor)
compare_df_cols(df1, demogs)

#cbind
y1 <- as.data.frame(matrix(10, ncol=2, nrow=100))
y2 <- cbind(df3, y1)
str(y2)

#joining files
str(df3)
str(demogs)
df.merge <- join(df3, demogs, by="SubjID", type="left") #
str(df.merge)
df.merge.right <- join(df3, demogs, by="SubjID", type="right")
df.merge.full <- join(df3, demogs, by="SubjID", type="full")

#write csv file 
write.csv(df.merge, file="Braskie_R_Workshop/tutorial_01/output/df.merge.csv")


