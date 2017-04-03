# Author : @ karan Jagota 

# loading libraries ...
library(data.table)
library(caret)

# reading files 
train = fread("train.csv")
test = fread("test.csv")

target <- train$Outcome
train$Outcome <- NULL
test_id<- test$ID

# feature engineering .. 
train <- subset(train,train$timestamp > 180)

train = train[,"timestamp":= timestamp%%7]
test = test[,"timestamp":= timestamp%%7]

train = train[,"ID":= NULL]
test = test[,"ID":=NULL]


# ---- model building ..........
fitControl <- trainControl(method = "repeatedcv", number = 10, repeats = 10)

set.seed(1178)
gbm_model <- train(as.factor(target) ~ ., data = train, method = "gbm", trControl = fitControl,verbose = FALSE)

pred <- predict(gbm_model,test,type="prob")[,2]

## submission
submit <- data.frame("ID"=test_id, "Outcome"=pred)
write.csv(submit, "gbm.csv", row.names=F)

