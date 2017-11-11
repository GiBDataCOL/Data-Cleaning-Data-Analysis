##



#############a

rm(list=ls())
Auto=read.table("Auto.data",header=T,na.strings="?")
getwd()
attach(Auto)
sapply(Auto, class)
str(Auto)

############# b y c

matriz.rango=matrix(data=NA, nrow=3, ncol=9,byrow=FALSE,dimnames=NULL)
matriz.rango[1,1]="Range"
matriz.rango[2,1]="Mínimo"
matriz.rango[3,1]="Máximo"
nombres=names(Auto)

for (i in 1:8) {
  rangos=range(Auto[,i],na.rm=TRUE)
  assign(paste("Rango.",nombres[i],sep=""),rangos)
  medias=mean(Auto[,i],na.rm=TRUE)
  assign(paste("Mean.",nombres[i],sep=""),medias)
  desv=sd(Auto[,i],na.rm=TRUE)
  assign(paste("desviacion.",nombres[i],sep=""),desv)
}

sub_x=do.call("cbind", lapply(ls(pattern="Rango"), get))
matriz.rango[2:3,2:9]=sub_x

lista=ls(pattern="Rango")

for (j in 1:8){
  matriz.rango[1,j+1]=lista[j]
}

print(matriz.rango)

################ c
matriz.puntoc=matrix(data=NA, nrow=3, ncol=9,byrow=FALSE,dimnames=NULL)
matriz.puntoc[1,1]="Variable"
matriz.puntoc[2,1]="Mean"
matriz.puntoc[3,1]="Sd"
sub_x1=do.call("cbind", lapply(ls(pattern="Mean"), get))
matriz.puntoc[2,2:9]=sub_x1
sub_x2=do.call("cbind", lapply(ls(pattern="desviacion"), get))
matriz.puntoc[3,2:9]=sub_x2
lista2=ls(pattern="desviacion")
lista2=read.table(text = lista2, sep = ".", as.is = TRUE)$V2
for (j in 1:8){
  matriz.puntoc[1,j+1]=lista2[j]
}

print(matriz.puntoc)

################ d
rm(list=ls())
Auto=read.table("Auto.data",header=T,na.strings="?")
Auto=Auto[-c(10:85),]
attach(Auto)

matriz.rango=matrix(data=NA, nrow=3, ncol=9,byrow=FALSE,dimnames=NULL)
matriz.rango[1,1]="Range"
matriz.rango[2,1]="Mínimo"
matriz.rango[3,1]="Máximo"
nombres=names(Auto)

for (i in 1:8) {
  rangos=range(Auto[,i],na.rm=TRUE)
  assign(paste("Rango.",nombres[i],sep=""),rangos)
  medias=mean(Auto[,i],na.rm=TRUE)
  assign(paste("Mean.",nombres[i],sep=""),medias)
  desv=sd(Auto[,i],na.rm=TRUE)
  assign(paste("desviacion.",nombres[i],sep=""),desv)
}

sub_x=do.call("cbind", lapply(ls(pattern="Rango"), get))
matriz.rango[2:3,2:9]=sub_x

lista=ls(pattern="Rango")

for (j in 1:8){
  matriz.rango[1,j+1]=lista[j]
}

print(matriz.rango)

matriz.meansd=matrix(data=NA, nrow=3, ncol=9,byrow=FALSE,dimnames=NULL)
matriz.meansd[1,1]="Variable"
matriz.meansd[2,1]="Mean"
matriz.meansd[3,1]="Sd"
sub_x1=do.call("cbind", lapply(ls(pattern="Mean"), get))
matriz.meansd[2,2:9]=sub_x1
sub_x2=do.call("cbind", lapply(ls(pattern="desviacion"), get))
matriz.meansd[3,2:9]=sub_x2
lista2=ls(pattern="desviacion")
for (j in 1:8){
  matriz.meansd[1,j+1]=lista2[j]
}

print(matriz.meansd)

#library(rJava)
#library(xlsx)
#write.csv(matriz.rango,file="prueba.csv",append=TRUE)
#write.csv(matriz.meansd,file="prueba.csv",append=TRUE)

###########
