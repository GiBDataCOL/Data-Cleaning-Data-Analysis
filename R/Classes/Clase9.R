###########################################################
###########################################################
                     # CLASE 9 R #
###########################################################
###########################################################

# Métodos Cuantitativos 

###########################################################
# KOLMOGOROV 
###########################################################
# ecdf: distribución acumulada empírica ordenada

# Demostración:
###########################################################

x = rnorm(100, mean = 5, sd = 2)
ks.test(x, "pnorm", mean = 0, sd = 2) 
ks.test(x, "pnorm", mean = 5, sd = 2)
ks.test(x, "pnorm")
ks.test(x, "pnorm", mean = 0,sd = 1)

z = rnorm(100,0,1)
w = rnorm(100,0,1)
plot(ecdf(z))
lines(ecdf(x), col = "red")
ks.test(z, x, alternative = "less")

y = runif(100, min = 0, max = 5)
ks.test(y,"punif", min = 0, max = 6) 
ks.test(y, "punif", min = 0, max = 5)

# Example 9.3:
###########################################################

library(UsingR)
attach(stud.recs)
plot(ecdf(sat.m), main = "Math and verbal SAT scores")
lines(ecdf(sat.v), lty = 2, col = "red")
ks.test(sat.m, sat.v, alternative = "greater")

###########################################################
# ANOVA
###########################################################

#Ski
UBP=c(168.2,161.4,163.2,166.7,173.0,173.3,160.1,161.2,166.8)

grip.type=rep(c("classic","integrated","modern"),c(3,3,3))
grip.type=factor(grip.type)
BP=boxplot(UBP ~ grip.type, ylab= "Power") 
res=aov(UBP ~ grip.type) 
summary(res)

#Carros
library(UsingR)
attach(carsafety)
drivers= aov(Driver.deaths ~ type)
summary(drivers)

others= aov(Other.deaths ~ type)
summary(others)

