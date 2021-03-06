###########################################################
###########################################################
                     # CLASE 8 R #
###########################################################
###########################################################

# M�todos Cuantitativos 

###########################################################
# BONDAD DE AJUSTE 
###########################################################

# Example 9.1:
###########################################################
library(UsingR)
data = samhda
?samhda
dato = data$amt.smoke
obs  = table(dato[dato < 98])
esp  = c(0.15, 0.05, 0.05, 0.05, 0.1, 0.2, 0.4)

chisq.test(obs, p = esp)

# Problems 9.3:
###########################################################
library(UsingR)
data = mandms
?mandms

   # Milk Chocolate:
   esp = as.numeric(data[1,])
   obs = c(15, 34, 7, 19, 29, 24)
   esp = esp/100
   
   chisq.test(obs, p = esp)

   # Peanut:
   esp = as.numeric(data[2,])
   obs = c(15, 34, 7, 19, 29, 24)
   
   chisq.test(obs, p = esp, , rescale.p = T)

###########################################################
# TABLAS DE CONTINGENCIA 
###########################################################

# Ejemplo Clase:
###########################################################
x     = c(35, 10, 15)
y     = c(15, 20, 5)
tabla = rbind(x,y)

chisq.test(tabla)

# Example 9.2:
###########################################################
library(UsingR)
data  = samhda
dato  = cbind(data[,2], data[,5])
dato  = dato[dato[,1] < 3 & dato[,2] < 98,]
tabla = table(dato[,1], dato[,2])

chisq.test(tabla)

# Problems 9.11
###########################################################
x     = c(67, 42, 75, 56, 57)
y     = c(10, 6, 8, 4, 15)
z     = c(5, 5, 4, 6, 1)
tabla = data.frame(x,y,z)

chisq.test(tabla)

###########################################################