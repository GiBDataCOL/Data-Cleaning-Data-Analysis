# Puntos 8a & 8b del taller.

#Se preparan las bases de datos. 
library(tree)
library(ISLR)
attach(Carseats)


#8a
#Se siguen los pasos dados en el laboratorio
#del libro para así dividir la muestra.
#Se opta por dividirla en partes iguales por sencillez. 
set.seed(2)
train=sample(1:nrow(Carseats), 200)
Sales.test=Sales[-train]

#8b se hace un árbol básicoo y otro podado.

tree.carseats=tree(Sales~., Carseats, subset=train)
summary(tree.carseats)

plot(tree.carseats)
text(tree.carseats, pretty=0)

yhat1= predict(tree.carseats, newdata=Carseats[-train,])
carseats.test=Carseats[-train,"Sales"]
sqrt(mean((yhat1 - carseats.test)^2))

#Se mejora el árbol
cv.carseats=cv.tree(tree.carseats)
names(cv.carseats)

cv.carseats
#Se da el mejor resultado con 17 nodos terminales. 

prune.carseats= prune.tree(tree.carseats, best=17)
summary(prune.carseats)

plot(prune.carseats)
text(prune.carseats, pretty=0)

yhat2= predict(prune.carseats, newdata=Carseats[-train,])
prunecarseats.test=Carseats[-train,"Sales"]
sqrt(mean((yhat2 - prunecarseats.test)^2))

#No mejora el resultado a comparación del árbol no podado. 
