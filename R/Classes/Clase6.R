###########################################################
###########################################################
                     # CLASE 6 R #
###########################################################
###########################################################

# Métodos Cuantitativos 
# INTERVALOS DE CONFIANZA
# Using R for Introductory Statistics - Verzani
###########################################################

# EJEMPLO BASE
# Simulación
# IC: 
###########################################################
# sample: without replacement
# mean  : encentra la proporción de bola tipo 1
# Simular la muestra 1000 veces para saber la distribución phat

# 2 tipos de bolas: tipo 1, tipo 0
# ¿Cuál es la verdadera proporción de "1"?
# ¿Phat? -> ¿P?

# Población: 10.000 bolas tipo 1 y tipo 2
# Muestra:   100 individuos aleatoriamente seleccionadas
# Suponga:   P = 0.56
   # 5600 son la bola 1
   # 4400 son la bola 0

data    = rep(0:1, c(10000 - 5600, 5600))
muestra = sample(data,100)
phat    = mean(muestra)
phat

vector = numeric()

for(i in 1:1000){
   vector[i] = mean(sample(data,100))
}

hist(vector, prob = T, main = "Histograma Proporción Bola 1")
IC80 = quantile(vector, c(0.1,0.9))
IC90 = quantile(vector, c(0.05,0.95))
IC95 = quantile(vector, c(0.025,0.975))

rug(IC80, ticksize = 1, col = "red", lwd = 3, side = 3)
rug(IC90, ticksize = 1, col = "yellow", lwd = 3, side = 3)
rug(IC95, ticksize = 1, col = "cyan", lwd = 3, side = 3)

###########################################################
# IC: Media Normal, Sigma2 desconocido
###########################################################

# Simulación:
   # Ingreso de individuos Estrato 6
   # dado en millones
   # media = (a + b)/2

a      = 4
b      = 25
sample = runif(1000, min = a, max = b)
media  = (a + b)/2

vector = numeric()

for(i in 1:1000){
   vector[i] = mean(runif(1000, min = a, max = b))
}

hist(vector, prob = T)
IC80 = quantile(vector, c(0.1,0.9))
IC90 = quantile(vector, c(0.05,0.95))
IC95 = quantile(vector, c(0.025,0.975))

rug(IC80, ticksize = 1, col = "red", lwd = 3, side = 3)
rug(IC90, ticksize = 1, col = "yellow", lwd = 3, side = 3)
rug(IC95, ticksize = 1, col = "cyan", lwd = 3, side = 3)

# Ejemplo C1 (95%)

xbar = 170.82
s    = 10
n    = 28 
alfa = 0.05
t    = qt(1 - (alfa/2), df = n - 1)
SE   = s/sqrt(n)
IC   = c(xbar - t*SE, xbar + t*SE)

# Ejemplo L7.5 (90%) - Making Coffee

onzas = c(1.95, 1.80, 2.10, 1.82, 1.75, 2.01, 1.83, 1.90)
t.test(onzas, conf.level = 0.80)
   
###########################################################
# IC: Sigma2x/Sigma2y Normal independientes
#     Miux, Miuy desconocidos
###########################################################

# Simulación:

# CASO 1:
   # Subsidio del 10% sobre el ingreso 
   # 2 grupos: Estrato 1 (0.35, 0.05^2) & Estrato 4(4, 0.5)
   # datos en millones

# CASO 2:
   # Subsidio del 10% sobre el ingreso 
   # 2 grupos: Estrato 1(0.35, 0.05^2) & Estrato 2(0.45, 0.058^2)
   # datos en millones

mean1 = 0.35
sd1   = 0.05
mean2 = 2
sd2   = 0.3
dvar  = (sd2^2)/(sd1^2)

sample1 = rnorm(1000, mean = mean1, sd = sd1)
sample2 = rnorm(1000, mean = mean2, sd = sd2)

# sx2, sy2, sxy de acuerdo a quién sea mayor

sx2 = var(sample2)
sy2 = var(sample1)
sxy = sx2/sy2

n       = 1000
vector1 = numeric()
vector2 = numeric()
vector3 = numeric()

for(i in 1:n){
   vector1[i] = var(rnorm(n, mean = mean1, sd = sd1))
   vector2[i] = var(rnorm(n, mean = mean2, sd = sd2))
   vector3[i] = vector2[i]/vector1[i]
}

hist(vector3, prob = T, main = "Histograma de Variación de Ingresos")
IC80 = quantile(vector3, c(0.1,0.9))
IC90 = quantile(vector3, c(0.05,0.95))
IC95 = quantile(vector3, c(0.025,0.975))

rug(IC80, ticksize = 1, col = "red", lwd = 3, side = 3)
rug(IC90, ticksize = 1, col = "yellow", lwd = 3, side = 3)
rug(IC95, ticksize = 1, col = "cyan", lwd = 3, side = 3)

# Ejemplo C4 (95%)

sx   = 4.0181
sy   = 1.8392
sxy  = sx/sy
nx   = 11
ny   = 8 
alfa = 0.05
f1   = qf((1 - (alfa/2)), df1 = 11, df2 = 8)
f2   = qf((1 - (alfa/2)), df1 = 8, df2 = 11)
IC   = c(sxy/f1, sxy*f2)
IC

###########################################################