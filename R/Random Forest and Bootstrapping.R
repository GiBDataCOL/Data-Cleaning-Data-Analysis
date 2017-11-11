## Trabajo Final minería de datos. 
library(foreign)
library(gbm)
library(boot)
library(randomForest)
library(rpart)
library(tree)
library(cvTools)
library(car)
library(adabag)
setwd("C:\\Users\\n.gomez128\\Documents\\R")
#setwd("G:\\2016-I\\Minería de datos\\Trabajo Final")
Lapop <- read.dta("Colombia 2014 Muestra Nacional.dta")
#Limpiando la base
Lapop$pais <- NULL
Lapop$id_adgys <- NULL
Lapop$estratopri <- NULL
Lapop$estratosec <- NULL
Lapop$cluster <- NULL
Lapop$wt <- NULL
Lapop$upm <- NULL
Lapop$tamano <- NULL
Lapop$idiomaq <- NULL
Lapop$fecha <- NULL
Lapop$sexi <- NULL
Lapop$colori <- NULL
Lapop$formatq <- NULL
Lapop$colestsoc <- NULL
Lapop$ti <- NULL
Lapop$uniq_id <- NULL
Lapop$year <- NULL


#Reescalamiento a variables categóricas y otrs transformaciones
#Ideología
Ideologia <- Lapop$l1
Ideologia <- Recode (Ideologia, '1:2="Izquierda";3:4="Centroizquierda"; 5:6= "Centro";6:8="Centroderecha"; 9:10="Derecha";NA="NA"', as.factor.result=TRUE)
Ideologia <- as.factor(Ideologia)
#Hijos
Hijos <- Lapop$q12
Hijos <- Recode (Hijos, '0="No"; 1:15="Sí";NA="NA"', as.factor.result=TRUE)
Hijos <- as.factor(Hijos)

#Edad
Edad <- Lapop$q2
Edad <- Recode (Edad, '18:29 ="Joven"; 30:45="Adulto";46:64="Maduro";65:88="Viejo";NA="NA"', as.factor.result=TRUE)
Edad <- as.factor(Edad)

#Educación
Educacion <- Lapop$ed
Educacion <- Recode (Educacion, '0:5="Primaria";6:11="Bachillerato"; 12:18="Superior";NA="NA"', as.factor.result=TRUE)
Educacion <- as.factor(Educacion)

#Intención voto:

Lapop$colvb20 <- Recode (Lapop$colvb20, 'NA ="No Sabe";NA="NA"',as.factor.result = TRUE)
Lapop$colvb20 <- as.factor(Lapop$colvb20)
#Tratando bien los factores

rerun_factor <- function(x){
  if (is.factor(x)) return(factor(x))
  return(x)
}

Lapop <- as.data.frame(lapply(Lapop,rerun_factor))
Lapop$Name <- NULL
#################            Árboles          #########################
# La idea con los árboles es usar pocas variables socio-demográficas
#La idea de estas variables es que sean genéricas y no requieran encuestas.
#Se hace así para poder ver un poco cuales sería grupos óptimos para distribuir información.
#Se usan estas variables para reducir costos de investigación, una vez se entregue información a las campañas.
treetrain <- sample(1:nrow(Lapop), nrow(Lapop)/2)
treetest <- Lapop[-treetrain,]
Ideotest <- Ideologia[-treetrain]
Vototest <- Lapop$colvb20[-treetrain]


arbol = tree(Ideologia ~ colsisben+q2+ed+q12+prov+ocup4a+q10g+q10new+b14+b12+b20+b31+b50+e16+d5+b21a+n15+colideol4f+colrecon6+ros1+pol1,data=Lapop, minsize=0)
summary(arbol)
arbol

###Dividiendo en muestras
set.seed(2)

arboltrain <- tree(Ideologia ~ colsisben+q2+ed+q12+prov+ocup4a+q10g+q10new+b14+b12+b20+b31+b50+e16+d5+b21a+n15+colideol4f+colrecon6+ros1+pol1, data=Lapop, subset=treetrain)
predarbol <- predict(arboltrain,treetest,type="class")
table (predarbol,Ideotest)

#Usando cross validantion y cross validation con muestras diferentes
set.seed(3)
cv.arbol <- cv.tree(arbol, method="misclass")
cv.arbol
arbolpod <- prune.tree(arbol, k=6, method="misclass")

cv.train.arbol <- cv.tree(arboltrain, method="misclass")
cv.train.arbol
arbolpodtrain <- prune.tree(arboltrain,k=2.5, method = "misclass")
predarbolcv <- predict(arbolpodtrain,treetest, type="class")
table (predarbolcv,Ideotest)


cv.prunearbol <- cv.tree(arbol, FUN=prune.misclass)
cv.prunearbol
arbolprunetrain <- prune.tree(arboltrain, best=3, method = "misclass")
predarbolprune <- predict(arbolprunetrain, treetest, type="class")
table (predarbolprune,Ideotest)




#Usando la misma metodología para la intención de voto

arbol2 = tree(colvb20 ~ colsisben+q2+ed+q12+prov+ocup4a+q10g+q10new+b14+b12+b20+b31+b50+e16+d5+b21a+n15+colideol4f+colrecon6+ros1+pol1,data=Lapop, minsize=0)
summary(arbol2)
arbol2

