---
title: '612 Week 4 Homework: dplyr'
author: "Yunting"
date: "2/8/2020"
output: pdf_document
---
## Exercise 1: Pygmalion Data

```{r}
library(Sleuth3)
library(tidyverse)
data(case1302)
head(case1302)

```
#### 1. What are the units? What are the variables?\
Units : platoons\
Variables: Company, Treat and Score\



#### 2. Calculate the average score within each company by treatment combination.


```{r}
library(Sleuth3)
library(tidyverse)
library(scales)
case1302 %>%
  group_by(Company,Treat) %>% #calculate the mean Score of Company and Treat 
 summarize(average_Score = mean(Score, na.rm = TRUE), n= n()) 

```

#### 3. Copy this plot:
```{r}
library(ggthemes)
case1302 %>%
  group_by(Company,Treat) %>%
 summarize(mean_Score = mean(Score, na.rm = TRUE), n = n()) ->
  
  
  sumdf
head(sumdf)
sumdf %>%
  ggplot(aes(x = Company, y = mean_Score)) +
  theme_bw() +
  geom_point(aes(size = n, color = Treat)) +
  scale_color_colorblind(name = "Treatment") +
  scale_size(name = "Number of \nObersavtions", range = c(2,4), breaks = c(1,2)) +
  guides("Treatment", "Number of Obersavtions") +
  ylab("Mean Score") +
  guides(color = guide_legend(order=1),size = guide_legend(order=2)) 
  

```


```{r}
library(ggthemes)
case1302 %>%
  group_by(Company,Treat) %>%
 summarize(mean_Score = mean(Score, na.rm = TRUE), n = n()) %>%
  
  ggplot(aes(x = Company, y = mean_Score, size = n, color = Treat)) +
  theme_bw() +
  geom_point() +
  scale_color_colorblind(name = "Treatment") +
  
  scale_size(name = "Number of \nObersavtions", range = c(2,4), breaks = c(1,2)) +
  guides("Treatment", "Number of Obersavtions") +
  ylab("Mean Score") +
  guides(color = guide_legend(order=1),size = guide_legend(order=2)) 
```

#### 4. Does it make sense to add a loess smoother to the above plot? Why or why not? If so, add one.\
I suggest we cannot add a geom_smooth line. Although we added the function, the spot of this chart is too separate. In this case, it is not make sense to add a loess smoother to the above plot.\

real ans:  because a loess smoother would only make sense if the explanatory variable was also quantitative, but it is categorical


## Exercise 2: Midwest Data\

• For this exercise, we’ll use the midwest data from ggplot2.\

#### 1. Load these data into R.\
```{r}
data(midwest)
head(midwest)
```

#### 2. What are the observational units?\

Ans: counties

#### 3. Calculate the total population in each state. Display the data in an appropriate plot\
```{r}
midwest %>%
  group_by(state) %>%
  mutate(sum_poptotal = sum(poptotal, na.rm = TRUE))%>%
  
  
  ggplot(aes(x = state, y = sum_poptotal)) +
  geom_col()
```










```{r}
midwest %>%
  group_by(state) %>%
  mutate(sum_poptotal = sum(poptotal, na.rm = TRUE))  %>%
ggplot(aes(x = state, y = sum_poptotal))+
  theme_economist_white()+
  geom_col()
```

#### 4. Make a scatterplot of population density against the percent college educated on a scale that is appropriately linear. You should exclude counties in the bottom tenth percentile of total population. Color code the counties by state. Add the overall OLS line (the one that takes all points into account). Make the OLS line black and dotted.

```{r}
midwest %>%
  filter(poptotal > quantile(poptotal, probs = 0.1)) %>%
  ggplot( mapping = aes(x = popdensity, y = percollege, color = state)) +
  geom_point(size = 1) +
  geom_smooth(method = "lm", se = FALSE, linetype = "dotted", color = "black")+
  theme_bw() +
  scale_x_log10() + 
  scale_y_log10()
  
```

