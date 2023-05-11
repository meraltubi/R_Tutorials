df = read.csv("/Users/joshualiu/Downloads//WHIMS_CorticalMeasures_ThickAvg_MICED - Sheet1.csv")

#### FOR LOOPS

# print every value in a column
for (ID in df$Subject_ID) {
  print(ID)
}

# print the names of each column
for (column in colnames(df)) {
  print(column)
}

# print every row in df
for (row in 1:nrow(df)) {
  print(df[row, ])
}

# print the ID and L_bankssts_thick avg value based on a conditional statement
for (row in 1:nrow(df)) {
  if (df$L_bankssts_thickavg[row] < 1.6) {
    #print(df$Subject_ID[row] + df$L_bankssts_thickavg[row])
    cat("ID:", df$Subject_ID[row], "Thick value:", df$L_bankssts_thickavg[row], "\n")
  }
  else {
    print(".")
  }
}


# create a new column with values of that column being the sum of three other columns
rois <- list("bankssts","caudalanteriorcingulate","caudalmiddlefrontal")
df$left_roi_sum = 0
for (roi in rois) {
  left <- paste0("L_", roi, "_thickavg")
  df$left_roi_sum <- df$left_roi_sum + df[[left]]
}
print(df$left_roi_sum)


#### WHILE LOOPS

df <- df[order(df$left_roi_sum),]

# iterate through each value in left_roi_sum and print the Subject_ID and the thickness value until those values are >= 4.9
counter <- 1
while (counter <= nrow(df)) {
  value <- df[counter, "left_roi_sum"]
  if (value < 4.9) {
    cat(df[counter, "Subject_ID"], value, "\n")
  }
  counter <- counter + 1
}

# ifelse function
df$Sex <- ifelse(df$Sex == 'M', 0, 1)