###Dividiendo en muestras
set.seed(2)


arboltrain2 <- tree(colvb20 ~ colsisben+q2+ed+q12+prov+ocup4a+q10g+q10new+b14+b12+b20+b31+b50+e16+d5+b21a+n15+colideol4f+colrecon6+ros1+pol1, data=Lapop, subset=treetrain)
predarbol2 <- predict(arboltrain2,treetest,type="class")
table (predarbol,Vototest)

#Usando cross validantion y cross validation con muestras diferentes
set.seed(3)
cv.arbol2 <- cv.tree(arbol2, method="misclass")
cv.arbol2
arbolpod2 <- prune.tree(arbol2, k=3, method="misclass")

cv.train.arbol2 <- cv.tree(arboltrain2, method="misclass")
cv.train.arbol2
arbolpodtrain2 <- prune.tree(arboltrain2,k=5,method = "misclass")
predarbolcv2 <- predict(arbolpodtrain2,treetest, type="class")
table (predarbolcv2,Vototest)


cv.prunearbol2 <- cv.tree(arbol2, FUN=prune.misclass)
cv.prunearbol2
arbolprunetrain2 <- prune.tree(arboltrain2, best=6, method = "misclass")
predarbolprune2 <- predict(arbolprunetrain2, treetest, type="class")
table(predarbolprune2,Vototest)


##################           Random Forest       #######################

set.seed(1)
Lapop.roughfix <- na.roughfix(Lapop)
treetrain.roughfix <- na.roughfix(treetrain)
randFor <- randomForest(Ideologia~.-municipio-l1-colvb20,ntree=800, mtry=20,data=Lapop.roughfix,subset=treetrain.roughfix,importance=TRUE)
randFor
#randFortrain <- randomForest(Ideologia~.-municipio-l1-colvb20,ntree=800,mtry=20,na.action=na.roughfix, data=Lapop, subset=treetrain,importance=TRUE)
predrandFortrain <- predict(randFor, newdata=na.roughfix(treetest))
table(predrandFortrain,Ideotest)
#varImpPlot(randFortrain)
varImpPlot(randFor)

#Usando intención de voto
------------------
###### no me está dando, y este si ni idea
randFor <- randomForest(colvb20~.-municipio-l1-colvb20,ntree=800, mtry=20,data=Lapop.roughfix,subset=treetrain.roughfix,importance=TRUE)

set.seed(1)
votos=treetrain.roughfix$colvb20
randFor2 <- randomForest(colvb20~.-municipio-l1-colvb20,ntree=800, mtry=20,data=Lapop.roughfix,subset=treetrain.roughfix,importance=TRUE)
randFor2
predrandFortrain2 <- predict(randFor2, newdata=na.roughfix(treetest))
table(predrandFortrain2,Vototest)

#randFor2 <- randomForest(colvb20~.-municipio-l1, ntree=800, mtry=20, na.action=na.roughfix, data=Lapop)
#randFor2
#randFortrain2 <- randomForest(colvb20~.-municipio-l1, ntree=800, mtry=20, na.action=na.roughfix, data=Lapop, subset=treetrain)
#predrandFortrain2 <- predict(randFortrain2,treetest, type="vote", proximity=TRUE)

varImpPlot(randFortrain2)
varImpPlot(randFor2)
####### hasta aquí es que no da
-----------------------
######################       Boosting                 ###################

set.seed(1)
boost <- gbm(Ideologia~colsisben+q2+ed+q12+prov+ocup4a+q10g+q10new+b14+b12+b20+b31+b50+e16+d5+b21a+n15+colideol4f+colrecon6+ros1+pol1, data=Lapop, n.trees=5000,distribution="multinomial")
summary(boost)


predboost = predict(boost,newdata=treetest, n.trees=5000, type='response')
Ideotest <- Recode(Ideotest,'NA="NA"')
predboost
multim.pred <- apply(predboost, 1, which.max)
multim.pred <- Recode (multim.pred, '5="Izquierda";3="Centroizquierda"; 1= "Centro";2="Centroderecha"; 4="Derecha";6="NA"', as.factor.result=TRUE)
multim.pred
table(multim.pred,Ideotest)

set.seed(1)
boost2 <- gbm(colvb20~colsisben+q2+ed+q12+prov+ocup4a+q10g+q10new+b14+b12+b20+b31+b50+e16+d5+b21a+n15+colideol4f+colrecon6+ros1+pol1, data=Lapop, n.trees=5000)
summary(boost2)
predboost2 = predict(boost2,treetest, n.trees=5000, newmfinal=length(boost2$trees), type="response")
predboost2
multim.pred2 <- apply(predboost2, 1, which.max)
multim.pred2 <- Recode (multim.pred2, '8="Votaría por otro candidato";7="Oscar Iván Zuluaga"; 6= "No Sabe";5="Marta Lucía Ramírez"; 4="Juan Manuel Santos";3="José Antonio Rocha";2="Enrique Peñalosa";1="Clara López"', as.factor.result=TRUE)
multim.pred2
table(multim.pred2,Vototest)
