library(tidyverse)
library(rvest)
library(tictoc)
library(lubridate)
#library(helfRlein)
#?statusbar
url <- "luci.html"
raw <- read_html(url)

n_messages <- raw %>%
  html_nodes("._4t5n") %>%
  html_children() %>%
  length 
n_messages

df <- tibble(date = rep(NA,n_messages), author = rep(NA,n_messages), message = rep(NA,n_messages))
df
# #lets get the date
# tic()
# for (i in 1:n_messages){
#   statusbar(run = i, max.run = n_messages, percent.max = 60L)
#   df[i,1] <- raw %>% 
#     html_nodes(paste0("div.pam:nth-child(",i+1,") > div:nth-child(3)")) %>%
#     html_text()
# }
# toc()
# #lets get the author
# tic()
# for (i in 1:n_messages){
#   df[i,2] <- raw %>% 
#     html_nodes(paste0("div.pam:nth-child(",i+1,") > div:nth-child(1)")) %>%
#     html_text()
# }
# toc()
# #lets get the message
# tic()
# for (i in 1:n_messages){
#   df[i,3] <- raw %>% 
#     html_nodes(paste0("div.pam:nth-child(",i+1,") > div:nth-child(2) > div:nth-child(1) > div:nth-child(2)")) %>%
#     html_text()
# }
# toc()
# df
# content_nodes<- read_html(url) %>% html_nodes("._4t5n")
raw %>%
  html_nodes("._4t5n") %>%
  html_children() %>%
  html_text()

a <- raw %>%
  html_nodes("._4t5n") %>%
  html_children() %>%
  html_children() %>%
  html_text

n <- length(a)
df$author <- a[seq(1,n,by = 3)]
df$message <- a[seq(2,n,by = 3)]
df$date <- a[seq(3,n,by = 3)]
rm(a) #delete the temp variable

temp <- str_split_fixed(df$date,",",n =3 )
temp2 <- mdy(paste0(temp[,1],",",temp[,2]))
df$date <- temp2
df$datetime <- ymd_hm(paste0(df$date,temp[,3]))
df
rm(temp)
rm(temp2)
df$author <- factor(df$author)
colnames(df) <- c("Date","Author", "Message", "Datetime")
saveRDS(df,file="df.rds")
##################################################
#plot by year
min(df$Date)
max(df$Date)
sekvencia <- seq(ymd(min(df$Date)),ymd(max(df$Date)), by = 'years')
ggplot(df,aes(x = year(Date),fill = Author)) + geom_bar()
ggplot(df,aes(x = format(df$Date, "%Y-%m"),fill= Author)) + geom_bar() +  
  theme(plot.caption = element_text(vjust = 1)) +
  labs(x = "Year and Month", y = "Number of messages") + theme(plot.subtitle = element_text(vjust = 1), 
    axis.text.x = element_text(angle = 0)) +
  scale_x_discrete(breaks = format(seq(ymd(min(df$Date)),ymd(max(df$Date)), by = 'years'),"%Y-%m")) + 
  theme_minimal()
