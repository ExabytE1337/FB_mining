library(tidyverse)
library(rvest)
url <- "luci.html"
raw <- read_html(url)
raw %>% 
  html_nodes("div.pam:nth-child(2) > div:nth-child(2) > div:nth-child(1) > div:nth-child(2)") %>%
  html_text()  
####################################
#figure out a way to get the number of divs
#this is how we get the message
for (i in 2:10){
  raw %>% 
    html_nodes(paste0("div.pam:nth-child(",i,") > div:nth-child(2) > div:nth-child(1) > div:nth-child(2)")) %>%
    html_text() %>%
    paste("\n","\n") %>%
    cat
}


#this is how we get the author
for (i in 2:10){
  raw %>% 
    html_nodes(paste0("div.pam:nth-child(",i,") > div:nth-child(1)")) %>%
    html_text() %>%
    paste("\n","\n") %>%
    cat
}

a <- raw %>% 
  html_nodes("div.pam:nth-child(7) > div:nth-child(1)") %>%
  html_text()

#this should get us the number of rows
n_messages <- raw %>%
  html_nodes("._4t5n") %>%
  html_children() %>%
  length  
n_messages  

raw %>%
  html_nodes("._4t5n")

#lets get a date
for (i in 2:6){
  raw %>% 
    html_nodes(paste0("div.pam:nth-child(",i,") > div:nth-child(3)")) %>%
    html_text() %>%
    paste("\n","\n") %>%
    cat
}

df <- tibble(date = rep(NA,n_messages), message = rep(NA,n_messages), author = rep(NA,n_messages))

tic()
a <- raw %>%
  html_nodes("._4t5n") %>%
  html_children() %>% html_text()
toc()

tic()
for (i in 2:6){
  raw %>% 
    html_nodes(paste0("div.pam:nth-child(",i,") > div:nth-child(2) > div:nth-child(1) > div:nth-child(2)")) %>%
    html_text()
}
toc()
