
rm(list=ls())
#Pongan aquí el directorio donde bajaron el archivo de Tolstoy
path="C:\\Users\\User\\Documents\\Miguel B\\Universidad\\Maestría\\Monitoría Minería de datos\\Intro R"

setwd(path)

#Leer el texto
reference=readLines("pg2600.txt")
reference=toupper(reference)

#Construir la matriz de transición
trans.mat=matrix(0,27,27)
rownames(trans.mat)=colnames(trans.mat)=c(toupper(letters),"")
lastletter=""
for (ln in 1:length(reference)) {
  if (ln %% 1000 ==0) {cat("Line",ln,"\n")}
  for (pos in 1:nchar(reference[ln])) {
    curletter=substring(reference[ln],pos,pos)
    if (curletter %in% toupper(letters)) {
      trans.mat[rownames(trans.mat)==lastletter,
                colnames(trans.mat)==curletter]=
                  trans.mat[rownames(trans.mat)==lastletter,
                            colnames(trans.mat)==curletter]+1
      lastletter=curletter
    } else {
      if (lastletter!="") {
        trans.mat[rownames(trans.mat)==lastletter,27]=
          trans.mat[rownames(trans.mat)==lastletter,27]+1
        lastletter=""
      }
    }
  }
  curletter=""
  if (lastletter!="") {
    trans.mat[rownames(trans.mat)==lastletter,27]=
      trans.mat[rownames(trans.mat)==lastletter,27]+1
  }
  lastletter=""
}

trans.prob.mat=sweep(trans.mat+1,1,rowSums(trans.mat+1),FUN="/")





#Función que decodifica un mensaje usando una función decodificadora
decode <- function(mapping,coded) {
  coded=toupper(coded)
  decoded=coded
  for (i in 1:nchar(coded)) {
    if (substring(coded,i,i) %in% toupper(letters)) {
      substring(decoded,i,i)=toupper(letters[mapping==substring(coded,i,i)])
    }
  }
  decoded
}


#Función de verosimilitud
log.prob <- function(mapping,decoded) {
  logprob=0
  
  lastletter=""
  for (i in 1:nchar(decoded)) {
    curletter=substring(decoded,i,i)
    if (curletter %in% toupper(letters)) {
      logprob=logprob+log(trans.prob.mat[rownames(trans.mat)==lastletter,
                                         colnames(trans.mat)==curletter])
      lastletter=curletter
    } else {
      if (lastletter!="") {
        logprob=logprob+log(trans.prob.mat[rownames(trans.mat)==lastletter,27])
        lastletter=""
      }
    }
  }
  
  if (lastletter!="") {
    logprob=logprob+log(trans.prob.mat[rownames(trans.mat)==lastletter,27])
    lastletter=""
  }
  logprob
}

#Texto de muestra que vamos a codificar
correctTxt="The folks who want to kill people, and that's all they want to do, are scared of knowledge. And they want to shut the doors and they don't want people to make their choices about the future. For them, it's 'You do things my way and if you don't, we'll throw acid in your face. We'll put a bullet in your face,' to a young girl trying to learn, Kerry said. So this is a huge challenge for us. It is a confrontation with modernity, with possibilities, and everything that our country stands for, everything we stand for, is embodied in what Anne Smedinghoff stood for."
#Mezclarlo de forma aleatoria
coded=decode(sample(toupper(letters)),correctTxt)
coded

#Función inicial aleatoria
mapping=sample(toupper(letters))
i=1
iters=200
cur.decode=decode(mapping,coded)
cur.loglike=log.prob(mapping,cur.decode)
max.loglike=cur.loglike
max.decode=cur.decode
cuenta=seq(0,1000,by=50)
disp=c(coded)
names(disp)=cuenta

#Correr el alogirtmo
while (i<=iters) {
  proposal=sample(1:26,2) # select 2 letters to switch
  prop.mapping=mapping
  prop.mapping[proposal[1]]=mapping[proposal[2]]
  prop.mapping[proposal[2]]=mapping[proposal[1]]
  
  prop.decode=decode(prop.mapping,coded)
  prop.loglike=log.prob(prop.mapping,prop.decode)
  
  if (runif(1)<exp(prop.loglike-cur.loglike)) {
    mapping=prop.mapping
    cur.decode=prop.decode
    cur.loglike=prop.loglike
    
    if (cur.loglike>max.loglike) {
      max.loglike=cur.loglike
      max.decode=cur.decode
    }
    
    cat(i,cur.decode,"\n")
    if(i %in% cuenta){
      disp=c(disp,cur.decode)
    }
    i=i+1
  }

}



names(disp)=cuenta[1:length(disp)]
disp

