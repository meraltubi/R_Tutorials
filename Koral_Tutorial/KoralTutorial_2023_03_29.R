#R Tutorial by Koral Wheeler
#Data Wrangling part 2
#3/29/2023

setwd("Koral_Tutorial/")
demographics_df<-read.csv("demog_data.csv")
neuropsych_df<-read.csv("neuropsych.csv")
CSF_biomarkers<-read.csv("UPENNBIOMK10_07_29_19.csv")
vitals<-read.csv("vitals.csv")
meds<-read.csv("meds.csv")

demographics_df$PTDOBYYMD <-paste(demographics_df$PTDOBYY, "-", demographics_df$PTDOBMM, "-", demographics_df$PTDOBDD)

demographics_df$PTDOBMDYY<-paste(demographics_df$PTDOBMM, "-", demographics_df$PTDOBDD, "-", demographics_df$PTDOBYY)
str(demographics_df)

install.packages("tidyverse")
library(tidyverse)

library(lubridate)

demographics_df$PTDOBYYMD<-ymd(demographics_df$PTDOBYYMD)
str(demographics_df$PTDOBYYMD)
demographics_df$PTDOBMDYY<-mdy(demographics_df$PTDOBMDYY)
str(demographics_df$PTDOBMDYY)
today()
now()

demographics_df$estimated_age_years <-interval(demographics_df$PTDOBYYMD, demographics_df$USERDATE) %/% years(1)
demographics_df$estimated_age_months <-interval(demographics_df$PTDOBYYMD, demographics_df$USERDATE) %/% months(1)

demographics_df$currentage<-interval(demographics_df$PTDOBYYMD, today()) %/% years(1)

month(today())
month(today(), label=TRUE)
mday(today())

demographics_df$this_year<-year(today())

install.packages("stringr")
library(stringr)
neuropsych_df[c('Time Interval Prefix', "Number of Months")]<-str_split_fixed(neuropsych_df$VISCODE2, "", 3)
neuropsych_df
neuropsych_df[c('EXAMYEAR', 'EXAMMONTH', 'EXAMDAY')]<-str_split_fixed(neuropsych_df$)

library(dplyr)

CSF_biomarkers.asc_sorted<-CSF_biomarkers%>% arrange(RID, DRAWDATE)
CSF_biomarkers.asc_drop<-CSF_biomarkers.asc_sorted[!duplicated(CSF_biomarkers.asc_sorted$RID),]
CSF_biomarkers.desc_sorted<-CSF_biomarkers %>% arrange (RID, desc(DRAWDATE))
CSF_biomarkers.desc_drop<-CSF_biomarkers.desc_sorted[!duplicated(CSF_biomarkers.desc_sorted$RID),]

#grep

aspirin_subset<-meds[grep("aspir", meds$CMMED, ignore.case=TRUE),]


demographics_df$Education_cateory<-ifelse(demographics_df$PTEDUCAT>=16, 1, 0)
demographics_df$Education_cateory_label<-ifelse(demographics_df$PTEDUCAT>=16, "high", "low")

demographics_df$Education_cateory_threelevels<-ifelse(demographics_df$PTEDUCAT>=16, "high", ifelse(demographics_df$PTEDUCAT>=1 & demographics_df$PTEDUCAT<12, "low", "middle"))

demographics_df$recoded_education<-case_when(
                      demographics_df$PTEDUCAT>=16~1, 
                      demographics_df$PTEDUCAT<16~0)

vitals<-vitals %>%mutate(height_inches=case_when(
  VSHTUNIT==1 ~ VSHEIGHT, 
  VSHTUNIT==2 ~ VSHEIGHT/2.54))
))

vitals<-vitals %>%mutate(weight_lbs=case_when(
                VSWTUNIT==1 ~ VSWEIGHT, 
                VSWTUNIT==2 ~ VSWEIGHT*2.205))
))
