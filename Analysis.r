# Changing working directory to where the files reside
setwd("C:/Users/kanishk/Desktop/Data analytics projects/Cyclistic/Original data(.csv)")

# Loading required packages
library(tidyverse)
library(lubridate)
library(ggplot2)
library(xlsx)

# importing data
file_names <- dir()
df <- do.call(rbind, lapply(file_names, read.csv))

# DATA WRANGLING

# removing redundant columns
df <- df %>%
  select(-c(start_lat, start_lng, end_lat, end_lng))

# to check if the column member_casual contains only 2 expected values
dfgb <- df %>%
  group_by(member_casual) %>%
  count()


# Splitting started_at column to identify trends on weekdays and seasons
df$date <- as.Date(df$started_at)
df$month <- format(as.Date(df$date), "%m")
df$day <- format(as.Date(df$date), "%d")
df$year <- format(as.Date(df$date), "%Y")
df$day_of_week <- format(as.Date(df$date), "%A")

# adding new column to calculate ride duration
df$ride_length <- difftime(df$ended_at, df$started_at)

# # converting ride_length from factor to numeric to run calculations
df$ride_length <- as.numeric(as.character(df$ride_length))
# 
# # removing negative ride_length values due to maintenance
df_v2<-filter(df, ride_length>0)
# 
# # descriptive analysis on ride_length(in seconds)
summary(df_v2$ride_length)

# comparing all members and casual members
mean_ridel <- aggregate(df_v2$ride_length ~ df_v2$member_casual, FUN=mean)
median_ridel <- aggregate(df_v2$ride_length ~ df_v2$member_casual, FUN=median)
max_ridel <- aggregate(df_v2$ride_length ~ df_v2$member_casual, FUN=max)
min_ridel <- aggregate(df_v2$ride_length ~ df_v2$member_casual, FUN=min)

# comparing memebers against each weekday
df_v2$day_of_week <- ordered(df_v2$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))
mean_wkd <- aggregate(df_v2$ride_length ~ df_v2$member_casual + df_v2$day_of_week, FUN=mean)

#analyze ridership data by type and weekday
agg_wkd <- df_v2 %>%
  mutate(weekday=wday(date, label=TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n(), average_duration = mean(ride_length)) %>%
  arrange(member_casual, weekday)

as.data.frame(agg_wkd)
# visualizing number of rides against rider type
df_v2 %>%
  mutate(weekday=wday(date, label=TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n(), average_duration = mean(ride_length)) %>%
  arrange(member_casual, weekday) %>%
  ggplot(aes(x=weekday, y=number_of_rides, fill=member_casual)) + geom_col(position="dodge") + labs(title="ride length comparison for each member on weekdays")

# viz for avg rides
df_v2 %>%
  mutate(weekday=wday(date, label=TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n(), average_duration = mean(ride_length)) %>%
  arrange(member_casual, weekday) %>%
  ggplot(aes(x=weekday, y=average_duration, fill=member_casual)) + geom_col(position="dodge") + labs(title="AVG ride length comparison for each member on weekdays")

write.xlsx(mean_ridel, file="Analyzed_data.xlsx", sheetName = "mean_ridelen", row.names=FALSE)
write.xlsx(max_ridel, file="Analyzed_data.xlsx", sheetName = "max_ridelen", append=TRUE, row.names=FALSE)
write.xlsx(min_ridel, file="Analyzed_data.xlsx", sheetName = "min_ridelen", append=TRUE, row.names=FALSE)
write.xlsx(median_ridel, file="Analyzed_data.xlsx", sheetName = "median_ridelen", append=TRUE, row.names=FALSE)
write.xlsx(as.data.frame(agg_wkd), file = "Analyzed_data.xlsx", append=TRUE, col.names = TRUE, row.names=FALSE)
