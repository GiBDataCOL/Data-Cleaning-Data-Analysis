********************************************************************************
********************************************************************************
* 							BRASIL: PNAD Continua
********************************************************************************
********************************************************************************
log close _all
local dirresultados "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\PNAD Continua\Resultados"
log using "`dirresultados'\LogCompleto",replace
clear
set more off, perm
********************************************************************************
* Informacion general de la encuesta
********************************************************************************
/* 
Fecha de implementacion: 2011 (experimentalmente) e instaurada totalmente desde
enero de 2012 en todo el territorio nacional.

Informacion disponible: 1er Trimestre/2012 a 3er Trimestre/2016

Encargado: IBGE

Frecuencia: Mensual, Trimestral y Anual dependiendo de ciertos indicadores.
Igualmente algunas preguntas de la encuesta son incluidos arbitratiamente 
(i.e. migracion, fecundidad y trabajo infantil). Durante esta investigacion se
va a utilizar la version trimestral (no movil).

Cobertura geografica: Brazil, Major Regions, Federation Units Unidades da Federacao, 
20 Metropolitana Areas which have capital municipalities (Manaus, BelÈm, Macap·, 
Sao LuÌs, Fortaleza, Natal, Joao Pessoa, Recife, MaceiÛ, Aracaju, Salvador, 
Belo Horizonte, Vitoria, Rio de Janeiro, Sao Paulo, Curitiba, FlorianÛpolis, 
Porto Alegre, Vale do Rio Cuiab·, and Goi‚nia), Capital municipalities and 
Integrated Region for the Development of Greater Teresina.

Definicion de informalidad: en los reportes oficiales presentan el indicador
de persona "com e sem carteria de trabalho assinada". Igualmente incluyen una 
pregunta sobre contribuciones al sistema de seguridad social.

Diseno de la encuesta: Rotativa y aleatoria a nivel de domicilio, donde en un 
trimestre inmediato se solapan el 80% de los domicilios y con respecto al 
trimestre del ano anterior el 20%. El esquema de rotacion hace que un domicilio, 
una vez es visitado por primera vez, se visite 5 veces en total con intervalos 
de tres meses entre una visita y otra. El diseno de la muestra busca garantizar 
la representatividad en las diferentes coberturas geograficas de la encuesta. 
Asi, el tamano de la encuesta garantiza gran  precision de las estadistica por 
Unidades de Federacao con menor tamano de poblacion y en areas rurales.
	En cada trimestre la PNAD investiga cerca de 211000 domicilios de 
aproximadamente 16000 sectores censitarios.

Plano muestral: 
	1) Dos etapas de seleccion con estratificacion por la unidades 
primarias de muestreo (UPAs). Los UPAs estan definidos a partir del tamano de 
los sectores censitarios, donde cada una de las UPA deben tener al menos 60 
domicilios particulares permanenten (DPPs). Un sector censitario que contuviera 
de por si mas de 60 DPPs se definia inmediatamente como un UPA. El resto fueron 
agrupados dentro de un mismo subdistrito, respetando la vecindad, para contituir
los UPAs restantes.
	2) En la primera etapa fueron seleccionados los UPAs con probabilidad propor-
cional al nimero de domicilios definido en cada unidad de estratificacion.
	3) En la segunda etapa fueron seleccionados 14 domicilios particulares perma-
nentes (DPPs) ocupados dentro de cada UPA de la muestra, mediante aleatorizacion 
simple.
	Estratificaciones: 1) Por division administrativa: Unidades da a Federacao 
(UFs), Regiones Metropolitanas4 (RM) e as Regiones Integradas de Desenvolvimento 
(RIDE) de Teresina e do Distrito Federal. 2) Estratificacion geografica y 
espacial 3) Estratificacion por situacion de los UPA (rural vs urbana)
4) Estratificacion estadistica 

Notas: La PNAD continua surge como una necesidad de producir estadisticas e 
indicadores coyunturales validos nacionalmente sobre el mercado laboral y reemplaza
las estadisticas obtenidas por la PME y la PNAD. Igualmente actualiza los indica-
dores que presentan cada una de estas encuestas a partir de recomendaciones inter-
nacionales. Tambien busca evaluar las flluctuaciones trimestrales y su evolucion
a largo plazo de la fuerza de trabajo, asi como de informacion adicional que per-
mita entender el desenvolvimiento socioeconomico del pais.
	Es importante ressaltar que os indicadores resultantes da PNAD Continua estan
alineados con las iltimas recomendacionees internacionais referentes as estatisticas de
trabalho, discutidas e aprovadas na 19 Conferencia Internacional dos Estatisticos do
Trabalho, a 19 CIET, promovida pela Organizacao Internacional do Trabalho - OIT.

Documentos consultados:
Notas metodologicas PNAD Continua:
ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Notas_metodologicas/notas_metodologicas.pdf
*/


********************************************************************************
* IMPORTAR BASE DE DATOS A STATA
********************************************************************************
/*Las bases de datos se descargan desde:
http://www.ibge.gov.br/english/estatistica/indicadores/trabalhoerendimento/pnad_continua/default_microdados.shtm
Se descargan en dos formatos: sas7bdat y .txt. Utilice la que esta guardada en 
SAS, pasandola a Stata por StatTransfer.
Tambien se consiguen las publicaciones historicas de la PNAD Continua en
http://downloads.ibge.gov.br/downloads_estatisticas.htm en la parte de 
"Trabalho e emprendimiento"
*/

* local ubicacionbase "/Users/nicolasgomezparra/Dropbox/Fedesarrollo/Brasil/PNAD Continua/Datos/PNADC_042015_20161122"
/*local ubicacionbase "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\PNAD Continua\Datos\PNADC_042015_20161122"
cd "`ubicacionbase'"
use "pnadc_042015.dta",clear
compress
destring *,replace
* Guardar una version despues del destring, porque se demora un poquito en hacerlo.
save "pnadc_042015Destring.dta",replace

********************************************************************************
* IMPORTAR BASE DE DATOS A STATA en 1Q a 3Q y revisar que diferencias tiene con 4Q
********************************************************************************
* NOTA: El diccionario de variables cambia a partir del 4Q y por esto hay que
* revisar que cambios hay 

log close _all
* local ubicacionbasesrestantes "/Users/nicolasgomezparra/Dropbox/Fedesarrollo/Brasil/PNAD Continua/Datos/1Q a 3Q 2015 Stata"
local ubicacionbasesrestantes "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\PNAD Continua\Datos\1Q a 3Q 2015 Stata"
cd "`ubicacionbasesrestantes'"
log using "variablesOtrosTrimestres",replace
forvalues i=1(1)3{
use "pnadc_0`i'2015.dta",clear
destring *,replace
compress
save "pnadc_0`i'2015Destring.dta",replace
describe
}
********************************************************************************
* Append de los otros 3 trimestres (excepto el 4Q) que tienen las mismas variables
********************************************************************************
* local ubicacionbasesrestantes "/Users/nicolasgomezparra/Dropbox/Fedesarrollo/Brasil/PNAD Continua/Datos/1Q a 3Q 2015 Stata"
local ubicacionbasesrestantes "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\PNAD Continua\Datos\1Q a 3Q 2015 Stata"
cd "`ubicacionbasesrestantes'"
use "pnadc_012015Destring.dta",clear
generate byte trimestres=1
forvalues j=2(1)3{
append using "pnadc_0`j'2015Destring.dta",generate("appendQ`j'")
}
* local ubicacionbase "/Users/nicolasgomezparra/Dropbox/Fedesarrollo/Brasil/PNAD Continua/Datos/PNADC_042015_20161122"
local ubicacionbase "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\PNAD Continua\Datos\PNADC_042015_20161122"
cd "`ubicacionbase'"
append using "pnadc_042015Destring.dta",generate("appendQ4")
forvalues j=2(1)4{
replace trimestres=`j' if appendQ`j'==1
}
drop append*
* local ubicacionappend "/Users/nicolasgomezparra/Dropbox/Fedesarrollo/Brasil/PNAD Continua/Datos"
local ubicacionappend "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\PNAD Continua\Datos"
cd "`ubicacionappend'"
compress
save "PNADContinua2015.dta",replace*/

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
*		DECLARAR LA BASE DE DATOS PARA SURVEY DATA ANALYSIS (BASE COMPLETA)
********************************************************************************
********************************************************************************
********************************************************************************

