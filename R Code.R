# Set working directory
dir <- "C:\\mallet" # adjust to suit
setwd(dir)

# configure variables and filenames for MALLET
## here using MALLET's built-in example data and
## variables from http://programminghistorian.org/lessons/topic-modeling-and-mallet

# folder containing txt files for MALLET to work on
importdir <- "C:\\mallet\\mallet-data"
importfile <- "C:\\mallet\\mallet-data\\SurveyVerbat.txt"

# name of file for MALLET to train model on
output <- "tutorial1.mallet"
# set number of topics for MALLET to use
ntopics <- 10
# set optimisation interval for MALLET to use
optint <- 10
# set file names for output of model, extensions must be as shown
outputstate <- "surveyverbatim.gz"
outputtopickeys <- "surveyverbatim_keys1.txt"
outputdoctopics <- "surveyverbatim_composition1.txt"
# combine variables into strings ready for windows command line
cd <- "cd C:\\mallet" # location of the bin directory
javapath <- "SET PATH=c:\\Program Files\\java\\jre7\\bin"
import <- paste("bin\\mallet import-file --input", importfile, "--output", output, "--keep-sequence --remove-stopwords", sep = " ")
train <- paste("bin\\mallet train-topics --input", output, "--num-topics", ntopics, "--optimize-interval", optint, "--output-state", outputstate, "--output-topic-keys", outputtopickeys, "--output-doc-topics", outputdoctopics, sep = " ")

# setup system enviroment for R
MALLET_HOME <- "c:/mallet" # location of the bin directory
Sys.setenv("MALLET_HOME" = MALLET_HOME)
Sys.setenv(PATH = "C:/Program Files/Java/jre7/bin")

echojavapath <- "ECHO %PATH%"

shell(shQuote(paste(javapath, cd, import, train, sep = " && ")),      invisible = FALSE)


# inspect results
setwd(MALLET_HOME)
# outputstateresult <-
outputtopickeysresult <- read.table(outputtopickeys, header=F, sep="\t")
outputdoctopicsresult <-read.table(outputdoctopics, header=F, sep="\t")

# manipulate outputdoctopicsresult to be more useful
dat <- outputdoctopicsresult
l_dat <- reshape(dat, idvar=1:2, varying=list(topics=colnames(dat[,seq(3, ncol(dat)-1, 2)]),
                                              props=colnames(dat[,seq(4, ncol(dat), 2)])),
                 direction="long")
library(reshape2)
w_dat <- dcast(l_dat, V2 ~ V3)
rm(l_dat) # because this is very big but not longer needed

# write reshaped table to CSV file for closer inspection
write.csv(w_dat, "topic_model_table.csv")
# find the location of that CSV file
# should pop open a window of the folder
# where the CSV is
shell.exec(getwd())