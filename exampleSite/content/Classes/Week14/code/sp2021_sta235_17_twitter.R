# Clears memory
rm(list = ls())
# Clears console
cat("\014")


### Code for reviews of banana slicer

library(tidyverse)
library(tidytext)
library(rvest)
library(wordcloud)

## Function that will scrape data!

scrape_amazon <- function(ASIN, page_num){ #Write our own function (source: https://martinctc.github.io/blog/vignette-scraping-amazon-reviews-in-r/)
  
  url_reviews <- paste0("https://www.amazon.com/product-reviews/",ASIN,"/?pageNumber=",page_num)
  
  doc <- read_html(url_reviews) # Assign results to `doc`
  
  # Review Title
  doc %>% 
    html_nodes("[class='a-size-base a-link-normal review-title a-color-base review-title-content a-text-bold']") %>% 
    html_text() -> review_title 
  
  review_title <- trimws(review_title, which = "both", whitespace = "[ \t\r\n]")
  
  # Review Text
  doc %>% 
    html_nodes("[class='a-size-base review-text review-text-content']") %>% 
    html_text() -> review_text
  
  review_text <- trimws(review_text, which = "both", whitespace = "[ \t\r\n]") # We remove the spaces at the beginning and end.
  
  # Number of stars in review
  doc %>%
    html_nodes("[data-hook='review-star-rating']") %>% #<<
    html_text() -> review_star #<<
  
  # Return a tibble
  tibble(review_title, review_text, review_star, page = page_num) %>% return()
}

# Now to our example

ASIN_banana <- "B0047E0EII" #This is the ASIN code for the banana slicer (you can find it in the url of the amazon website)

banana <- scrape_amazon(ASIN = ASIN_banana, page_num = 1) #Let's check out the first page of reviews!

banana %>% head()

# However, that's just one page... what if we want all the rest?

page_range <- 1:500 # Let's say we want to scrape pages 1 to 500

# Create a table that scrambles page numbers using `sample()`
# For randomizing page reads! (We will just scrape 100 pages (random), but if you want to scrape all 500, replace size = 50 for size = 500)

# Note: scraping 100 pages takes approximately 8 minutes

set.seed(123)

size = 100

match_key <- tibble(n = page_range[1:size],
                    key = sample(page_range,size))

# This function what is doing is for each value of j (page) is running the scrape_amazon code, and every three pages it reads
# it's taking a break. Why is this important? Because if not they can flag you as a bot and kick you off the website.

output_list <- lapply(1:size, function(i){
                      j <- match_key[match_key$n==i,]$key
                      
                      message("Getting page ",i, " of ",size, "; Actual: page ",j) # Progress bar
                      
                      Sys.sleep(3) # Take a three second break
                      
                      if((i %% 3) == 0){ # After every three scrapes... take another two second break
                        
                        message("Taking a break...") # Prints a 'taking a break' message on your console
                        
                        Sys.sleep(2) # Take an additional two second break
                      }
                      scrape_amazon(ASIN = ASIN_banana, page_num = j) # Scrape
                      })


# You can download the full data here (I already scraped it)
githubURL <- "https://github.com/maibennett/sta235/blob/main/exampleSite/content/Classes/Week14/1_Twitter/data/amazon_reviews.rdata?raw=true" # Be aware that apparently https:// is apparently only supported for Windows, so if you have a Mac/other, you can download the data directly from github and open from your directory locally
load(url(githubURL))

# Now let's play with the data
word_tb <- output_list %>% # This is the list of data we got from Amazon
              bind_rows() %>% #bind the rows to build a data frame
              unnest_tokens(output = "word", input = "review_text", token = "words") %>% #we separate the review text into different words.
              count(word) %>% #and we count those words
              filter(!(str_detect(word,"banana") | str_detect(word,"slic") | str_detect(word,"57") |
                       str_detect(word,"hutzler"))) %>% #we want to exclude bananas and slicer because we already know what it is
              anti_join(tidytext::stop_words, by = "word") #And finally, we exclude (anti_join) the stop_words contained on the tidytext package (words that don't contribute much meaning)