* local ubicacionappend "/Users/nicolasgomezparra/Dropbox/Fedesarrollo/Brasil/PNAD Continua/Datos"
local ubicacionappend "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\PNAD Continua\Datos"
cd "`ubicacionappend'"
use "PNADContinua2015.dta",clear
keep V1029 posest
collapse (mean) V1029,by(posest)		// Promediar proyecciones de poblacion anualmente
										// para que sean constantes en la estratificacion.
rename V1029 V1029new
save "poststratification.dta",replace
/*Lo anterior corrige por las proyecciones de poblacion teniendo en cuenta el 
promedio de esas proyecciones a lo largo del ano. Es decir, cada poststrato
tiene como weight el promedio de la proyeccion de la poblacion en las 4
encuestas.*/

* local ubicacionappend "/Users/nicolasgomezparra/Dropbox/Fedesarrollo/Brasil/PNAD Continua/Datos"
local ubicacionappend "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\PNAD Continua\Datos"
cd "`ubicacionappend'"
use "PNADContinua2015.dta",clear
merge m:1 posest using "poststratification.dta"

***********	Variables utilizadas - Definiciones segun diccionario:

* upa: 		Unidade Primaria de Amostragem (UPA) que se forma UF (2) + Nimero 
*			Sequencial (6) + DV (1)
* V1028: 	Peso do domicilio e das pessoas - 6 digitos e 8 casas decimais - Peso 
* 			trimestral com correcao de nao entrevista com pos estratificacao pela 
*			projecao de populacao
* Estrato:	As 2 primeiras posicoes representam o codigo da Unidade da Federacao
* V1029:	Projecao da populacao - Projecao da populacao do trimestre (referencia: mas do meio)
* posest: 	Dominios de projecao - As 2 primeiras posicoes representam o codigo da
*			Unidade da Federacae a ultima, o tipo de area. UF(2) + V1023(1)

svyset, clear
/*Survey design: psu (upa); weights (V1028) stratification (Estrato)
	Post stratification: posest ; Population estimation: V1029
	Mas detalles publicados en R en el siguiente link: 
-> LINK A: https://github.com/ajdamico/asdfree/tree/master/Pesquisa%20Nacional%20por%20Amostra%20de%20Domicilios%20Continua
	*/
svyset upa [w=V1028], strata(Estrato) postweight(V1029new) poststrat(posest)
	gen pesopes=V1028
	local var_nomissing id_match V1028 Estrato V1029new posest pesopes

********************************************************************************
********************************************************************************
* 								DATOS NACIONALES
********************************************************************************
********************************************************************************

********************************************************************************
* PRIMERA ESTIMACION:  PET - 2015
********************************************************************************

/*
	- Pessoas em idade de trabalhar: Pessoas de 14 anos ou mais de idade na data
de referencia.
	- Semana de entrevista: È a semana de domingo a sabado, destinada ‡
realizacao das entrevistas nas unidades domiciliares de um determinado grupo
de setores.
	- Semana de referencia: È a semana de domingo a sabado que precede
a semana de entrevista. Esse periodo È utilizado, por exemplo, na captacao de
pessoas ocupadas, dias e horas trabalhados efetivamente, dedicaco ‡
atividade de producao para o proprio consumo e construcao para o proprio uso
e dedicacao ‡ atividade de cuidado de pessoas.
*/
********************************************************************************

***********	Variables utilizadas - Definiciones segun diccionario:

* V2009: 	Idade do morador na data de referencia - 0 a 130 - Idade (em anos)

	gen byte PET= (V2009>=14)
	gen byte PET2 = (V2009>=15 & V2009<=65)
svy: tab PET, count format(%13.0fc)

/*
Number of strata   =       575                Number of obs     =    2,283,038
Number of PSUs     =    16,257                Population size   =  203,867,207 (POBLACI√ìN 2015)
N. of poststrata   =        77                Design df         =       15,682

-----------------------
      PET |       count
----------+------------
        0 |  39,525,909
        1 | 164,341,298 (PET 2015)
          | 
    Total | 203,867,207
-----------------------
  Key:  count     =  weighted count
*/

********************************************************************************
* SEGUNDA ESTIMACION: PEA & PEI - Ocupados y desocupados
/*
	- Pessoas ocupadas
Sao classificadas como ocupadas na semana de referencia as pessoas que, nesse 
periodo, trabalharam pelo menos uma hora completa em trabalho remunerado em 
dinheiro, produtos, mercadorias ou benefÌcios (moradia, alimentaco, roupas, 
treinamento etc.) ou em trabalho sem remuneraco direta em ajuda ‡ atividade 
econÙmica de membro do domicÌlio ou, ainda, as pessoas que tinham trabalho 
remunerado do qual estavam temporariamente afastadas nessa semana.
Consideram-se como ocupadas temporariamente afastadas de trabalho remunerado as
pessoas que n„o trabalharam durante pelo menos uma hora completa na semana de 
referÍncia por motivo de: fÈrias, folga, jornada de trabalho vari·vel, licenca 
maternidade e fatores ocasionais. Assim, tambem foram consideradas as pessoas 
que, na data de referÍncia, estavam, por periodo inferior a 4 meses: afastadas 
do trabalho em licenca remunerada por motivo de doenca ou acidente da prÛpria 
pessoa ou outro tipo de licenca remunerada; afastadas do prÛprio empreendimento 
sem serem remuneradas por instituto de previdÍncia; em greve ou paralisaco. 
AlÈm disso, tambÈm, foram consideradas ocupadas as pessoas afastadas por motivos 
diferentes dos j· citados, desde que tivessem continuado a receber ao menos uma 
parte do pagamento e o perÌodo transcorrido do afastamento fosse inferior a 4 
meses.
	- Pessoas desocupadas
S„o classificadas como desocupadas na semana de referÍncia as pessoas sem 
trabalho nessa semana, que tomaram alguma providÍncia efetiva para consegui-lo 
no perÌodo de referÍncia de 30 dias e que estavam disponÌveis para assumi-lo na 
semana de referÍncia. Consideram-se, tambÈm, como desocupadas as pessoas sem 
trabalho na semana de referÍncia que n„o tomaram providÍncia efetiva para 
conseguir trabalho no periodo de 30 dias porque ja haviam conseguido trabalho que
iriam comecar apÛs a semana de referencia.
	- Pessoas na forca de trabalho PEA
As pessoas na forca de trabalho na semana de referÍncia compreendem as pessoas
ocupadas e as pessoas desocupadas nesse perÌodo.
	- Pessoas fora da forca de trabalho PEI
S„o classificadas como fora da forca de trabalho na semana de referÍncia as 
pessoas que n„o estavam ocupadas nem desocupadas nessa semana.
*/
********************************************************************************

***********	Variables utilizadas - Definiciones seg˙n diccionario:

* VD4002: 	Condico de ocupaco na semana de referÍncia para pessoas de 14 anos
*			ou mais de idade: 1. Pessoas ocupadas 2. Pessoas desocupadas 	
*			Missing. No Aplica
* VD4001: 	Condico em relaco ‡ forca de trabalho na semana de referÍncia para
*			pessoas de 14 anos ou mais de idade: 1. Pessoas na forca de trabalho
*			2. Pessoas fora da forca de trabalho. Missing. No aplica

