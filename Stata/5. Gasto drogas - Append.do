**************************************************************************************
**************************************************************************************
			* Metodología Estimación Gasto Fiscal en Política de Drogas *
						* Análisis Sistemas de Información *
						  * Append Fuentes de Información *
**************************************************************************************
**************************************************************************************
	clear
	mat drop _all
	local drop _all
	scalar drop _all

* 1. Base Programas

	* 1.1. Importar data
		
		cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .xls"
		set excelxlsxlargefile on
		set maxvar 32767 
		import excel "Data Programas.xls", sheet("D1") cellrange() firstrow

	* 1.2. Guardar en formato .dta (Programas)

		cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"
		save "Programas.dta", replace

	* 1.3. Modificar variable GastoxPrograma en millones de pesos y $ constantes 2016
		* Se utilizaron las cifras del IPC provenientes del DANE (www.dane.gov.co)
	
		gen GastoxPrograma2 = . 
		replace GastoxPrograma2 = GastoxPrograma/1000000
		lab var GastoxPrograma2 "Gasto x Programa mill"
	
		gen GastoxPrograma3 = .
		replace GastoxPrograma3 = GastoxPrograma2 if Año == 2016 
		replace GastoxPrograma3 = GastoxPrograma2*133.39977/126.14945 if Año == 2015
		replace GastoxPrograma3 = GastoxPrograma2*133.39977/118.15166 if Año == 2014
		replace GastoxPrograma3 = GastoxPrograma2*133.39977/113.98254 if Año == 2013
		lab var GastoxPrograma3 "Gasto x Programa $ cons 2016"

		save "Programas.dta", replace
	
* 2. Data SGR 

	* 2.1. Llamar dataset en formato .dta (SGR)

		clear
		cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"
		use "SGR Drogas 2.dta", clear
	
	* 2.2. Modificación y estandarización nombre de las variables 
		
		* Estandarizar variable Sector2
			* Que tenga la misma clasificación de Programas.dta
			
			replace Sector = upper(Sector)
			
			replace Sector = "." if Sector == "AGUA POTABLE Y SANEAMIENTO BáSICO" | /*
								 */	Sector == "EQUIPAMIENTO URBANO" | /*
								 */ Sector == "FORTALECIMIENTO INSTITUCIONAL" | /*
								 */ Sector == "GESTIóN DEL RIESGO"
			replace Sector = "CIENCIA Y TECNOLOGIA" if Sector == "CIENCIA, TECNOLOGíA E INNOVACIóN"
			replace Sector = "CULTURA Y DEPORTE" if Sector == "CULTURA" | Sector == "DEPORTE Y RECREACIóN"
			replace Sector = "EDUCACION" if Sector == "EDUCACIóN"
			replace Sector = "INCLUSION SOCIAL Y RECONCILIACION" if Sector == "INCLUSIóN SOCIAL Y RECONCILIACIóN"
			replace Sector = "INTERIOR Y JUSTICIA" if Sector == "JUSTICIA Y DEL DERECHO"
			replace Sector = "MINAS Y ENERGIA" if Sector == "MINAS Y ENERGíA"
			replace Sector = "SALUD Y PROTECCION SOCIAL" if Sector == " SALUD Y PROTECCIóN SOCIAL"
			replace Sector = "VIVIENDA, CIUDAD Y TERRITORIO" if Sector == "VIVIENDA"
			lab var Sector Sector
		
		* Eliminar variables que no serán utilizadas
		
			keep if Drogas == 1
			drop Nuevo Cod_DANE OCAD Region Sector Region Mes Drogas
			
		* Rename variables de VT a Gasto x Proyecto y Proyecto a Programa
			
			rename VT_1 GastoxPrograma2
			lab var GastoxPrograma2 "Gasto x Programa mill"
			rename VT_2 GastoxPrograma3
			lab var GastoxPrograma3 "Gasto x Programa mill $ cons 2016"
			rename Proyecto Programa
			lab var Programa Programa
			lab var Entidad Entidad
			rename Depto SubEntidad
			lab var SubEntidad "Sub Entidad"
			lab var BPIN BPIN
	
	* 2.3. Crear variable ID de Fuente
		
		gen Fuente = "SGR"
		lab var Fuente Fuente
	
	* 2.4. Guardar en format .dta (SGR)
		* Nueva base con modificaciones
		* Se guarda con otro nombre para no perder la otra información
			
		save "SGR Drogas 3.dta", replace
	
