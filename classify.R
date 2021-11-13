library(dplyr)
library(stringr)
library(caret)
library(tm)

set.seed(19)
args <- commandArgs(trailingOnly = TRUE)
#cat(args[1], sep = "\n")

data <- read.csv(args[1])


data <- select(data, v1, v2)

data$v1 <- as.character(data$v1)
data$v1 <- as.factor(data$v1)


data_corp <- Corpus(VectorSource(data$v2))

  dtm <- DocumentTermMatrix(x = data_corp,
                          control =
                          list(tokenize = "words",
                               stemming = "english",
                               weighting = weightTf,
                               tolower = TRUE,
                               removeNumbers = TRUE,
                               removePunctuation = TRUE,
                               stemming = TRUE,
                               stopwords = TRUE))

 tf <- as.data.frame.matrix(dtm)
 #dim(tf)
 term_freq <- colSums(tf)
freq <- data.frame(term = names(term_freq), count = term_freq)
arrange(freq, desc(count))[1:20,]

most_freq <- filter(freq, count >= 50)

tf <- select(tf, already,
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

data_tf <- mutate(tf, Class = data$v1, Msg = data$v2)
#dim(data_tf)

load("model.RData")


p <- predict(model, data_tf, type = "prob")


predictions <- factor(ifelse(p["ham"] > 0.4, #threshold
                              "ham",
                              "spam"))

msgs <- as.factor(data$v2)
glimpse(msgs)

d <- data.frame(predictions, msgs)

write.csv(d, file = args[2])

confusionMatrix(predictions, data_tf$Class)

