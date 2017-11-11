########################################
##### INTRODUCTION TO TEXT MINING ######
########################################

# URL: http://handsondatascience.com/TextMiningO.pdf

library(tm)           # framework for text mining
library(qdap)         # quantitative discourse analysis of transcripts
library(qdapDictionaries) 
library(dplyr)        # data wrangling, pipe operator %>%()
library(RColorBrewer) # generate palette of colours for plots.
library(ggplot2)      # plot word frequencies
library(scales)       # include commas in numbers
library(Rgraphviz)    # correlation plots

#obtain documentation on a particular package using the help option
library(help=rattle)

#converting the corpus to an appropiate format
system("for f in *.pdf; do pdftotext -enc ASCII7 -nopgbrk $f; done")
system("for f in *.doc; do antiword $f; done")

#corpus and sources
getSources()
getReaders()

#text documents within our document's path
cname <- file.path(".","corpus","txt")
cname
length(dir(cname))
dir(cname)

#creating the corpus
library(tm)
docs <- Corpus(DirSource(cname))
docs <- Corpus(DirSource(cname), readerControl=list(reader=readPDF)) #if you have the documents in pdf
docs <- Corpus(DirSource(cname), readerControl=list(reader=readDOC)) #if you have the documents in doc
docs
class(docs)
class(docs[[1]])
summary(docs)

#exploring the corpus
inspect(docs[16])
viewDocs <- function(d, n) {d %>% extract2(n) %>% as.character() %>% writeLines()}
viewDocs(docs, 16) #to read the document in the display

########################################
###### Pre-PROCESSING OF THE DATA ######
########################################

getTransformations()      #what transformations are available
tm_map()                  #is used to apply one of the transformations accross all the Corpus
content_transformer()

#simple transforms
toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x)) #custom transformations
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")
docs <- tm_map(docs, toSpace, "/|@|\\|")

#conversion to lower case
docs <- tm_map(docs, content_transformer(tolower))
#remove numbers
docs <- tm_map(docs, removeNumbers)
#remove punctuation
docs <- tm_map(docs, removePunctuation)
#remove english stop words
docs <- tm_map(docs,removeWords,stopwords("english"))
length(stopwords("english"))
#remove own stop words
docs <- tm_map(docs, removeWords, c("department", "email"))
#strip whitespace
docs<- tm_map(docs, stripWhitespace)
#specific transformations
toString <- content_transformer(function(x, from, to) gsub(from, to, x))
docs <- tm_map(docs, toString, "harbin institute technology", "HIT")
docs <- tm_map(docs, toString, "shenzhen institutes advanced technology", "SIAT")
docs <- tm_map(docs, toString, "chinese academy sciences", "CAS")
#stemming
docs <- tm_map(docs, stemDocument) #removes common words endings for English words

########################################
######### DOCUMENT TERM MATRIX #########
########################################

#frequency of words in each document
dtm<-DocumentTermMatrix(docs)
dtm                 #the sparsity is how many entries in the matrix are zeros
inspect(dtm[1:5,1000:1005])
class(dtm)          
dim(dtm)            #rows and columns of the dtm

tdm<-TermDocumentMatrix(docs) #the transpose of dtm

########################################
########## EXPLORING THE DTM ###########
########################################

freq <- colSums(as.matrix(dtm))
length(freq)
ord <- order(freq)            #ordering the frequencies
freq[head(ord)]               #least frequent terms
freq[tail(ord)]               #most frequent terms

########################################
### DISTRIBUTION OF TERM FREQUENCIES ###
########################################

head(table(freq),15)          #frequency of frequencies in the first 15 terms
tail(table(freq),15)

########################################
####### REMOVING SPARSE TERMS ##########
########################################

# Look again
dim(dtm)
dtms <- removeSparseTerms(dtm, 0.1)
inspect(dtms)
freq <- colSums(as.matrix(dtms))
freq

########################################
#### FREQUENT ITEMS & ASSOCIATIONS #####
########################################

findFreqTerms(dtm, lowfreq=1000)
findAssocs(dtm,"data",corlimit=0.6) #associations with a word (correlations)

########################################
########## CORRELATION PLOTS ###########
########################################

plot(dtm,terms=findFreqTerms(dtm, lowfreq=100)[1:50],corThreshold=0.5)

########################################
########## WORD FREQUENCIES ############
########################################

#generate the frequency count of alla words
freq <- sort(colSums(as.matrix(dtm)),decreasing = TRUE)
head(freq,14)
wf<-data.frame(word=names(freq),freq=freq)
head(wf)

#plot of thhose words that occur at least 500 times in the corpus
library(ggplot2)
subset(wf,freq>500)
ggplot(aes(word,freq))
geom_bar(stat="identity")
theme(axis.text.x=element_text(angle = 45,hjust = 1))

########################################
############# WORD CLOUDS ##############
########################################

library(wordcloud)
set.seed(123)
wordcloud(names(freq),freq,min.freq=40, rot.per = 0.2,
          max.words = 100, colors = brewer.pal(6,"Dark2"),scale = c(5,.1))

########################################
#### QUANTITATIVE ANALYSIS OF TEXT #####
########################################

# qdap package (Rinker, 2015)
words <-dtm
as.matrix
col.names(function(x) x[nchar(x)<20])

#summarise the word list
length(words)
head(words,15)

#word length counts: histogram of the word lengths
data.frame(nletters=nchar(words))
ggplot(aes(x=nletters))
geom_histogram(binwidth = 1)
geom_vline(xintercept = mean(nchar(words)),colour="green",size=1,alpha=.5)
labs(x="Number of Letters",y="Number of Words")

#letter frequency
library(dplyr)
library(stringr)

words
str_split("")
sapply(function(x) x[-1])
unlist
dist_tab
mutate(Letter=factor(toupper(interval),levels=toupper(interval[order(freq)])))
ggplot(aes(Letter,weight=percent))
geom_bar()
coord_flip()
labs(y="Proportion")
scale_y_continuous(breaks=seq(0,12,2),label=function(x) paste0(x,"%"),expand=c(0,0),limits=c(0,12))

#Letter and Position heatmap
words
lapply(function() sapply(letters,gregexpr,x,fixed=TRUE))
unlist
(function(x) x[x!=-1]) 
(function(x) setNames(x, gsub("\\d", "", names(x)))) 
(function(x) apply(table(data.frame(letter=toupper(names(x)),position=unname(x))),1, function(y) y/length(x))) 
qheat(high="green", low="yellow", by.column=NULL,values=TRUE, digits=3, plot=FALSE) 
labs(y="Letter", x="Position") 
theme(axis.text.x=element_text(angle=0))
guides(fill=guide_legend(title="Proportion"))

#gender of names
devtools::install_github("lmullen/gender-data-pkg")
name2sex(qcv(graham, frank, leslie, james, jacqui, jack, kerry, kerrie))

#word distances
install.packages("tmcn.word2vec", repos="http://R-Forge.R-project.org")
library(tmcn.word2vec)
model <- word2vec(system.file("examples","rfaq.txt",package="tmcn.word2vec"))
distance(model$model_file,"the")

#