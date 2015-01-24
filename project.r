require("caret")

setwd('C:/Coursera/Data Science - Specialization/Practical Machine Learning/project')

source('functions.R')

set.seed(32415)

#Read the training and the testing sets and perform the basic pre-processing
train = loadDataSet("pml-training.csv")
finaltest = loadDataSet("pml-testing.csv")

colsToRemove = c(1,2,3,4,5,6,7)

#  Perform prelimenary manual preProcessing  
train = transform(train, colsToRemove)
finaltest = transform(finaltest, colsToRemove)

inTrain = createDataPartition(y=train$classe, p=0.7, list=FALSE)

subTrain = train[inTrain,]
subTest = train[-inTrain,]

outcome = which(names(subTrain) %in% "classe")

noVariance = nearZeroVar(subTrain[,-outcome])

if(length(noVariance) > 0){
  subTrain = subTrain[,-noVariance]
  subTest = subTest[,-noVariance]
  finaltest = finaltest[,-noVariance]
}
outcome = which(names(subTrain) %in% "classe")

cr = cor(subTrain[,-outcome])
highlyCorVars <- findCorrelation(cr, cutoff = .75)

if( length(highlyCorVars) > 0 ){
  subTrain = subTrain[,-highlyCorVars]
  subTest = subTest[,-highlyCorVars]
  finaltest = finaltest[,-highlyCorVars]
}

forPlots = createDataPartition(y=subTrain$classe, p=0.1, list=FALSE)
subPlots = subTrain[forPlots,]
featurePlot(x=(log10(abs(subPlots[,c(1:7)])+1)), y=subPlots$classe, plot="pairs")
outcome = which(names(subTrain) %in% "classe")

PCAProc = preProcess(subTrain[,-outcome], method= c("pca"))

trainPCs = predict(PCAProc,     newdata = subTrain[,-outcome])
testPCs = predict(PCAProc,      newdata = subTest[,-outcome])
finaltestPCs = predict(PCAProc, newdata = finaltest[,-outcome])

## 10-fold CV ## repeated ten times
#fitControl = trainControl(method = "repeatedcv", number = 10, repeats = 10)

fitControl = trainControl(method = "oob", number = 2, verboseIter = TRUE)

useMethod = "rf";
m = train(subTrain$classe ~ ., method=useMethod, trControl= fitControl, data=trainPCs, verbose=TRUE)

confusionMatrix(subTest$classe, predict(m, newdata = testPCs))

answers = as.character(predict(m, newdata = finaltestPCs))

pml_write_files(answers, useMethod)