* 3. Data SISFUT

	* 3.1. Llamar dataset en formato .dta (SISFUT)

		clear
		cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"
		use "SISFUT Drogas.dta", clear
	
	* 3.2. Estandarización variables
					
		* Rename Cariables
		
			rename Concepto Programa
			lab var Programa Programa
			rename TotalObligaciones GastoxPrograma
			lab var GastoxPrograma "Gasto x Programa"
			rename TotalObligaciones2 GastoxPrograma2
			lab var GastoxPrograma2 "Gasto x Programa mill"
			rename TotalObligaciones3 GastoxPrograma3
			lab var GastoxPrograma3 "Gasto x Programa mill $ cons 2016"
			rename NombreDANEMunicipio Entidad
			lab var Entidad Entidad
			rename NombreDANEDepartamento SubEntidad
			lab var SubEntidad "Sub Entidad"
			
	* 3.3. Drop & Keep
		
		* Drop información del FONSET 
			* Se utilizó para justificar por qué no contemplar esta info
	
			drop if CódigoConcepto == "A.18.4"
		
		* Keep variables de interés
		
			keep Año Programa GastoxPrograma GastoxPrograma2 GastoxPrograma3 Entidad SubEntidad		
	
	* 3.4. Crear variable ID de Fuente
		
		gen Fuente = "SISFUT"
		lab var Fuente Fuente
		
	* 3.5. Guardar en format .dta (SGR)
		* Nueva base con modificaciones
		* Se guarda con otro nombre para no perder la otra información
			
		save "SISFUT Drogas 2.dta", replace
		
* 4. Data SIIF
	
	* 4.1. Llamar dataset en formato .dta (SIIF)
	
		clear
		cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"	
		use "SIIF.dta", clear
	
	* 4.2. Rename variables de interés
	
		rename SectorPresent Sector
		lab var Sector Sector
		rename UnidadEjecutora SubEntidad
		lab var SubEntidad SubEntidad
		rename UnidadEjecutora2 Entidad
		lab var Entidad Entidad
		rename Nombre Programa
		lab var Programa Programa
		rename Obligacion GastoxPrograma
		lab var GastoxPrograma "Gasto x Programa"
		rename Obligacion2 GastoxPrograma2
		lab var GastoxPrograma2 "Gasto x Programa mill"
		rename Obligacion3 GastoxPrograma3
		lab var GastoxPrograma3 "Gasto x Programa mill $ cons 2016"
		rename ApropiacionVigente Apropiacion
		lab var Apropiacion Apropiacion
		lab var Pago Pago
		rename Gasto TipodeGasto
		lab var TipodeGasto "Tipo de Gasto"
		lab var Año Año
	
	* 4.3. Keep variables de interés
	
		keep Año Sector Entidad SubEntidad Programa GastoxPrograma GastoxPrograma2 GastoxPrograma3 TipodeGasto Drogas1 Drogas2 Drogas3

	* 4.4. Keep Años de interés
	
		keep if Año == 2013 | Año == 2014 | Año == 2015
		
	* 4.5. Crear ID de Fuente
			
		gen Fuente = "SIIF"
		lab var Fuente Fuente
	
	* 4.6. Identificar rubros 100% relación drogas
		* Hay que eliminar los rubros de funcionamiento de la DNE
		* En la respuesta del oficio de la SAE, están los gasto x funcionamiento de la DNE
		
		gen ID_Drogas = .
		replace ID_Drogas = 1 if Drogas1 == 1 | Drogas3 == 1
		replace ID_Drogas = 1 if strpos(Entidad, "ESTUPEFACIENTE")
		replace ID_Drogas = 1 if strpos(SubEntidad, "ESTUPEFACIENTE")
		replace ID_Drogas = 1 if strpos(Entidad, "UACT")
		
		drop if Entidad == "DIRECCION NACIONAL DE ESTUPEFACIENTES" & TipodeGasto == "Funcionamiento"
		
	* 4.7. Keep observaciones de drogas
	
		keep if ID_Drogas == 1 
		drop Drogas1 Drogas2 Drogas3 ID_Drogas
		
	* 4.8. Guardar en format .dta (SGR)
		* Nueva base con modificaciones
		* Se guarda con otro nombre para no perder la otra información
			
		save "SIIF Drogas.dta", replace
		
