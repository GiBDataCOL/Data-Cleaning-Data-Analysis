#####################################################
#####################################################
                  # CLASE 3 R #
#####################################################
#####################################################

# M�todos Cuantitativos 

#####################################################
# TEOREMA DEL L�MITE CENTRAL 
#####################################################
   # n  : n�mero de valores aleatorios a generar
   # df : distribuci�n 

TLC <- function(n, df, num = 10){
   sample <- matrix(, nrow = n, ncol = n)
   medias <- numeric(length = n)
   for (i in 1:n){
      sample[,i] <- df(n)
      medias[i]  <- mean(sample[,i] , na.rm = T)
   }
   hist(sample[,num], main = "Histograma Muestra Num")
   hist(medias, prob = T, main = "Histograma TLC")
   lines(density(medias), lwd = 3)
}
 
n = 700
TLC(n, rexp)
TLC(n, runif)
