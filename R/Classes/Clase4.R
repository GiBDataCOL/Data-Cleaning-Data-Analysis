#####################################################
#####################################################
                  # CLASE 4 R #
#####################################################
#####################################################

# Métodos Cuantitativos 

#####################################################
# ESTIMACIÓN PUNTUAL
# Propiedades Estimadores
#####################################################

# Distribución Poisson 
#####################################################

   # Lambda:
      # parámetro positivo
      # no. veces que se espera que ocurra fenómeno en intervalo dado
   # Número de muertes (asesinatos) por semana en Bogotá 
   # Lambda = 4

install.packages("psych")
library("psych")

data = read.table("Data-C4.txt")
hist(data[,1], prob = T, main = "Histograma Muertes de Bogotá")
dato = describe(data)

# Simulación - Eficiencia Relativa
   # Poisson 
#####################################################

n = 200
k = 150
lambda = 4

sample <- matrix(, nrow = n, ncol = k)
for( i in 1:k){
   sample[,i] <- rpois(n, lambda)
}

media <- numeric(length = k)
for(i in 1:k){
   media[i] <- mean(sample[,i], na.rm = T)
}
lhat1 <- var(media)
print(lhat1)

variance <- numeric(length = k)
for(i in 1:k){
   variance[i] <- var(sample[,i], na.rm = T)
}
lhat2 <- var(variance)
print(lhat2)

# Consistencia
#####################################################

n = 1000
lambda = 8
datos = rpois(n, lambda)
media <- numeric()
for(i in 1:n){
   media[i] <- mean(datos[1:i])
}
plot(media, type = "l", main = "Consistencia", col = "blue", lwd = 1, 
     xlab = "Número de datos", ylab = "Medias")
lines(rep(lambda, n), col = "cyan", lw = 3)

#####################################################