#######
## Building Machine Learning Models and Visualizing Confusion Matrices
## Conner Sexton
## January 5, 2020
#######
library(tm)
library(e1071)
library(SnowballC)
library(dplyr)
library(caret)

## Read in data:
load("data/project_data.RData")


## Data management required when building a model that uses text-based variables to predict:
# 1. convert party variable to factor:
project_data$party <- factor(project_data$party)

# 2. build a corpus using tm package:
df_corpus <- Corpus(VectorSource(project_data$text))

# 3. clean up corpus using tm_map:
corpus_clean <- tm_map(df_corpus, tolower) # set text to lower
corpus_clean <- tm_map(corpus_clean, removeNumbers) # remove numbers from text
corpus_clean <- tm_map(corpus_clean, removeWords, stopwords()) # remove stopwords
corpus_clean <- tm_map(corpus_clean, removePunctuation) # remove punct
corpus_clean <- tm_map(corpus_clean, stripWhitespace) # remove unnecessary white spaces

# 4. stem word variants (e.g. learning, learned, learnin)
corpus_clean <- tm_map(corpus_clean, stemDocument)

# 5. create document term matrix
party_dtm <- DocumentTermMatrix(corpus_clean)


## Create Naive Bayes Machine Learning Model:
## Model 1: Predicting Political Party
# create training and testing datasets (75/25 training/testing split)
party_dtm_train <- party_dtm[1:3750, ] # 75% of data in training
party_dtm_test <- party_dtm[3751:5000, ] # 25% of data in training

# collect labels of dependent variable (party affiliation)
party_train_labels <- project_data$party[1:3750] 
party_test_labels <- project_data$party[3751:5000]

# indicator feature for frequent words
party_freq_words <- findFreqTerms(party_dtm_train, 5)
# returns words that have appeared in at least 5 messages/emails

# subset training and testing datasets to only include these words...
party_dtm_freq_train <- party_dtm_train[, party_freq_words]
party_dtm_freq_test <- party_dtm_test[, party_freq_words]

# convert counts to a binary factor (required for Naive Bayes)
convert_counts <- function(x) {
  x <- ifelse(x > 0, 1, 0)
  x <- factor(x,
              levels = c(0,1),
              labels = c("No", "Yes"))
  return(x)
}

# apply convert_counts() to columns of the train/test data
party_train <- apply(party_dtm_freq_train, 2, convert_counts)
# when using the apply() function on matrices, 1 refers to rows, 2 refers to columns.
party_test <- apply(party_dtm_freq_test, 2, convert_counts)

# Run Model:
set.seed(1234)
party_classifier <- naiveBayes(party_train, party_train_labels, laplace = 1)

# evaluate performance of model
party_test_pred <- predict(party_classifier, party_test)

confusionMatrix(party_test_labels, party_test_pred, positive = "Democrat")


## Model 2: Predicting Gender
# convert party variable to factor
project_data$gender <- factor(project_data$gender)

# collect labels of dependent variable (gender)
gender_train_labels <- project_data$gender[1:3750] 
gender_test_labels <- project_data$gender[3751:5000]

# Run Model:
set.seed(1234)
gender_classifier <- naiveBayes(party_train, gender_train_labels, laplace = 1)

# evaluate performance of model
gender_test_pred <- predict(gender_classifier, party_test)

confusionMatrix(gender_test_labels, gender_test_pred, positive = "F")


#### Visualizing Confusion Matrices:
## Two Classes:

## with fourfoldplot function:
## Store confusion matrix in object ("cm.gender")
cm.gender <- confusionMatrix(gender_test_labels, gender_test_pred, positive = "F")

fourfoldplot(cm.gender$table, color = c("#CC6666", "#99CC99"),
             conf.level = 0, margin = 1, main = "Confusion Matrix")

## with draw_confusion_matrix() function:
draw_confusion_matrix(cm.gender, 2)

## with D3 chorddiag package:
# https://github.com/mattflor/chorddiag
# https://stats.stackexchange.com/questions/290889/what-is-the-best-way-of-graphical-or-visual-representation-of-confusion-matrix

library(chorddiag)

# create graph matrix:
cm.gender.d3 <- matrix(c(70, 200,
                         179, 801),
                       byrow = TRUE,
                       nrow = 2,
                       ncol = 2)
cm.gender.d3.names <- c("Female", "Male")
dimnames(cm.gender.d3) <- list(have = cm.gender.d3.names,
                               prefer = cm.gender.d3.names)

cm.gender.d3.colors <- c("#B79AE8", "#E8AC9A")
chorddiag(cm.gender.d3, 
          groupColors = cm.gender.d3.colors,
          groupnamePadding = 20,
          showTicks = F)



## Three Classes:

## Store confusion matrix in object ("cm.party")
cm.party <- confusionMatrix(party_test_labels, party_test_pred, positive = "Democrat")

## with draw_confusion_matrix() function:
draw_confusion_matrix(cm.party, 3)

## with D3 chorddiag package:
# https://github.com/mattflor/chorddiag
# https://stats.stackexchange.com/questions/290889/what-is-the-best-way-of-graphical-or-visual-representation-of-confusion-matrix

library(chorddiag)

# create graph matrix:
cm.party.d3 <- matrix(c(300, 37, 171,
                        3, 13, 4,
                        207, 42, 473),
                       byrow = TRUE,
                       nrow = 3,
                       ncol = 3)
cm.party.d3.names <- c("Democrat", "Independent", "Republican")
dimnames(cm.party.d3) <- list(have = cm.party.d3.names,
                               prefer = cm.party.d3.names)
# aquamarine4, coral2
cm.party.d3.colors <- c("#7FC5E5", "#A1E57F", "#E5867F")
chorddiag(cm.party.d3, 
          groupColors = cm.party.d3.colors,
          groupnamePadding = 20,
          showTicks = F)

