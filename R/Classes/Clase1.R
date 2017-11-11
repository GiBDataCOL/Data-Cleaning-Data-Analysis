#####################################################
#####################################################
                   # CLASE 1 R #
                # Comandos Básicos #
#####################################################
#####################################################

# Métodos Cuantitativos 

#####################################################
# TEXTO IMPORTANTE #
#####################################################
   
   # comentarios
      # 1. install.packages("nombre paquete")
      # 2. library("nombre paquete")
   # str():        muestra estructura de comando 
   # rm():         elimina los objetos del environment en el ()
   # ctrl+R:       corre selección
   # ctrl-C:       interrumpir ejecución (run)
   # ctrl+L:       limpiar consola
   # ctrl+alt+R:   correr todo
   # R discrimina entra minus y mayus 
   # ():           funciones
   # []:           extraer objetos de datos

   # getwd():      buscar directorio
   # dir():        nombra archivos en directorio
   # setwd:        cambiar directorio (barra '/')

#####################################################
# INSTALAR PAQUETES #
#####################################################

   # UsingR 
   # swirl

install.packages("UsingR")
library("UsingR")

install.packages("swirl")
library("swirl")

#####################################################
# OPERACIONES BÁSICAS #
#####################################################
   # * : multiplica componente por componente
   # / : divide componente por componente
   # ^ : eleva cada ponente a la n 

   # attributes: muestra información
   # c():        función general que combina argumentos


# 1. Vectores
#####################################################

a   <- 5
10  -> b
c   <- a + b

abc = c(a,b,c)

d   <- 1:3
e   <- c(1,4,5)

mul = d*e
div = d/e
ele = c(d^2, e^2)

f1  <- c(1,3,4,5,6,9)
f2  <- f1

f2[c(1,2,5)] = c(0,14,1) 

x1  <- c(0.5, 0.6)
x2  <- c(TRUE, FALSE)
x3  <- c(T,F)
x4  <- c("a","b","c")
x5  <- 9:29


# 2. Matrices
#####################################################

cbind(a,b,c)
rbind(a,b,c)

cbind(f1,f2)
rbind(f1,f2)

n <- matrix(nrow = 2, ncol = 3)
dim(n)
attributes(n)

o <- matrix(1:6, nrow = 2, ncol = 3)

y <- matrix(1:4, nrow = 2, ncol = 2)
dimnames(y) <- list(c("c", "d"), c("a", "b"))

# convertir vector a matriz:

p <- 1:10 
dim(p) <- c(2,5)
dim(p) <- c(5,2)

# convertir matriz a vector:

dim(p) <- c(1,10)
dim(p) <- c(10,1)


# 4. Datos estructurados
#####################################################

x = 1:10
x = rev(x)

seq(1, 9, by = 2)
seq(1, 10, by = 2)
seq(1, 9, length = 5)

rep(1,10)
rep(1:3,3)
rep(c("length", "short"), c(1,2))


# 4. Hojas de datos
#####################################################

x     <- rnorm(50)
y     <- rnorm(x)
z     <- rnorm(50)

data1 <- data.frame(x=x,y=x+rnorm(x))
data2 <- data.frame(x=x, y=y, z=x*z)

nrow(data1)
ncol(data1)

#####################################################
# FUNCIONES BÁSICAS #
#####################################################

# Ejemplo 1:

g   <- c(2.43,3.2,7.32,5.54)

log(g)
exp(g)
log10(g)
log(g,10)
log(g, base = 10)
sqrt(g)
factorial(g)
floor(g)
ceiling(g)
round(g,digits=0)
signif(g,digits=1)
abs(g)

# Ejemplo 2:

x = c(74, 122, 235, 111, 292)
y = c(111, 211, 133, 156, 79)
z = c(x,y)

sum(z)
length(z)
sum(z)/length(z)
mean(z)

sort(z)
min(z)
max(z)
range(z)
diff(z)
cumsum(z)

#####################################################
# VALORES LÓGICOS #
#####################################################