gen byte occupied= (PET==1 & VD4002==1)
* svy, subpop(PET): tab occupied , count format(%13.0fc)
/*
Number of strata   =       575                Number of obs     =    2,283,038
Number of PSUs     =    16,257                Population size   =  203,867,207
N. of poststrata   =        77                Subpop. no. obs   =    1,815,494
                                              Subpop. size      =  164,341,298
                                              Design df         =       15,682

-----------------------
 occupied |       count
----------+------------
        0 |  72,200,457
        1 |  92,140,841 DATO OCUPADOS 2015
          | 
    Total | 164,341,298
-----------------------
  Key:  count     =  weighted count

*/
gen byte desocc= (PET==1 & VD4002==2)
*svy, subpop(PET): tab desocc , count format(%13.0fc)
/*
Number of strata   =       575                Number of obs     =    2,283,038
Number of PSUs     =    16,257                Population size   =  203,867,207
N. of poststrata   =        77                Subpop. no. obs   =    1,815,494
                                              Subpop. size      =  164,341,298
                                              Design df         =       15,682

-----------------------
   desocc |       count
----------+------------
        0 | 155,756,455
        1 |   8,584,843 DATO DESOCUPADOS 2015
          | 
    Total | 164,341,298
-----------------------
  Key:  count     =  weighted count
*/

gen byte PEA= (occupied==1 | desocc==1)
*svy, subpop(PET): tab PEA , count format(%13.0fc)
/*
Number of strata   =       575                Number of obs     =    2,283,038
Number of PSUs     =    16,257                Population size   =  203,867,207
N. of poststrata   =        77                Subpop. no. obs   =    1,815,494
                                              Subpop. size      =  164,341,298
                                              Design df         =       15,682

-----------------------
      PEA |       count
----------+------------
        0 |  63,615,614
        1 | 100,725,684 DATO PEA 2015
          | 
    Total | 164,341,298
-----------------------
  Key:  count     =  weighted count
*/

*svy, subpop(PET): tab VD4001 , count format(%13.0fc) // Muestra exactamente los
// resultados anteriores 

********************************************************************************
*
* 					INFORMALIDAD EN BRASIL (SEG√öN REPORTES)
*
********************************************************************************
/* Aunque en el reporte que se dio para el iltimo trimestre de 2015
no tienen un dato en particular de informalidad, el IBGE si por lo general
en los cuadernos de resultado de la PNAD Continua presentan el dato de 
personas sin Carteira de Trabalho Assinada (CTA) que es tomada por lo general
como un indicador del nivel de informalidad en el mercado laboral brasileno.
Sin embargo, esta legislacion "parece" no aplicar a todas las personas, porque
hacen la diferenciacion de con y sin CTA para empleados del sector publico, 
empleados del sector privado y trabajadores domesticos. Dejando por fuera
a los militares, los cuenta propia, los empleadores y los familiares auxiliares
dentro de la medicion de informalidad. Si se deja de lado este aspecto se tienen 
las siguientes cifras oficiales*/

/* 
Empleados en el sector privado: 	Con CTA: 78%
									Sin CTA: 22% 
Ambos datos concuerdan con los que se obtienen a continuacion.*/
gen byte empleadosprivados= (PET==1 & (VD4009==1 | VD4009==2))
* svy, subpop(empleadosprivados): proportion V4029, over(PET)

/*Survey: Proportion estimation

Number of strata =     575      Number of obs   =    2,283,038
Number of PSUs   =  16,257      Population size =  203,867,207
N. of poststrata =      77      Subpop. no. obs =      449,704
                                Subpop. size    = 45,778,558.2
                                Design df       =       15,682

      _prop_1: V4029 = 1
      _prop_2: V4029 = 2

            1: PET = 1

--------------------------------------------------------------
             |             Linearized
        Over | Proportion   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
_prop_1      |
           1 |    .779795   .0014799      .7768806     .782682
-------------+------------------------------------------------
_prop_2      |
           1 |    .220205   .0014799       .217318    .2231194
--------------------------------------------------------------
*/

/* 
Empleados en el sector piblico: 	Con CTA: 11,2%
									Sin CTA: 19,7% 
									Militares: 69,1%
Ambos datos concuerdan con los que se obtienen a continuacion.*/
gen byte empleadossecpublico= (PET==1 & (VD4009==5 | VD4009==6| VD4009==7))
* svy, subpop(empleadossecpublico): proportion VD4009, over(PET)
/*	Survey: Proportion estimation

Number of strata =     575      Number of obs   =    2,283,038
Number of PSUs   =  16,257      Population size =  203,867,207
N. of poststrata =      77      Subpop. no. obs =      128,292
                                Subpop. size    = 11,417,763.5
                                Design df       =       15,682

      _prop_1: VD4009 = 1
      _prop_2: VD4009 = 2
      _prop_3: VD4009 = 3
      _prop_4: VD4009 = 4
      _prop_5: VD4009 = 5
      _prop_6: VD4009 = 6
      _prop_7: VD4009 = 7
      _prop_8: VD4009 = 8
      _prop_9: VD4009 = 9
     _prop_10: VD4009 = 10

            1: PET = 1

--------------------------------------------------------------
             |             Linearized
        Over | Proportion   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
_prop_5      |
           1 |   .1122509   .0020875      .1082239    .1164083
-------------+------------------------------------------------
_prop_6      |
           1 |   .1968543   .0022759      .1924313    .2013535
-------------+------------------------------------------------
_prop_7      |
           1 |   .6908948   .0028418       .685297    .6964371
-------------+------------------------------------------------

*/

/* 
Empleados domesticos: 				Con CTA: 32,2%
									Sin CTA: 67,8% 
Ambos datos concuerdan con los que se obtienen a continuacion.*/
gen byte trabdomestico= (PET==1 & (VD4009==3 | VD4009==4))
* svy, subpop(trabdomestico): proportion VD4009 
/*Survey: Proportion estimation

Number of strata =     575      Number of obs   =    2,283,038
Number of PSUs   =  16,257      Population size =  203,867,207
N. of poststrata =      77      Subpop. no. obs =       63,089
                                Subpop. size    = 6,077,866.73
                                Design df       =       15,682

--------------------------------------------------------------
             |             Linearized
             | Proportion   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
VD4009       |
           3 |   .3224178   .0040955      .3144432    .3304972
           4 |   .6775822   .0040955      .6695028    .6855568
--------------------------------------------------------------

*/

********************************************************************************

