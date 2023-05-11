#R Tutorial Part 3 - Tidyverse to datawrangle ADRC Data

getwd()
setwd("/Volumes/GoogleDrive/My Drive/R_Scripts/Braskie_R_Workshop")
#import previously generated code
source("Tutorial_01_02_combined/Tutorial_01_02_combined_VEGFADRC_LIVE.R")

#dplyr cheatsheet = https://github.com/rstudio/cheatsheets/blob/main/data-transformation.pdf

#mutate() adds new variables that are functions of existing variables
#select() picks variables based on their names
#filter() picks cases based on their values.
#summarise() reduces multiple values down to a single summary.

#rename dataframe we are working with
df.adrc <-vegf.demogs.apoe.left
str(df.adrc)

###########################################################################
#DESCRIBING/SUMMARIZING  DATA
#############################################

#base R package
summary(df.adrc)
by(df.adrc, df.adrc$vitals_gender, summary)

#hmisc Package
library(Hmisc)
describe(df.adrc)
plot(df.adrc)

#pastecs package
install.packages("pastecs")
library(pastecs)
stat.desc(df.adrc)

#psych package
install.packages("psych")
library(psych)
df.adrc.summarybysex <-describeBy(df.adrc, df.adrc$vitals_gender)
df.adrc.summarybysex.bind<-do.call("rbind",df.adrc.summarybysex)
write.csv(df.adrc.summarybysex.bind,  file="df.adrc.summarybysex.csv")


#tidyverse -dplyr
library(tidyverse)


"Tibbles are data. frames that are lazy and surly: they do less (i.e. they don't change variable names or types, and don't do partial matching) and complain more (e.g. when a variable does not exist). This forces you to confront problems earlier, typically leading to cleaner, more expressive code."
  
#tibble
tibble(df.adrc)


#Select 
names(df.adrc) <-  make.unique(dput(names(df.adrc)))

df.adrc<-df.adrc %>% 
  select(c("uds_id", "year", "VEGF-A", "VEGF-B", "redcap_event_name", 
           "vitals_conducted", "vitals_conducted_rsn", "vitals_date", "vitals_time", 
           "vitals_dob", "vitals_age", "vitals_gender", "vitals_weight", 
           "vitals_height", "vitals_bp", "vitals_bp_systolic", "vitals_bp_diastolic", 
           "vitals_pulse", "vitals_misc", "vitals_tracking_form_complete", 
          "apoe_conducted", "apoe_conducted_rsn", 
           "apoe", "apoe_complete", "vitals_date.dt", "vegf.year.dt", "demogs2vegf.dtdiff", 
           "demogs2vegf.dtdiff2", "demogs2vegf.dtdiff.abs", "vitals_dob.dt", 
           "age"))

#tibble
tibble(df.adrc)

#summarize all
df.adrc.minmax<-df.adrc %>%
  summarise(across(everything(), list(min = min, max = max)))


df.adrc.minmax<-df.adrc %>%
  group_by(vitals_gender) %>%
  summarise(across(everything(), list(min = min, max = max)))

#group_by 
df.adrc.apoe<-df.adrc %>%
  group_by(apoe)  %>% 
  summarise(n=n()) 

df.adrc.apoe
#groupby summarize multiple functions
df.adrc.sex<-df.adrc %>%
  group_by(vitals_gender)  %>% 
  summarise(n=n(), mean_age=mean(vitals_age, na.rm = TRUE), vegfa_mean=mean(`VEGF-A`, na.rm = TRUE),) 

tibble(df.adrc.sex)
write.csv(df.adrc.sex,  file="df.adrc.sex.csv")

#filter
df.adrc.female <- df.adrc %>% 
  filter(vitals_gender == "2") %>%
   summarise(vegfa_mean=mean(`VEGF-A`, na.rm = TRUE),  correlation = cor(vitals_age, `VEGF-A`))

tibble(df.adrc.female)

#split groups

df.adrc.gender.nest <- df.adrc %>% group_by(vitals_gender) %>% 
  nest()

df.adrc.apoe.nest <- df.adrc %>% group_by(apoe) %>% 
  nest()

#run linear model
df.adrc.nestmodel <- df.adrc.apoe.nest %>% 
  mutate(model = map(data, function(df) lm(vitals_weight ~ age, data = df))) 


#tidy the model
df.adrc.nestmodel <- df.adrc.apoe.nest %>% 
  mutate(model = map(data, function(df) lm(vitals_weight ~ age, data = df)), tidied=map(model, tidy)) 

#untidy the data so you can see all
df.adrc.nestmodel <- df.adrc.apoe.nest %>% 
  mutate(model = map(data, function(df) lm(vitals_weight ~ age, data = df)), tidied=map(model, tidy)) %>%
  unnest(tidied)



glance(df.adrc.nestmodel)















# Manipulate Cases



# Distinct
# Across

#joins
#anti-join
 #Column matching for joins





##############################################
#tidry 
#cheat sheet = https://github.com/rstudio/cheatsheets/blob/main/tidyr.pdf

#

#Reshape Data
#Split Data
#Expand Tables
#Handle Missing Values
#Nested Data


#purr cheat sheet - https://github.com/rstudio/cheatsheets/blob/main/purrr.pdf


