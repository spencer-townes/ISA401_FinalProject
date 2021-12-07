# ---------------------------
# Libraries
# ---------------------------
pacman::p_load(tidyverse, magrittr, tidyquant, dplyr)

# ---------------------------
# Reading the CSVs
# ---------------------------

# Setting the working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

income = read.csv("project_income.csv")

fastfood = read.csv("project_FastFoodRestaurants.csv")

# View(income)

crime = read.csv("project_CrimeData.csv")

# View(crime)

# ---------------------------
# Cleaning the Data
# ---------------------------

#Restaurant website key removed
fastfood <- select(fastfood, -c(4, 10))
fastfood$name <- str_to_title(fastfood$name)
View(fastfood)

# Remove the kaggle header column
income2 <- select(income, -c(1))
View(income2)

crime$county_name <- as.character(crime$county_name)

# Split the count name column
crime$state <- substr(crime$county_name, nchar(crime$county_name)-1, nchar(crime$county_name))
crime$county <- substr(crime$county_name, 0, nchar(crime$county_name)-4)
# Fix the county capitalization
crime$county <- str_to_title(crime$county)
View(crime)

# Fix County Capitalization: str_to_title(str)



# ---------------------------
# Combining the Data
# ---------------------------

# Combine income and fastfood
dataset <- merge(income2, 
                    fastfood, 
                    by.x=c("City", "State_ab"),
                    by.y=c("city", "province"))

dataset2 <- distinct(dataset, address, .keep_all = TRUE)
View(dataset2)
nrow(dataset2)

# Combine the new dataset with crime
dataset3 <- merge(dataset2, 
                  crime, 
                  by.x=c("State_ab", "County"),
                  by.y=c("state", "county"))

View(dataset3)

# ---------------------------
# Exporting the Data
# ---------------------------

write.csv(crime,"project_crime.csv", row.names = FALSE)
#write.csv(income2,"project_Finalincome.csv", row.names = FALSE)
#write.csv(fastfood,"project_Finalfastfood.csv", row.names = FALSE)
write.csv(dataset3,"project_dataset_final.csv", row.names = FALSE)
