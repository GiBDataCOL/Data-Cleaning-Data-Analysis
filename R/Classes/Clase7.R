###########################################################
###########################################################
                     # CLASE 7 R #
###########################################################
###########################################################

# Métodos Cuantitativos 
# PRUEBAS DE HIPÓTESIS
# Using R for Introductory Statistics - Verzani
###########################################################

# PH: Proporciones Binomial
###########################################################
# Tasa de pobreza en Estados Unidos
# P   = proporción de pobres
# P00 = 11.3% (censo)
# P01 = 11.7% (muestra: 50.000)
# P02 = 12.1% (muestra: 60.000)

# Ho: P01 = 11.3% = 0.113
# Ha: P01 > 11.3% > 0.113

# Sin comando: 
P    = 0.113
Phat = 0.117
n    = 50000
SE   = sqrt(Phat*(1-Phat)/n)
Z    = (Phat - P)/SE
alfa = 0.05
VC   = qnorm(1 - alfa, mean = 0, sd = 1, lower.tail = T)

alfa   = 0.05
pvalue = pnorm(Phat, mean = P, sd = SE, lower.tail = F)

# Con comando:
prop.test(n*Phat, n, P, alt = "greater")


# PH: Miu Normal, Sigma2 desconocido
###########################################################
# Librería Colegio
# Ho: Miu = 101.75$
# Ha: Miu > 101.75$

# Sin Comando:
x    = c(140, 125, 150, 124, 143, 170, 125, 94, 127, 53)
miu  = 101.75
xbar = mean(x)
SE   = sd(x)
n    = length(x)
alfa = 0.05

Ttest = (xbar - miu)/(SE/sqrt(n))
VC    = qt(1 - alfa, df = n - 1, lower.tail = T)

pvalue = pt(Ttest, df = n - 1, lower.tail = F)
alfa   = pt(VC, df = n - 1, lower.tail = F)

# Con Comando:
t.test(x, mu = 101.75, alt = "greater")

###########################################################
# EJERCICIO:
# Problema 8.19 - Pág. 232
###########################################################

rm(list = ls())

library(UsingR)
attach(babies)
help(babies)
smokers = gestation[smoke == 1 & gestation != 999]
detach(babies)

# Prueba: Promedio periodo de gestación es en 40 semanas
# Ho: Miu  = 40
# Ha: Miu != 40
# PH: Miu Normal, Sigma2 desconocido
# 40 semanas = 160 días

# Sin Comando:
miu  = 160
xbar = mean(smokers)
SE   = sd(smokers)
n    = length(smokers)
alfa = 0.05

Ttest = (xbar - miu)/(SE/sqrt(n))
VC    = qt(1 - alfa, df = n - 1, lower.tail = T)

pvalue = pt(abs(Ttest), df = n - 1, lower.tail = F)
alfa   = pt(VC, df = n - 1, lower.tail = F)

# Con Comando:
t.test(smokers, mu = 160, alt = "two.sided")

###########################################################

