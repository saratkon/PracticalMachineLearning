#Function to create text files for the predictions
pml_write_files = function(x, model){
  n = length(x)
  for(i in 1:n){
    filename = paste0(model,"_problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

#
# Function to transform the variables into a suitable format for the data modelling
# Arguments:
#             dataset : the dataset on whih the transformations need to be performed
#        colsToRemove : The columns numbers to be removed directly
#
transform = function(dataset, colsToRemove){
  
  # Remove the index column, timestamps part1 and part2 and the 2 window variables
  dataset = dataset[, -colsToRemove]
  #dataset = dataset[,-c(1,3,4,6,7)]
  
  # Remove all columns that have NAs in them
  colsWithNAs <- apply(dataset, 2, function(x){any(is.na(x) | x == 'NA')})
  dataset = dataset[,!colsWithNAs]
  
  # Convert the name from a factor into a numeric
  #dataset$user_name = as.numeric(dataset$user_name)
  
  # Convert the time stamp from a factor into a numeric
  #dataset$cvtd_timestamp = as.numeric(as.POSIXct(dataset$cvtd_timestamp))
  
  #dataset$new_window = as.numeric(dataset$new_window)
  dataset
}

#function for some manual preprocessings
loadDataSet = function(csvfile){
  
  data = read.csv(csvfile, na.strings=c("#DIV/0!"))  
  
  data
}