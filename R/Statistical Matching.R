# *** Codigo para ejecutar en R ***
rm(list=ls())
# setwd("C:/Users/nparra/Dropbox/Fedesarrollo/Brasil/Economia Informal Urbana/Datos")
setwd("/Users/nicolasgomezparra/Dropbox/Fedesarrollo/Brasil/Economia Informal Urbana/Datos")

# Preparing the datasets

library(haven)
muestra2015 <- read_dta("muestra2015.dta")
muestramatching <- read_dta("muestramatching.dta")

id2015 <- rownames(muestra2015)
muestra2015 <- cbind(id=id2015, muestra2015)

idvieja <- rownames(muestramatching)
muestramatching <- cbind(id=idvieja, muestramatching)


#install.packages("StatMatch")
library(StatMatch)        # loads pkg StatMatch
str(muestra2015)          # describing variables
str(muestramatching)      # describing variables
X.vars <- intersect(names(muestra2015), names(muestramatching))
setdiff(names(muestra2015), names(muestramatching)) # available just in A

# Selecting the matching variables and the donor classes

X.vars
donorclasses <- c("mujer","ingresos1","ingresos2","ingresos3","ingresos4","ingresos5","educacion1","educacion2","educacion3","edad1","edad2","edad3")
matchingvars <- c("perdom","ingresos","edad")

# Begin procedure
set.seed(1324)
#randommatch <- RANDwNND.hotdeck(data.rec=muestra20152, data.don=muestramatching2,match.vars=matchingvars,don.class=donorclasses,weight.don="pesopes")
#randommatch <- RANDwNND.hotdeck(data.rec=muestra2015, data.don=muestramatching,match.vars=NULL,don.class=donorclasses)
randommatch <- NND.hotdeck(data.rec=muestra2015, data.don=muestramatching,match.vars=matchingvars,don.class=donorclasses)

#fA.wrnd2 <- create.fused(data.rec=muestra2015, data.don=muestramatching,mtc.ids=randommatch$mtc.ids, z.vars="voluntario")

library(foreign)

idsmatching<-data.frame(randommatch$mtc.ids)
write.dta(idsmatching,"BaseID.dta")
write.dta(muestra2015,"BaseActual.dta")
write.dta(muestramatching,"BaseAntigua.dta")