x = c(88.8, 88.3, 90.2, 93.5, 95.2, 94.7, 99.2, 99.4, 101.6)
x[10:13] = c(97, 0.99, 102, 101.8)

x > 100
x[x > 100]
which(x > 100)
x[which(x > 100)]
x[c(9, 12, 13)]

#####################################################
# CONDICIONALES #
#####################################################

# Forma 1:

if(<condition>) {
   # do something
} else {
   # do something else
}

# Forma 2:

if (<condition>) {
   # do something
} else if (<condition2>) {
   # do something different
} else {
   # do something different
}

# Ejemplo 1:
x = 7

if (x > 3) {
   y = 10
} else {
   y = 0
}

# Ejemplo 2:
x = 7

y = if(x > 3) {
   10
} else {
   0
}

#####################################################
# LOOPS #
#####################################################

# Ejemplo 1:
for(i in 1:10) {
   print(i)
}

# Ejemplo 2:
x = c("a", "b", "c", "d")
n = length(x)

for (i in 1:4){
   print(x[i])
}

for (i in 1:n){
   print(x[i])
}

for (i in seq_along(x)){
   print(x[i])
}

for (letter in x){
   print(letter)
}

# Ejemplo 3: 

x = matrix(1:10, 2, 5)

for(i in seq_len(nrow(x))){
   for(j in seq_len(ncol(x))){
      print(x[i,j])
   }
}

# Ejemplo 4:
count = 0 
while(count < 10){
   print(count)
   count = count + 1
}

#####################################################
# FUNCIONES #
#####################################################

f <- function (<arguments>){
   # Do something interesting
}

# Función 1:
Add <- function(x,y){
   x + y
}
Add(2,3)

# Función 2:
Above10 <- function(x){
   x[x > 10]
}
Above10(1:20)

# Función 3: 
# Al no darle un valor a n, utiliza 10
Above <- function(x,n = 10){
   x[x > n] 
}
Above(1:20)
Above(1:20,3)

# Función 4: 
# Coger cada columna y sacar promedio

x = matrix(1:12, 3, 4)

Mean <- function(x){
   for(i in seq_len(ncol(x))){
      print(mean(x[ , i], na.rm = T))
   }
}
Mean(x)

Colmean <- function(x){
   nc    <- ncol(x)
   means <- numeric(nc)
   for(i in 1:nc){
      means[i]<- mean(x[ , i], na.rm = T)
   }
   means
}
Colmean(x)
Colmean(airquality)

# Función 5:
make.power <- function(n){
   pow <- function(x){
      x^n
   }
   pow
}
cube <- make.power(3)
cube(2)

#####################################################
# GRÁFICAS #
#####################################################

# 1. Tablas 
library(UsingR)
data = central.park.cloud
table(data)

# 2. Barras 
x = c(rep(1:3,4), rep(1:2,3), rep(2:3,5))
length(x)

barplot(x)
barplot(table(x), xlab = "Candidato Presidencial", 
        ylab = "Frecuencia", names.arg = c("Uribe", "Santos", "Mockus"))

# 3. Circular
pie(table(x), labels = c("Uribe", "Santos", "Mockus"), main = "Candidatos")

# 4. Puntos
dotchart(x, main = "Candidatos" , color = c("red"))
dotchart(table(x), main = "Candidatos", color = c("blue"))

# 5. Plot
   # type: 
      # l: lineas
      # p: puntos
      # b: lines y puntos
      # c: lineas con espacios vacios en punto
      # o: lineas y puntos juntas - sobrepuestas
      # s: escalera
      # h: histogram

x <- rnorm(50)
y <- rnorm(x)

plot(x,y,type = "l")
plot(sort(x),y,type = "l")
plot(x,y,type = "p")
plot(x,y,type = "b")
plot(sort(x),y,type = "c")
plot(x,y,type = "o")
plot(sort(x),y,type = "s")
plot(x,y,type = "h")

#####################################################

