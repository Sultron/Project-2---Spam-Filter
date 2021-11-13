# Project-2 Spam-Filter
CS 482/682 - Artificial Intelligence

### Training.R
Trains dataset from .csv file and save to new file.

### Classify.R
Classifies new data from training file and testing .csv file.


## Required Packages
In order to run the R scripts, the following packages needs to be installed
- tm 
- dplyer
- stringr
- caret

### Tip
A quick way to install the R packages is to prepend this to one of the R scripts  
`
install.packages("caret")
`\
`
install.packages("stringr")
`\
`
install.packages("dplyer")
`\
`
install.packages("tm")
`
## How to train from a data file:
Rscript training.R spam.csv spamOutput.txt hamOutput.txt

where "spam.csv" is the name of the input file, "spamOutput.txt" is the output of the spam probability, and "hamOutput.txt" is the output of the ham probability

## How to classify from a data file:
 Rscript classify.R spam.csv classOutput.csv
 
 where "spam.csv" is the name of the input file and "classOuput.csv" is the name of the output file to store the result
 
 