/*Aunque en estos reportes que salen junto con los datos de la PNAD Continua
no se observa un indicador como tal para la informalidad. Al revisar las noticias
de Brasil se encuentran reportes de la tasa de informalidad de dos entidades:
el Ministerio de Trabajo y de IPEA (Instituto de Pesquisa Economica Aplicada). 
Las estadisticas asociadas a la primera fuente, aparentemente, sale del CAGED
(Cagastro Geral de Empregados e Desempregados). Esto hace referencia a registros
administrativos con el objetivo de ver la evolucion del empleo formal en
Brasil. Se intento darle mayor seguimiento a esta fuente de informacion, pero
todos los links estan asociados a la pagina del Ministerio de Trabajo y no
pude acceder en ningin momento.

Por otra parte, los datos presentados por el IPEA son mas faciles de acceder.
Los indicadores que surgen a partir de la PNAD Continua son los mismo reportados
por el IBGE. Sin embargo, con la PNAD (la que se descontinuo), si generaban
indicadores de Informalidad. Aunque esta encuesta no es la que se va a utilizar
si proporcionan una guia de como calcular los 3 indicadores de informalidad que
ellos estiman. Las definiciones son las siguientes:

Indicador de Informalidad I:  
	Uma das tres diferentes defini√ß√µes do grau de 
informalidade oferecidas no Ipeadata com base na Pesquisa Nacional por 
Amostra de Domicilios (Pnad) do IBGE, esta taxa corresponde ao resultado da 
seguinte divisao: (empregados sem carteira + trabalhadores por conta propria)
 / (trabalhadores protegidos + empregados sem carteira + trabalhadores por conta propria). 
 Elaboracao: Disoc/Ipea.

Indicador de Informalidad II: ESTA!!!!!!!
	Uma das tres diferentes defini√ß√µes do grau de 
informalidade oferecidas no Ipeadata com base na Pesquisa Nacional por Amostra 
de Domicilios (Pnad) do IBGE, esta taxa corresponde ao resultado da seguinte 
divisao: (empregados sem carteira + trabalhadores por conta propria + nao-remunerados) 
/ (trabalhadores protegidos + empregados sem carteira + trabalhadores por conta propria 
+ nao-remunerados + empregadores).
 Elaboracao: Disoc/Ipea.

Indicador de Informalidad III: 
	Uma das tres diferentes defini√ß√µes do grau de 
informalidade oferecidas no Ipeadata com base na Pesquisa Nacional por Amostra 
de Domicilios (Pnad) do IBGE, esta taxa corresponde ao resultado da seguinte 
divisao: (empregados sem carteira + trabalhadores por conta propria) / 
(trabalhadores protegidos + empregados sem carteira + trabalhadores por conta 
propria + empregadores). 
Elaboracao: Disoc/Ipea.

* Nota: Sao considerados protegidos os trabalhadores com carteira de trabalho 
assinada ‚Äì inclusive os trabalhadores domesticos ‚Äì e os militares e estatutarios.
Por ahora se va a asumir que un trabajador no remunerado hace referencia a los 
trabajadores familiares auxiliares.

A continuacion estimare las tres definiciones que proporciona el IPEA, pero 
con la PNAD Continua en el ultimo trimestre de 2015.*/

gen byte informalesDEFI= ((VD4009==2 | VD4009==4 | VD4009==6 | VD4009==9))
#delimit ;
gen byte denominadorDEFI= (PET==1 & (VD4009==2 | VD4009==4 | VD4009==6 | VD4009==9 
| VD4009==1 | VD4009==3 | VD4009==5 | VD4009==7));
#delimit cr
*svy, subpop(denominadorDEFI): proportion informalesDEFI, over(PET) /*45.2%*/
*svy, subpop(occupied): proportion informalesDEFI, over(PET) /*42%*/

* INFORMALIDAD DEFINICI√ìN I: 45,2% !!!!!!!!!!!!!!!
/*Survey: Proportion estimation
Number of strata =     575      Number of obs   =    2,283,038
Number of PSUs   =  16,257      Population size =  203,867,207
N. of poststrata =      77      Subpop. no. obs =      914,258
                                Subpop. size    = 85,519,798.7
                                Design df       =       15,682

      _prop_1: informalesDEFI = 0
      _prop_2: informalesDEFI = 1

            1: PET = 1
--------------------------------------------------------------
             |             Linearized
        Over | Proportion   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
_prop_1      |
           1 |   .5475648   .0014783      .5446655    .5504609
-------------+------------------------------------------------
_prop_2      |
           1 |   .4524352   .0014783      .4495391    .4553345
--------------------------------------------------------------

*/

gen byte informalesDEFII= (VD4009==2 | VD4009==4 | VD4009==6 | VD4009==9 | VD4009==10)
#delimit ;
gen byte denominadorDEFII= (VD4009==2 | VD4009==4 | VD4009==6 | VD4009==9 
| VD4009==1 | VD4009==3 | VD4009==5 | VD4009==7
| VD4009==10 | VD4009==8);
#delimit cr
*svy, subpop(denominadorDEFII): proportion informalesDEFII, over(PET) /*44.8%*/ 
*svy, subpop(occupied): proportion informalesDEFII, over(PET) /*44.8*/

/*INFORMALIDAD DEFINICION II: 44,8% !!!!!!!!!!!!!!!!
Survey: Proportion estimation
Number of strata =     575      Number of obs   =    2,283,038
Number of PSUs   =  16,257      Population size =  203,867,207
N. of poststrata =      77      Subpop. no. obs =      996,574
                                Subpop. size    = 92,140,841.2
                                Design df       =       15,682

      _prop_1: informalesDEFII = 0
      _prop_2: informalesDEFII = 1

	  1: PET = 1

--------------------------------------------------------------
             |             Linearized
        Over | Proportion   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
_prop_1      |
           1 |   .5518607   .0014647       .548988    .5547299
-------------+------------------------------------------------
_prop_2      |
           1 |   .4481393   .0014647      .4452701     .451012
--------------------------------------------------------------
*/

gen byte informalesDEFIII= ((VD4009==2 | VD4009==4 | VD4009==6 | VD4009==9))
#delimit ;
gen byte denominadorDEFIII= (PET==1 & (VD4009==2 | VD4009==4 | VD4009==6 | VD4009==9 
| VD4009==1 | VD4009==3 | VD4009==5 | VD4009==7
| VD4009==8));
#delimit cr
*svy, subpop(denominadorDEFIII): proportion informalesDEFIII, over(PET) /*43.2%*/ 
*svy, subpop(occupied): proportion informalesDEFIII, over(PET) /*42%*/

/*INFORMALIDAD DEFINICION III: 43,2% !!!!!!!!!!!!!!!!
Survey: Proportion estimation

Number of strata =     575      Number of obs   =    2,283,038
Number of PSUs   =  16,257      Population size =  203,867,207
N. of poststrata =      77      Subpop. no. obs =      951,805
                                Subpop. size    = 89,541,075.8
                                Design df       =       15,682

      _prop_1: informalesDEFIII = 0
      _prop_2: informalesDEFIII = 1

            1: PET = 1
--------------------------------------------------------------
             |             Linearized
        Over | Proportion   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
_prop_1      |
           1 |   .5678836   .0014371      .5650645    .5706983
-------------+------------------------------------------------
_prop_2      |
           1 |   .4321164   .0014371      .4293017    .4349355
--------------------------------------------------------------
*/

/*Los resultados anteriores no se pueden comparar con los resultados que presenta 
el IPEA, porque solamente estan disponibles hastas 2014 y ademas son anuales.
De todas maneras, esta fuente de informacion es importante por dos razones. La 
primera es que ofrecen definiciones de la informalidad en Brasil que, al parecer,
son utilizadas para la estadisticas oficiales. Es necesario resaltar que las 
tres definiciones toman a los trabajadores por cuenta propia como informales.
Por otra parte, la segunda razon es que ofrecen una serie de tasa de informalidad 
desde 1992 hasta el 2014 con la PNAD (Antigua), lo cual permitiria realizar los
analisis de ciclicidad de las series de informalidad. Esta informacion se encuentra 
en el link http://www.ipeadata.gov.br/Default.aspx -> Social-> Temas-> Mercado de Trabalho.*/

*******************************************************************************
*
*						PRIMERAS ESTIMACIONES PROPIAS
*
*******************************************************************************

