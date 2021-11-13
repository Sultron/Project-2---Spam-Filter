library(tm)
library(dplyr)
library(stringr)
library(caret)

args <- commandArgs(trailingOnly = TRUE) #get filenames from the command arguments
#cat(args[1], sep = "\n")

set.seed(19) #set seed for random generating test data

data <- read.csv(args[1]) #load the spam file


data <- select(data, v1, v2) #select the columns v1, and v2

data$v1 <- as.character(data$v1) #convert column v1 as a character vector

data$v1 <- as.factor(data$v1) #convert column v1 to factor


applydtm <- function (data_crop) {

  data_crop <- Corpus(VectorSource(data_crop))
  dtm <- DocumentTermMatrix(data_crop,
                          control =
                          list(tokenize = "words", #bag of words
                               stemming = "english",
                               weighting = weightTf,
                               tolower = TRUE,
                               removeNumbers = TRUE,
                               removePunctuation = TRUE,
                               stemming = TRUE,
                               stopwords = TRUE))

    return(dtm)
}

writeFile <- function (filename, term_freq) {

  freq <- data.frame(term = names(term_freq), count = term_freq)
arrange(freq, desc(count))[1:20,]
paste(sum(freq$count))
writeLines(c("Total:", sum(freq$count)), filename)

write.table(freq, filename, append = TRUE, sep = " ", dec = ".",
            row.names = TRUE, col.names = TRUE)

}

data_corp <- Corpus(VectorSource(data$v2))

reverse_sms <- data.frame(v2 = sapply(data_corp, as.character), v1 = data$v1)

spam <- subset(reverse_sms, v1 == "spam")

ham <- subset(reverse_sms, v1 == "ham")


dtm_spam <- applydtm(spam$v2)
dtm_ham <- applydtm(ham$v2)

dtm_total <- applydtm(data$v2)


tf_spam <- as.data.frame.matrix(dtm_spam)
tf_ham <- as.data.frame.matrix(dtm_ham)
tf_total <- as.data.frame.matrix(dtm_total)

spam_term_freq <- colSums(tf_spam)
ham_term_freq <- colSums(tf_ham)
total_term_freq <- colSums(tf_total)


writeFile(args[2], spam_term_freq)
writeFile(args[3], ham_term_freq)

tf_total <- select(tf_total, already,
             also,
             always,
             amp,
             anything,
             around,
             ask,
             babe,
             back,
             box,
             buy,
             call,
             can,
             cant,
             care,
             cash,
             chat,
             claim,
             come,
             coming,
             contact,
             cos,
             customer,
             day,
             dear,
             didnt,
             dont,
             dun,
             even,
             every,
             feel,
             find,
             first,
             free,
             friends,
             get,
             getting,
             give,
             going,
             gonna,
             good,
             got,
             great,
             guaranteed,
             gud,
             happy,
             help,
             hey,
             home,
             hope,
             ill,
             ive,
             just,
             keep,
             know,
             last,
             late,
             later,
             leave,
             let,
             life,
             like,
             lol,
             lor,
             love,
             ltgt,
             make,
             many,
             meet,
             message,
             mins,
             miss,
             mobile,
             money,
             morning,
             msg,
             much,
             name,
             need,
             new,
             nice,
             night,
             nokia,
             now,
             number,
             one,
             people,
             per,
             phone,
             pick,
             place,
             please,
             pls,
             prize,
             really,
             reply,
             right,
             said,
             say,
             see,
             send,
             sent,
             service,
             sleep,
             someone,
             something,
             soon,
             sorry,
             still,
             stop,
             sure,
             take,
             tell,
             text,
             thanks,
             thats,
             thing,
             things,
             think,
             thk,
             time,
             today,
             told,
             tomorrow,
             tonight,
             txt,
             urgent,
             wait,
             waiting,
             wan,
             want,
             wat,
             way,
             week,
             well,
             went,
             will,
             win,
             wish,
             won,
             wont,
             work,
             yeah,
             year,
             yes,
             yet,
             youre)

data_tf <- mutate(tf_total, Class = data$v1)

trainIndex <- createDataPartition(data_tf$Class,
                                  times = 1,
                                  p = 0.8,
                                  list = FALSE)

train <- data_tf[trainIndex, ]

model <- train(Class ~ .,
               data = train,
               method = "glm",
               trControl = trainControl(method = "cv",
                                        number = 10)
               )

varImp(model)
save(model, file = "model.RData") #save this model to use when classifying