* 5. Append 

	* 5.1. Llamar data en formato .dta (Programas)
	
		clear 
		cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"
		use "Programas.dta", clear

	* 5.2. Append datasets
	
		append using "SGR Drogas 3.dta"
		append using "SISFUT Drogas 2.dta"
		append using "SIIF Drogas.dta"
	
	* 5.3. Guardar en formato .dta
		
		save "Programas Final.dta", replace
	
	* 5.4. Modificaciones
	
		replace Entidad = "MINISTERIO DE SALUD Y PROTECCION SOC" if Entidad == "MINISTERIO  DE SALUD Y PROTECCION SOCIAL"
		replace Entidad = "POLICIA NACIONAL" if Entidad == "POLICIA NACIONAL " | /*
											 */ Entidad == "POLICÍA NACIONAL"
	
	* 5.5. Codificación de variables
		* La codificación facilita la programación

		local lista "Estrategia Politica Programa Nivel Sector Entidad TipodeEntidad SubEntidad"
		local numitems = wordcount("`lista'")
			
		foreach i of var `lista' {		
			encode `i', gen(`i'1)
			drop `i'
			rename `i'1 `i'			   
		}	
	
	* 5.6. Keep años de interés
	
		keep if Año > 2012
		save "Programas Final.dta", replace
	
	* 5.7. Crear variable Entidad General y hacer modificaciones necesarias
	
		decode Entidad, gen(Entidad2)
		gen EntidadGeneral = Entidad2
		lab var EntidadGeneral "Entidad General"
		
		replace EntidadGeneral = "TERRITORIOS" if Fuente == "Plan Nacional Departamental" | /*
											   */ Fuente == "Plan Nacional Municipal" | /*
											   */ Fuente == "SGR" | /*
											   */ Fuente == "SISFUT"		
	
		replace EntidadGeneral = "TERRITORIOS" if Entidad2 == "ENTES TERRITORIALES" | /*
											   */ Entidad2 == "AMVA" | /*
											   */ Entidad2 == "BOGOTA" | /*
											   */ Entidad2 == "CALI" | /*
											   */ Entidad2 == "CUCUTA" | /*
											   */ Entidad2 == "DOSQUEBRADAS" | /*
											   */ Entidad2 == "PEREIRA"
		
		save "Programas Final.dta", replace
	
	* 5.8. Crear variable ID programas de interés
		* La base Programas.dta contiene información de programas que están contenidos en otros 
		* O son programas generales que están desagregados en otros programas
		* Se señalan los programas / rubros que son parte del gasto en política de drogas 
		* Identificación manual
		
		* 0 - rubros presupuestales que cuentan con presupuesto y serán contemplados en las cifras
			* aquí se incluyen programas / actividades que si bien no tienen presupuesto, si se llevaron a cabo
		* 1 - rubros presupuestales que si bien se habían identificado, no reportan información para los años de interés
		* 2 - rubros presupuestales de los cuales todavía no se tiene información
		
	gen ID = . 	
	replace ID = 1 if GastoxPrograma3 == .
		
* 6. Exportar data en format .xls
	* Se exporta la data para completar, manualmente, las variables como "Estrategia"
	
	cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Salidas .xls"
	export excel using "5. Gasto drogas - Data Final.xls", sheet("D1") sheetreplace firstrow(variables)