********************************************************************************
********************************************************************************
************ 					APORTES A SS                        ************ 
********************************************************************************
********************************************************************************
/* Generar definicion de quienes aportan y quienes no en el trabajo principal, segin
la variable derivada que presenta la IBGE para ver si aportan en cualquiera de 
los trabajos que tiene: */
* CREAR VARIABLE CATEGORICA
gen byte principal_contribuye=.
* CONTRIBUYE = 1
replace principal_contribuye=1 if ((V4012==3 & V4029==1) | (V4012==1 & V4029==1) ///
| (V4012==4 & V4029==1)| (V4012==2 | (V4012==4 & V4028==1)) | (V4032==1 & V4012==3 & V4029==2) ///
| (V4032==1 & V4012==1 & V4029==2) | (V4032==1 & V4012==4 & V4029==2) ///
| (V4032==1 & V4012==5) | (V4032==1 & V4012==6))
* NO CONTRIBUYE = 2
replace principal_contribuye=2 if ((V4012!=3 & V4012!=1 & V4012!=4) | V4029 !=1) & ///
(V4012 !=2 & (V4012 !=4 | V4028 !=1)) & ///
(V4032!=1 | (V4012==1 | V4012==2 | V4012==4 | V4012==5 | V4012==6) | V4029 !=2) & ///
(V4032!=1 | (V4012==4 | V4012==2 | V4012==3 | V4012==5 | V4012==6) | V4029 !=2) & ///
(V4032!=1 | (V4012==1 | V4012==2 | V4012==3 | V4012==5 | V4012==6) | V4029 !=2) & ///
(V4032!=1 | (V4012==1 | V4012==2 | V4012==3 | V4012==4 | V4012==6)) & ///
(V4032!=1 | (V4012==1 | V4012==2 | V4012==3 | V4012==4 | V4012==5))
#delimit ;
label define contribuciones 	1 "SI"
								2 "NO";
#delimit cr
label values principal_contribuye contribuciones

********************************************************************************
********************************************************************************
************ 					INFORMALIDAD                        ************ 
********************************************************************************
********************************************************************************

* Medida de referencia: Trabajadores sin CTA (solo a los que aplica)
/*svy, subpop(occupied): proportion V4029 /*30.0%*/
svy, subpop(occupied): proportion V4029, over(occupied20) /*27.2%*/
svy, subpop(occupied): proportion V4029, over(edad25a55 occupied20) /*24.0%*/
*/
* Medida de referencia: Trabajadores que no aportan a jubilaciones en el trabajo principal
* colocando a los no remunerados como no contribuyentes

/*svy, subpop(occupied): proportion principal_contribuye /*35.13%*/
svy, subpop(occupied): proportion principal_contribuye, over( occupied20) /*31.8%*/
svy, subpop(occupied): proportion principal_contribuye, over( edad25a55 occupied20) /*28.5%*/

svy, subpop(occupied): proportion principal_contribuye, over(restricciones VD4008) /*%*/

* Medida de la IPEA (referencia) - Definici√≥n II

svy, subpop(occupied): proportion informalesDEFII /*44.8*/
svy, subpop(occupied): proportion informalesDEFII, over(occupied20) /*41.6%*/
svy, subpop(occupied): proportion informalesDEFII, over(edad25a55 occupied20) /*38.8%*/
*/
* Crear variable con nuestras CATEGORIAS OCUPACIONALES
gen byte ocupaciones=.
	replace ocupaciones=1 if VD4008==1 | VD4008==2 | VD4008==3
	replace ocupaciones=2 if VD4008==4 | VD4008==5
	replace ocupaciones=3 if VD4008==6
	
#delimit ;
	label define ocupaciones 	1 "Asalariados"
								2 "Independ."
								3 "No remun.";
#delimit cr

	label values ocupaciones ocupaciones
	tab occupied ocupaciones,m

* Crear variable con nuestros rangos de edad
gen byte rangosdeedad=.
	replace rangosdeedad=1 if (V2009<25)
	replace rangosdeedad=2 if (V2009>=25 & V2009<=55)
	replace rangosdeedad=3 if (V2009>55)

#delimit ;
	label define rangosdeedad 	1 "Menos de 25"
								2 "25 a 55"
								3 "Mas de 55";
#delimit cr

	label values rangosdeedad rangosdeedad

********************************************************************************

* Porcentajes de las categor√≠as ocupacionales dentro de los ocupados
/*svy, subpop(occupied): proportion restricciones, over(VD4008)
svy, subpop(occupied): proportion restricciones, over(ocupaciones)
* Medicion de la IPEA por nuestras categor√≠as ocupacionales
svy, subpop(occupied): proportion informalesDEFII, over(occupied20 rangosdeedad VD4008)
svy, subpop(occupied): proportion informalesDEFII, over(occupied20 rangosdeedad ocupaciones)

* Medicion de contribuciones por nuestras categor√≠as ocupacionales
svy, subpop(occupied): proportion principal_contribuye, over(occupied20 rangosdeedad ocupaciones)


svy, subpop(PET): proportion occupied
svy, subpop(occupied): proportion occupied20
svy, subpop(occupied): proportion principal_contribuye,over(occupied20)
svy, subpop(occupied): proportion rangosdeedad,over(occupied20)
svy, subpop(occupied): proportion principal_contribuye,over(occupied20 rangosdeedad)
*/
********************************************************************************
********************************************************************************
********************************************************************************
*						VARIABLES DEMOGRAFICAS
********************************************************************************
********************************************************************************
********************************************************************************

//////////////////////////////////////////////////////////////////////////
* EDAD (V2009)
//////////////////////////////////////////////////////////////////////////
gen edad=V2009
	* Crear variable categorica de rangos de edad
			gen byte rangosdeedad2=.
				replace rangosdeedad2=1 if (V2009<25) 
				replace rangosdeedad2=2 if (V2009>=25 & V2009<=55) 
				replace rangosdeedad2=3 if (V2009>55)
			#delimit ;
				label define rangosdeedad2 	1 "Menos de 25"
											2 "25 a 55"
											3 "Mas de 55";
			#delimit cr
				label values rangosdeedad2 rangosdeedad2
	* Crear dummies para cada rango de edad
			forvalues i=1(1)3{
					gen byte edad`i'= (rangosdeedad2==`i')
					}
			*
local var_nomissing `var_nomissing' edad*

//////////////////////////////////////////////////////////////////////////
* EDUCACI√ìN
//////////////////////////////////////////////////////////////////////////
* Variable: VD3001. Se pueden revisar tambi√©n: V3009A (cambia entre trimestres)
/* Nivel de instrucao mais elevado alcan√ßado (pessoas de 5 anos ou mais de idade)	1	Sem instru√ß√£o
	2	Fundamental incompleto ou equivalente
	3	Fundamental completo ou equivalente
	4	M√©dio incompleto ou equivalente
	5	M√©dio completo ou equivalente
	6	Superior incompleto ou equivalente
	7	Superior completo 
		Nao aplic√°vel*/

	* Crear variable categorica de rangos de educaci√≥n
			gen byte rangosdeeducacion=.
				replace rangosdeeducacion=1 if (VD3001==1 | VD3001==2 | VD3001==3 | VD3001==4)
				replace rangosdeeducacion=2 if (VD3001==5)
				replace rangosdeeducacion=3 if (VD3001==6 | VD3001==7)
			#delimit ;
			label define rangosdeeducacion 	1 "Fundamental o menos (<=9)"
											2 "Medio"
											3 "Superior";
			#delimit cr
			label values rangosdeeducacion rangosdeeducacion
	* Crear dummies para cada rango de educaci√≥n
			forvalues i=1(1)3{
					gen byte educacion`i'= (rangosdeeducacion==`i')
					}
			*
local var_nomissing `var_nomissing' educacion*
//////////////////////////////////////////////////////////////////////////
* SEXO
//////////////////////////////////////////////////////////////////////////
			gen byte mujer= (V2007==2)
local var_nomissing `var_nomissing' mujer
//////////////////////////////////////////////////////////////////////////
* RAZA
//////////////////////////////////////////////////////////////////////////
* Variable: V2010
/*
	Cor ou ra√ßa	1	Branca
				2	Preta (negro)
				3	Amarela (amarilla)
				4	Parda (marron)
				5	Indigena
				9	Ignorado
*/
* Crear variable categ√≥rica de rangos de localidad
			gen byte raza=.
			replace raza=1 if (V2010==1)
			replace raza=2 if (V2010==2)
			replace raza=3 if (V2010==3 | V2010==4)
			replace raza=4 if (V2010==5 | V2010==9)
			#delimit ;
			label define raza	 	1 "Branca"
									2 "Preta"
									3 "Amarela y parda"
									4 "Otros (indigenas y missings)";
			#delimit cr
			label values raza raza
	
		* Crear dummies para cada tipo de raza
			forvalues i=1(1)4{
					gen byte raza`i'= (raza==`i')
					}
			*
		gen noblanco=1
		replace noblanco=0 if (raza==2|raza==3|raza==4)