# Now let's do a word cloud to see what's bein said!
wordcloud::wordcloud(words = word_tb$word, freq = word_tb$n, min.freq = 5,
                     max.words=200, random.order=FALSE, rot.per=0.35,
                     colors=brewer.pal(10, "Dark2"), family = "Fira Sans Condensed SemiBold")


##################################################################################
##### Scraping Twitter data

library(rtweet)
library(textdata)
library(wordcloud)

## store api keys (these are fake example values; replace with your own keys)
api_key <- "afYS4vbIlPAj096E60c4W1fiK"
api_secret_key <- "bI91kqnqFoNCrZFbsjAWHD4gJ91LQAhdCJXCj3yscfuULtNkuu"
access_token <- "9551451262-wK2EmA942kxZYIwa5LMKZoQA4Xc2uyIiEwu2YXL"
access_token_secret <- "9vpiSGKg1fIPQtxc5d5ESiFlZQpfbknEN1f1m2xe5byw7"

token <- create_token(app = "STA 235",
                     consumer_key = consumer_key, 
                     consumer_secret = consumer_secret, 
                     access_token = access_token, 
                     access_secret = access_secret)


tweets_df <- search_tweets("#Oscars2021",n=1000,type = 'mixed', include_rts = FALSE, lang="en", since = '2021-04-25',
                            until = '2021-04-26', token = token) # You can restrict the time window you want to use for your tweets

View(tweets_df)

#Let's do some data cleaning:

tweets_df$text_clean <- tweets_df$text

tweets_df$text_clean <- tolower(tweets_df$text_clean) # all lower cases

tweets_df$text_clean <- gsub("rt ","",tweets_df$text_clean) # remove the first "RT " if this is a retweet

tweets_df$text_clean <- gsub("[[:punct:]]","",tweets_df$text_clean) # remove punctuation

tweets_df$text_clean <- gsub("http\\w+","",tweets_df$text_clean) # remove links

tweets_df$text_clean <- gsub("[ |\t]{2,}","",tweets_df$text_clean) # remove tabs

words_clean <- tweets_df %>% select(text_clean) %>% unnest_tokens(word, text_clean) 

words_clean <- words_clean %>% anti_join(stop_words) #remove useless words (stop_words from the tidytext package)


words_clean %>% count(word,sort=T) %>% slice(1:20) %>% 
  ggplot(aes(x = reorder(word, 
                         n, function(n) -n), y = n)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60, 
                                                                                                                      hjust = 1)) + xlab("")

# Create a list of stop words: a list of words that are not worth including

my_stop_words <- stop_words %>% select(-lexicon) %>% 
  bind_rows(data.frame(word = c("oscars", "oscars2021", "live", "2021","stream","watch","free","link","academy","academyawards","awards","award","oscar","93rd","tonight",
                                "theacademy","oscars2021live","hd","theoscars2021")))

tweet_words_interesting <- words_clean %>% anti_join(my_stop_words)

# Create a bar plot of the most frequent words
tweet_words_interesting %>% group_by(word) %>% tally(sort=TRUE) %>% slice(1:25) %>% 
  ggplot(aes(x = reorder(word, n, function(n) -n), y = n)) + geom_bar(stat = "identity") + 
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) + xlab("")

d <- tweet_words_interesting %>% group_by(word) %>% tally(sort=TRUE)
head(d, 10)

# You can also create a wordcloud
set.seed(100)
wordcloud(words = d$word, freq = d$n, min.freq = 5,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(10, "Dark2"), family = "Fira Sans Condensed SemiBold")

## Sentiment analysis

# Finally, we will get a list of words and the sentiments they are associated with them
bing_lex <- get_sentiments("nrc")

fn_sentiment <- tweet_words_interesting %>% left_join(bing_lex) # We join them with our list of "interesting" words

fn_sentiment %>% filter(!is.na(sentiment)) %>% group_by(sentiment) %>% summarise(n=n()) #And let's see how the distribution of sentiments look like!
