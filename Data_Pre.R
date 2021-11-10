data<-read.csv('airline.csv')
data.copy<-data
data<-data[c('cabin_flown','seat_comfort_rating','cabin_staff_rating',
             'food_beverages_rating','inflight_entertainment_rating',
             'ground_service_rating','wifi_connectivity_rating',
             'value_money_rating','overall_rating','recommended')]
data[data==""] <- NA
data <- na.omit(data)
data<-data[data['recommended']!=4,]
recommended = as.factor(data$recommended)
data$recommended=recommended
data$seat_comfort_rating <- as.numeric(data$seat_comfort_rating) 
data$cabin_staff_rating <- as.numeric(data$cabin_staff_rating) 
data$food_beverages_rating <- as.numeric(data$food_beverages_rating) 
data$inflight_entertainment_rating <- as.numeric(data$inflight_entertainment_rating) 
data$ground_service_rating <- as.numeric(data$ground_service_rating) 
data$wifi_connectivity_rating<- as.numeric(data$wifi_connectivity_rating) 
data$value_money_rating <- as.numeric(data$value_money_rating) 
data$overall_rating <- as.numeric(data$overall_rating) 
row.names(data) <- NULL  ##re-order
str(data)
write.csv(data,"DT_R.csv", quote = FALSE, row.names = FALSE)

