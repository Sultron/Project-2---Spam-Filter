# Project-2 Spam-Filter
CS 482/682 - Artificial Intelligence

## Required Packages
In order to run the R scripts, the following packages needs to be installed
- tm 
- dplyer
- stringr
- caret

## How to train from a data file:
Rscript training.R spam.csv spamOutput.txt hamOutput.txt

where "spam.csv" is the name of the input file, "spamOutput.txt" is the output of the spam probability, and "hamOutput.txt" is the output of the ham probability

## How to classify from a data file:
 Rscript classify.R spam.csv classOutput.csv
 
 where "spam.csv" is the name of the input file and "classOuput.csv" is the name of the output file to store the result
 
 