local var_nomissing `var_nomissing' raza* noblanco		

//////////////////////////////////////////////////////////////////////////
* PARENTESCO
//////////////////////////////////////////////////////////////////////////
			gen byte mjefe= (mujer==1 & V2005==1)
			gen byte mnojefe= (mujer==1 & V2005!=1)
			
			gen byte mconyuge= (mujer==1 & (V2005==2|V2005==3))
			gen byte mnoconyuge= (mujer==1 & V2005!=2 & V2005!=3)
			
			gen byte mconyuge3pers= (mujer==1 & (V2005==2|V2005==3) & V2001>=3)
			gen byte mnoconyuge3pers = (mujer==1 & mconyuge3pers==0)

local var_nomissing `var_nomissing' mjefe mnojefe mconyuge mnoconyuge		

//////////////////////////////////////////////////////////////////////////
* TIPO DE LOCALIDAD
//////////////////////////////////////////////////////////////////////////
* Variable: V1023. Una opci√≥n ser√≠a ver las proyecciones de poblaci√≥n, pero
* est√°n para regiones muy grandes. 
/*
Tipo de √°rea	1	Capital
				2	Resto da RM (Regi√£o Metropolitana, excluindo a capital)
				3	Resto da RIDE (Regi√£o Integrada de Desenvolvimento Econ√¥mico, excluindo a capital) 
				4	Resto da UF  (Unidade da Federa√ß√£o, excluindo a regi√£o metropolitana e a RIDE)
*/
	* Crear variable categorica de rangos de localidad
			gen byte localidades=.
				replace localidades=1 if (V1023==1 | V1023==2)
				replace localidades=2 if (V1023==3)
				replace localidades=3 if (V1023==4)
				
			#delimit ;
			label define localidades	 	1 "RM (incluyendo capital)"
											2 "RIDE (sin capital)"
											3 "UF (sin RM, ni RIDE)";
			#delimit cr
			label values localidades localidades


	* Crear dummies para cada tipo de area
			forvalues i=1(1)3{
					gen byte area`i'= (V1023==`i')
					}
			*
	* Crear variable dummy de area metropolitana para que sea homogenea con la de 
	* Econom√≠a Informal Urbana 2003
		gen byte metropolitan= (localidades==1)
		gen byte rural= (localidades==3)
		
local var_nomissing `var_nomissing' metropolitan rural	

//////////////////////////////////////////////////////////////////////////
* CUENTA PROPIA(variable VD4007)
//////////////////////////////////////////////////////////////////////////
			gen byte cuentapropia= (VD4007==3)
local var_nomissing `var_nomissing' cuentapropia	

//////////////////////////////////////////////////////////////////////////
* CONSTITUCI√ìN JUR√çDICA (variable V4019)
//////////////////////////////////////////////////////////////////////////
			gen byte CNJ= (V4019==1)
local var_nomissing `var_nomissing' CNJ	

//////////////////////////////////////////////////////////////////////////
* PERSONAS EN EL DOMICILIO (variable V2001)
//////////////////////////////////////////////////////////////////////////
			gen byte perdom=V2001
			replace perdom=1 if V2001==.
local var_nomissing `var_nomissing' perdom		
			
//////////////////////////////////////////////////////////////////////////
* PRODUCTIVIDAD
//////////////////////////////////////////////////////////////////////////

	* Dummies de productividad
	global controleslogit edad educacion1 educacion3 mjefe mnojefe  ///
 noblanco metropolitan cuentapropia CNJ perdom rural 

	svy: tobit VD4016 ${controleslogit} if !mi(VD4016) & VD4016>0, ll(0)
	predict imputed

	* crear una serie total de ingresos (imputando los ingresos de los que no los tienen)

	gen ingresos=VD4016
		replace ingresos=imputed if mi(VD4016)
		replace ingresos=0 if ingresos<0
	
	xtile pct = ingresos, n(5)
	tab pct, gen(ingresos)

	/* twoway (kdensity ingresos if ingresos>0 & ingresos<10000, lpattern(dash)) ///
	(kdensity VD4016 if VD4016>0 & VD4016<10000, lpattern(solid)), legend(order( 1 "ingresos"  2 "VD4016") ///
	rows(1)) ytitle(densidad) xtitle(Income) ///
	title(Imputed vs observed)*/
	
	svy: mean ingresos, cformat(%5.3fc) over(uf)
	sum ingresos

	gen byte masproductivas= (uf==53 | uf==35 | uf==33)
	*label variable masproductivas "3 estados mas productivos"
	gen byte menosproductivas= (uf==22 | uf==15 | uf==21)
	*label variable menosproductivas "3 estados menos productivos"
	
	local productividad masproductivas menosproductivas

	local var_nomissing `var_nomissing' *productivas ingresos*	

********************************************************************************
********************************************************************************
********************************************************************************
*								MULTILOGIT
********************************************************************************
********************************************************************************
********************************************************************************
gen byte informalescontribuyente= (PET==1 & principal_contribuye==2 & occupied==1)
*gen byte informalescontribuyente= (PET==1 & occupied==1 & ((ocupaciones==1 & principal_contribuye!=1) | ((ocupaciones==2 & (principal_contribuye!=1 & (V4019!=1)))) | (ocupaciones==3)))

gen estado=.
	replace estado=1 if VD4002==2 & PET==1
	replace estado=2 if VD4002==1 & informalescontribuyente==0 & PET==1
	replace estado=3 if VD4002==1 & informalescontribuyente==1 & PET==1
	replace estado=4 if VD4001==2 & PET==1
			#delimit ;
			label define estado 	1 "Desocupados"
									2 "Formales"
									3 "Informales"
									4 "Inactivos";
			#delimit cr
			label values estado estado
			
/*Comprobar missings:*/	tab estado PET,m
/*ESTIMACION*/			svy, subpop(PET2): tab estado

local productividad masproductivas menosproductivas
local Xmlogit2 edad1 edad3 educacion1 educacion3 mconyuge mnoconyuge perdom rural `productividad'

* Multilogit
eststo clear
set more off, perm
eststo: svy, subpop(PET2): mlogit estado `Xmlogit2', baseoutcome(2)
esttab using "Multilogit", csv eform unstack replace constant cells(b(star fmt(3)) se(par("[""]") ///
	fmt(3))) legend label varlabels(_cons constant) stats(F pr2 N N_pop , fmt(3) ) ///
	star (* 0.1 ** 0.05 *** 0.001)

* Margins del multilogit
eststo clear
svy, subpop(PET2): mlogit estado `Xmlogit2', baseoutcome(2)
eststo: margins, dydx(*) predict(outcome(2)) post
esttab using "Margins_multilogitLEGAL", csv unstack replace constant cells(b(star fmt(3)) se(par("[""]") ///
	fmt(3))) legend label varlabels(_cons constant) stats(F pr2 N N_pop , fmt(3) ) ///
	star (* 0.1 ** 0.05 *** 0.001)

********************************************************************************
********************************************************************************
********************************************************************************
*							TIPOS DE INFORMALIDAD
********************************************************************************
********************************************************************************
********************************************************************************