#### 5. Make an appropriate plot to explore the association between the state and the percentage adults. Make sure the axis labels are nice and use the black-and-white theme.\
```{r}
midwest %>%
  mutate(percadults = popadults / poptotal) %>%
  arrange(desc(percadults)) %>%

  
  ggplot(mapping = aes(x = state, y = percadults, fill = state)) +
  theme_bw() +
  geom_boxplot() +
  ylab("Percentage of Adults") +
  xlab("States of midwest")
  
```

#### 6. Use an R function to determine the possible values of state.\
```{r}
unique(midwest$state)
  
```

#### 7. In the state variable, replace or recode the abbreviations with the full state name, e.g., IL with Illinois, IN with Indiana, etc..
```{r}
midwest %>%
  mutate(state = recode(state, IL = "Illinois", IN = "Indiana", MI = "Michigan", OH = "Ohio", WI = "Wisconsin")) %>%
  
 tail()
```

## Exercise 3: Coding Problems
#### 1. Create a function that takes a vector of numerics as input. It checks the length of the vector. If the length is even, it returns the sum of the vector. If the length is odd, it returns the sum of all of the even numbers of the vector. For example, the following are some outputs of one implementation, calledn lsumfun().
```{r}
lsumfun <- function(x){
  stopifnot(is.numeric(x))
  if (length(x) %% 2 == 0){
    return(sum(x[x], na.rm = TRUE))
  } else {
      return(sum(x[x %% 2 == 0], na.rm = TRUE))
  }
  
}

lsumfun(c(1, 2, 3, NA))
lsumfun(c(1, 2, 3))
lsumfun(c(2, 3, 4, 5, 6))
lsumfun(c(2, 3, 4, 5, NA))
lsumfun(c(2, 3, 4, NA, 6))
```

#### 2. We add a Leap Day on February 29, almost every four years. In the Gregorian calendar three criteria must be taken into account to identify leap years:\
• The year can be evenly divided by 4, is a leap year, unless:\
• The year can be evenly divided by 100, it is NOT a leap year, unless:\
• The year is also evenly divisible by 400. Then it is a leap year.\
This means that in the Gregorian calendar, the years 2000 and 2400 are leap years, while 1800, 1900, 2100, 2200, 2300 and 2500 are NOT leap years\

Write a function that takes the year as input and returns TRUE if it is a leap year and FALSE if it is not a leap year. Evaluate your function at 2, 12, 200, 800.\
```{r}
Gregorian_calendar <- function(y){
  if (y %% 400 == 0){return(" TRUE")}
     else if (y %% 100 ==0){return(" FALSE")}
     else if (y %% 4 ==0){return(" TRUE")}
  
     else {return("FALSE")}
  
  
}
Gregorian_calendar(2)
Gregorian_calendar(12)
Gregorian_calendar(200)
Gregorian_calendar(800)
```

#### 3. Create a function that takes two vectors of numerics as input, a and b.\
• Your vector should throw an error if either a or b contain repeated elements.\
• If a number is in a and not b you add 1 to your score.\
• If a number is in b and not a you subtract 1 from your score.\
• If a number is in both a and b you do nothing to your score.\
• The function returns the final score.\
• Hint: help("%in%")\

```{r error = TRUE }
score2 <- function(a,b){
  stopifnot(is.numeric(a))
  stopifnot(is.numeric(b))
  
  if(length(a) != length(unique(a))){
    stop("a has some repeated elements ")
  }else if(length(b) != length(unique(b))){
    stop("b has some repeated elements")
  }
  
  return(sum(!(a %in% b)) - sum(!(b %in% a)))
  }
  
score2(c(1, 2, 3), c(3, 4))
score2(c(1, 2, 3), c(1, 2, 3, 4))  
score2(c(1, 2, 3), c(3, 4, 4))
  
```

