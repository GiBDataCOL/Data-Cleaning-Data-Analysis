###########################################################
###########################################################
                     # CLASE 5 R #
###########################################################
###########################################################

# Métodos Cuantitativos 

###########################################################

# optim()    : optimiza más de una variable 
# optimize() : optimiza una variable
# MUESTRA    : Lo más importante

###########################################################
# MV POISSON
###########################################################
# -n*lambda + sum(xi)*log(lambda)-n*sum(log(factorial(x)))
# theta  = lambda
# lambda = Xbarr

Poisson <- function(theta,x){
   lambda <- theta
   n      <- length(x)
   factor <- numeric()
   
   for(i in 1:n){
      factor[i] <- log(factorial(x[i])) 
   }
   
   f      <- n*lambda - sum(x)*log(lambda) + n*sum(factor)
}

sample  <- rpois(100,2)
results <- optimize(Poisson, interval = c(0, 3), x = sample)

###########################################################
# MV NORMAL
###########################################################
# - (T/2)*log(2*pi*sigma2)-(1/(2*sigma2))*sum(xi - iu)^2
# theta = [miu, sigma2]
# theta1 = Xbarr 
# theta2 = Xvar 

Normal <- function(theta,x){
   miu    <- theta[1]
   sigma2 <- theta[2]
   n      <- length(x)
   
   f      <- (n/2)*log(2*pi*sigma2)+(1/(2*sigma2))*(t(x-miu)%*%(x-miu))
}

sample  <- rnorm(100,1,3)
results <- optim(par = c(0.5,2), Normal, x = sample)

###########################################################
# SIMULACIÓN
###########################################################

n = 10000
k = 30 

data      <- matrix(, nrow = n, ncol = k )
verosimil <- numeric()

for(i in 1:k){
   data[,i] <- rpois(n,2)
   verosimil[i] <- optimize(Poisson, interval = c(0, 3), x = data[,i])$min
}

mean(verosimil)

###########################################################