//////////////////////////////////////////////////////////////////////////
* Voluntario
//////////////////////////////////////////////////////////////////////////
preserve
	local ubicaciondoECINF "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\Economia Informal Urbana"
	quietly: do "`ubicaciondoECINF'\brasil Economia Informal Urbana.do"
	*doedit "`ubicaciondoECINF'\brasil Economia Informal Urbana.do"
	tempfile ECINFMatching
	save `ECINFMatching'
restore

cap drop voluntario involuntario
append using `ECINFMatching',keep($variablesAPPEND) generate(APPEND)

svyset,clear
svyset [pweight=pesopes], vce(linearized) singleunit(missing)

svy: logit involuntario ${controleslogit} if PET==1 & informalescontribuyente==1
predict involuntariopredict if informalescontribuyente==1
gen byte involuntarioExpans = (involuntariopredict>0.5)
	*replace involuntarioExpans=1 if ocupaciones==1 

svy: logit voluntario ${controleslogit} if PET==1 & informalescontribuyente==1
predict voluntariopredict if informalescontribuyente==1
gen byte voluntarioExpans = (voluntariopredict>0.5)
	*replace voluntarioExpans=0 if ocupaciones==1

local Xmlogit2 edad1 edad3 educacion1 educacion3 mconyuge mnoconyuge perdom rural masproductivas menosproductivas
eststo clear
eststo: svy: logit voluntario `Xmlogit2' if PET2==1 & informalescontribuyente==1
esttab using "Logit2003", csv eform unstack replace constant cells(b(star fmt(3)) se(par("[""]") ///
	fmt(3))) legend label varlabels(_cons constant) stats(F pr2 r2_p N N_pop , fmt(3) ) ///
	star (* 0.1 ** 0.05 *** 0.001) title("Logit preferencias para muestra ECINF2003")

drop if APPEND!=0

***************************
* ESTIMACIONES SIN LA ECINF
***************************

svyset,clear
svyset upa [w=V1028], strata(Estrato) postweight(V1029new) poststrat(posest)

svy, subpop(informalescontribuyente): proportion voluntarioExpans if PET2==1
svy, subpop(informalescontribuyente): proportion involuntarioExpans if PET2==1

local Xmlogit2 edad1 edad3 educacion1 educacion3 mconyuge mnoconyuge perdom rural masproductivas menosproductivas

eststo clear
eststo: svy: logit voluntarioExpans `Xmlogit2' if PET2==1 & informalescontribuyente==1
esttab using "Logit2015", csv eform unstack replace constant cells(b(star fmt(3)) se(par("[""]") ///
	fmt(3))) legend label varlabels(_cons constant) stats(F pr2 r2_p N N_pop , fmt(3) ) ///
	star (* 0.1 ** 0.05 *** 0.001) title("Logit preferencias para muestra ECINF2015")

***************************
* MATCHING 2.0
***************************

gen id_match=_n
duplicates report id_match

	tab informalescontribuyente ocupaciones
preserve
		tab informalescontribuyente ocupaciones,m
	keep if informalescontribuyente==1
		tab informalescontribuyente occupied,m
	/*ASALARIADOS: DECIDIR*/
	* keep if ocupaciones==2 | ocupaciones==3
		tab informalescontribuyente ocupaciones,m
	display as red "`var_nomissing'"
		misstable summarize `var_nomissing' /* Corregir variables que tengan missings */
	keep `var_nomissing'
	compress
	save muestra2015.dta,replace
restore
e

local dir_matching "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\Economia Informal Urbana\Datos"
save "`dir_matching'\base_prematching.dta",replace
/*
***************************
***************************
***************************
***************************
***************************
*** Codigo para ejecutar en R ***
ES NECESARIO CORRER EL C√ìDIGO ANTES DE SEGUIR
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
matchingvars <- c("perdom","ingresos")

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

# Comparing marginal distribution of voluntario using weights
tt.0w <- xtabs(pesopes~voluntario, data=muestramatching)
tt.fw <- xtabs(pesopes~voluntario, data=fA.wrnd)
c1 <- comp.prop(p1=tt.fw, p2=tt.0w, n1=nrow(fA.wrnd), ref=TRUE)
c1$meas
*/
local dir_matching "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\Economia Informal Urbana\Datos"
use "`dir_matching'\base_prematching.dta",clear
cd "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\Economia Informal Urbana\Datos"

preserve
	local dir_matching "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\Economia Informal Urbana\Datos"
	
	use "`dir_matching'\BaseAntigua.dta",clear
		cap rename id don_id
		sort don_id
	save "`dir_matching'\BaseAntigua.dta",replace

	use "`dir_matching'\BaseID.dta",clear
		sort rec_id
	save "`dir_matching'\BaseID.dta",replace

	use "`dir_matching'\BaseActual.dta",clear
		sort id
		rename id rec_id
	merge 1:1 rec_id using "`dir_matching'\BaseID.dta",nogen
		sort don_id
	merge m:1 don_id using "`dir_matching'\BaseAntigua.dta",keepusing(voluntario)
		drop if _merge==2
		keep id_match voluntario
		sort id_match
		duplicates report id_match
		tab voluntario,m
	save "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\Matching\BaseMatchingNND.dta",replace
restore

	cap drop voluntario 
	cap drop _merge
	sort id_match
merge 1:1 id_match using "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\Matching\BaseMatchingNND.dta",keepusing(voluntario) gen(mergematch)
	tab ocupaciones voluntario if informalescontribuyente==1,m
/*ASALARIADOS: DECIDIR*/	
* replace voluntario=0 if ocupaciones==1
	tab ocupaciones voluntario if informalescontribuyente==1,m
	tab voluntario informalescontribuyente,m

svy, subpop(informalescontribuyente): proportion voluntario if PET2==1 & (ocupaciones==2 | ocupaciones==3)
svy, subpop(informalescontribuyente): proportion voluntario if PET2==1

	compress
save "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\Matching\PNADContinua2015conMatching.dta",replace
e
***************************
* FINAL MATCHING 2.0
***************************
use "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\Matching\PNADContinua2015conMatching.dta",clear
cd "C:\Users\nparra\Dropbox\Fedesarrollo\Brasil\Economia Informal Urbana\Datos"

//////////////////////////////////////////////////////////////////////////
* Subsistencia
//////////////////////////////////////////////////////////////////////////
gen salariominimo=788
	replace salariominimo=(1032.2+1070.33+1111.04+1192.45)/4 if uf==41 /*Paran√°*/
	replace salariominimo=(953.47 +988.60 +1023.70 +1058.89 +1090.97 +1282.94 +1772.27 +2432.72)/8 if uf==33 /*Rio de Janeiro*/
	replace salariominimo=(1006.88 +1030.06 +1053.42 +1095.02 +1276)/5 if uf==43 /*Rio Grande do Sul*/
	replace salariominimo=(905+920)/2 if uf==35 /*Sao Paulo*/
	replace salariominimo=(908 +943 +994 +1042)/4 if uf==42 /*Santa Catarina*/

gen byte subsistencia= (ingresos<=salariominimo*(0.85) & informalescontribuyente==1)
svy, subpop(informalescontribuyente): proportion subsistencia if PET2==1

* Segunda medida: mediana

drop subsistencia
epctile ingresos, percentiles(50) subpop(if occupied==1) svy
return list
matrix define epctileresults=r(table)
scalar medianaingresos=epctileresults[1,1]
display "La mediana de ingresos es " medianaingresos
gen byte subsistencia= (ingresos<= medianaingresos*0.7 & informalescontribuyente==1) 
svy, subpop(informalescontribuyente): proportion subsistencia if PET2==1

//////////////////////////////////////////////////////////////////////////
* Inducido
//////////////////////////////////////////////////////////////////////////
*gen byte inducido= (subsistencia==0 & voluntarioExpans==0 & informalescontribuyente==1)
gen byte inducido= (subsistencia==0 & voluntario==0 & informalescontribuyente==1)

