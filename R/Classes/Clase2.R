#####################################################
#####################################################
                  # CLASE 2 R #
#####################################################
#####################################################

# Métodos Cuantitativos 

#####################################################
# MEDIA & VARIANZA
#####################################################
# outliers: no dañan mediana pero si media

x1 = c(-0.5, -4, -3, -2.5, -2, -10, 1, 2, 3, 4, 5, 19, 45, 72)
stripchart(x1)
stripchart(mean(x1), add = T, col = c("blue"))
stripchart(median(x1), add = T, col = c("red"))

#####################################################
# EJEMPLO 1
#####################################################

library(datasets)
library(UsingR)
cat("\014")

data(survey)
attributes(survey)
?survey

# Height 
mean(survey[,10], na.rm = T)
mean(survey[survey[,1] == "Male" ,10], na.rm = T)
mean(survey[survey[,1] == "Female" ,10], na.rm = T)

# Smoke 
mean(survey[,12], na.rm = T)

max(survey[,12])
min(survey[,12])

mean(survey[survey[,9] == "Heavy" ,12], na.rm = T)
mean(survey[survey[,9] == "Regul" ,12], na.rm = T)
mean(survey[survey[,9] == "Occas" ,12], na.rm = T)
mean(survey[survey[,9] == "Never" ,12], na.rm = T)

survey[which(survey[,12] > 35),]
table(survey[which(survey[,12] < 19),12])

survey[which(survey[,12] > 35 & survey[,9] == "Heavy"),]
survey[which(survey[,12] < 19 & survey[,9] == "Heavy"),]


#####################################################
# EJEMPLO 2 

   # sav   : annual savings, $
   # inc   : annual income, $
   # size  : family size
   # educ  : years educ, household head
   # age   : age of household head
   # black : = 1 if household head if black
   # cons  : annual consumption, $
#####################################################

data = read.table("Data-Saving-C2.txt", header = T, quote = " ")

mean(data[,1], na.rm = T)
var(data[,1])
sd(data[,1])

mean(data[,2], na.rm = T)
var(data[,2])
sd(data[,2])

mean(data[data[,6] == 1,2])
mean(data[data[,6] == 0,2])

#####################################################
# PLAN DE VUEVLO
#####################################################
# Normal estándar
# Chi Cuadrado 
# Distribución T
# Distribución F 

# BOXPLOT
y = runif(1000, 10, 20)
simple.hist.and.boxplot(y)

y = rnorm(1000, 5, 3)
simple.hist.and.boxplot(y)

y = rexp(1000)
simple.hist.and.boxplot(y)

#####################################################
# TLC: Chi y F tienden a una Normal

library(UsingR)
cat("\014")

# 1. Normal
y = rnorm(1000)
hist(y, prob = T)
lines(density(y), lwd = 3)

# 2. Uniforme
y = runif(1000)
hist(y, prob = T)
lines(density(y), lwd = 3)

# 3. T Student
y = rt(1000, 10)
hist(y, prob = T)
lines(density(y), lwd = 3)

# Tstudent tiende a Normal 
# gl -> infinito

x1 = rnorm(1000)
x2 = rchisq(1000, 1000)
y  = x1/sqrt(x2/1000)
hist(y, prob = T)

# 4. Chi Squared 
y = rchisq(1000, 2)
hist(y, prob = T)
lines(density(y), lwd = 3)

# 5. Distribución F
y = rf(1000, 3, 4)
hist(y, prob = T)
lines(density(y), lwd = 3)

x1 = rchisq(1000, 10)
x2 = rchisq(1000, 12)
y  = (x1/10)/(x2/12)
hist(y, prob = T)

#####################################################