//////////////////////////////////////////////////////////////////////////
* Mixto
//////////////////////////////////////////////////////////////////////////
*gen byte mixto= (subsistencia==1 & voluntarioExpans==1 & informalescontribuyente==1)
gen byte mixto= (subsistencia==1 & voluntario==1 & informalescontribuyente==1)

********************************************************************************
*						TIPOS DE INFORMALIDAD (categ√≥rica)
********************************************************************************

gen byte tip_inf=.
	replace tip_inf=1 if subsistencia==1
	replace tip_inf=2 if inducido==1
	* replace tip_inf=3 if voluntarioExpans==1
	replace tip_inf=3 if voluntario==1
	replace tip_inf=4 if mixto==1
#delimit ;
			label define tip_inf 	1 "Subsistencia"
									2 "Inducido"
									3 "Voluntarios"
									4 "Mixto";
			#delimit cr
			label values tip_inf tip_inf

gen tip_inf2=tip_inf
	replace tip_inf=5 if estado==2
	replace tip_inf=6 if estado==1
	replace tip_inf=7 if estado==4
	label define tip_inf 5 "Formal",add
	label define tip_inf 6 "Desocupado",add
	label define tip_inf 7 "Inactivo",add
	replace tip_inf=. if tip_inf==0

gen poblaciontipos= (tip_inf!=.)	
	
tab tip_inf informalescontribuyente,m

eststo clear
svy, subpop(informalescontribuyente):proportion tip_inf if PET2==1
esttab using "Tipos de informalidad", csv replace b(%5.2fc)

local productividad masproductivas menosproductivas
local Xmlogit2 edad1 edad3 educacion1 educacion3 mconyuge mnoconyuge perdom rural `productividad'

* Multilogit
eststo clear
set more off, perm
eststo: svy, subpop(poblaciontipos): mlogit tip_inf `Xmlogit2', baseoutcome(5)
esttab using "MultilogitTIPOS", csv eform unstack replace constant cells(b(star fmt(3)) se(par("[""]") ///
	fmt(3))) legend label varlabels(_cons constant) stats(F pr2 N N_pop , fmt(3) ) ///
	star (* 0.1 ** 0.05 *** 0.001)

/* Margins del multilogit
eststo clear
svy, subpop(poblaciontipos): mlogit tip_inf `Xmlogit2', baseoutcome(5)
eststo: margins, dydx(*) predict(outcome(2)) post
esttab using "Margins_multilogitLEGALTIPOS", csv unstack replace constant cells(b(star fmt(3)) se(par("[""]") ///
	fmt(3))) legend label varlabels(_cons constant) stats(F pr2 N N_pop , fmt(3) ) ///
	star (* 0.1 ** 0.05 *** 0.001)*/
	
********************************************************************************
********************************************************************************
********************************************************************************
*							PRESENTACI√ìN: DATOS
********************************************************************************
********************************************************************************
********************************************************************************
gen byte ocupadosPETrestringida=(PET2==1 & occupied==1)
gen byte informalDEFIIrestringida=(PET2==1 & informalesDEFII)
gen byte nocontribuyentesPETrestringida=(PET2==1 & informalescontribuyente==1)
gen byte ocupaciones2=.
	replace ocupaciones2=1 if VD4008==1 | VD4008==2 | VD4008==3
	replace ocupaciones2=2 if VD4008==4 
	replace ocupaciones2=3 if VD4008==5
	replace ocupaciones2=4 if VD4008==6
		#delimit ;
		label define ocupaciones2 	1 "Asalariados"
									2 "Emplead."
									3 "Cuenta propia"
									4 "No remun.";
		#delimit cr
		label values ocupaciones2 ocupaciones2

/*
svy,subpop(ocupadosPETrestringida): proportion informalesDEFII
svy,subpop(ocupadosPETrestringida): proportion informalescontribuyente

svy: proportion PET
svy: proportion PET2

svy,subpop(PET): proportion PEA
svy,subpop(PET2):proportion PEA

svy,subpop(PEA):proportion desocc
svy,subpop(PEA):proportion desocc if PET2==1

svy,subpop(occupied): proportion ocupaciones2
svy,subpop(ocupadosPETrestringida): proportion ocupaciones2

svy,subpop(occupied): proportion informalesDEFII
svy,subpop(ocupadosPETrestringida): proportion informalescontribuyente

svy,subpop(occupied): proportion informalesDEFII,over(ocupaciones2)
svy,subpop(ocupadosPETrestringida): proportion informalescontribuyente,over(ocupaciones2)

svy,subpop(occupied): proportion informalesDEFII,over(rangosdeedad2)
svy,subpop(ocupadosPETrestringida): proportion informalescontribuyente,over(rangosdeedad2)

	gen byte mediajornada=(V4039<20)
svy,subpop(occupied): proportion informalesDEFII,over(mediajornada)
svy,subpop(ocupadosPETrestringida): proportion informalescontribuyente,over(mediajornada)
*/

preserve
	drop if PET2!=1
	keep upa V1028 Estrato V1029new posest pesopes edad1 edad2 edad3 educacion1 educacion2 educacion3 mconyuge mnoconyuge perdom rural masproductivas menosproductivas informalescontribuyente estado tip_inf
	misstable summarize /*Estos son los √∫nico que podr√≠an tener missing: tip_inf informalescontribuyente*/
	rename V1028 weights
	rename informalescontribuyente informales
	gen  byte BRASIL=1
	local directorio "C:\Users\nparra\Dropbox\Fedesarrollo\BASE LAC"
	compress
	save "`directorio'\basegrande_BRASIL",replace
restore

	gen mujeresET2= (mujer==1 & PET2==1)
	gen mujeresET= (mujer==1 & PET==1)
	gen mujeresEA= (mujer==1 & PEA==1)
svy,subpop(mujeresET):proportion mujeresEA,cformat(%5.2fc)
svy,subpop(mujeresET2):proportion mujeresEA,cformat(%5.2fc)

	gen edad1ET2= (edad1==1 & PET2==1)
	gen edad1ET= (edad1==1 & PET2==1)
	gen edad1EA= (edad1==1 & PEA==1)
svy,subpop(edad1ET):proportion edad1EA,cformat(%5.2fc)
svy,subpop(edad1ET2):proportion edad1EA,cformat(%5.2fc)

	gen edad3ET2= (edad3==1 & PET2==1)
	gen edad3ET= (edad3==1 & PET==1)
	gen edad3EA= (edad3==1 & PEA==1)
svy,subpop(edad3ET):proportion edad3EA,cformat(%5.2fc)
svy,subpop(edad3ET2):proportion edad3EA,cformat(%5.2fc)

*


log close _all
********************************************************************************
********************************************************************************
********************************************************************************
*							REGRESIONES POR CUANTILES
********************************************************************************
********************************************************************************
********************************************************************************
local productividad masproductivas menosproductivas
local Xmlogit2 edad1 edad3 educacion1 educacion3 mconyuge mnoconyuge perdom rural `productividad'

	cap gen pid=_n
	cap drop xmbp
mmsel ingresos `Xmlogit2' if occupied==1,group(informalescontribuyente) filename(MataMachado,replace) pooled
	quantile /*Para graficas de ingresos por cuantiles*/

/*Furthermore, this methodology makes it possible to
account for wage heterogeneity among groups of individuals and for differences in the
impact of the determinants of wages and wage gaps by employment type at different
points in the distribution (Machado and Mata, 2005). Thus, the results are more
complete than those obtained by ordinary least squares (OLS).7
We now present a brief description of the estimation procedure of the Machado-Mata
decomposition method with sample selection adjustment. We use the adapted Machado-
Mata procedure introduced by Albrecht et al. (2009) based on Buchinsky (1998), which is
a non-parametric method to account for selection for quantile regression.*/
