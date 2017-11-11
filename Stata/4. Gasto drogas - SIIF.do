**************************************************************************************
**************************************************************************************
			* Metodología Estimación Gasto Fiscal en Política de Drogas *
						* Análisis Sistemas de Información  *
				* Sistema Integrado de Información Financiera - SIIF *
**************************************************************************************
**************************************************************************************
* Ejecutar desde el punto # 8
* Lo anterior corresponde a data preparation & cleaning  

	clear
	mat drop _all
	local drop _all
	scalar drop _all

* 1. Importar data
	
	cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .xls"
	set excelxlsxlargefile on
	set maxvar 32767 

* 2. Guardar en formato .dta (SIIF)

	* Guardar en formato .dta data funcionamiento e inversión x año
	
		forvalues i = 2/16 {
			cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .xls"
			import excel "Data SIIF.xlsx", sheet("Base `i'") firstrow
			cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"
			save "SIIF `i'.dta", replace
			gen año = `i'
			save "SIIF `i'.dta", replace	
			clear
	}
	
	* Append SIIF .dta data por año
	
		foreach x of local data {
			use "SIIF 16.dta", clear
			save SIIF.dta, replace
			
			forvalues i = 2/15 {
				use SIIF.dta, replace
				append using "SIIF `i'.dta", force
				save SIIF.dta, replace
			}
			forvalues i = 2/15 {
				erase "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta\SIIF `i'.dta"
			}
		}
		
	* Guardar en formato .dta (SIIF)
	
		cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"
		save "SIIF.dta", replace
	
* 3. Llamar dataset en formato .dta (SIIF)

	clear
	cd "CC:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"
	use "SIIF.dta", clear
			
* 4. Modificación de variables
	
	* Lower caso Nombre (rubros presupuestales)
	
		replace Nombre = lower(Nombre)	

	* Variable Año
		* Pasar, por ejemplo, de 2 a 2002

		forvalues i = 2/9 {
			replace Año = 200`i' if Año == `i'
		}
		
		forvalues i = 10/16 {
			replace Año = 20`i' if Año == `i'
		}
	
	* Tipo de gasto
		
		replace Gasto = "Funcionamiento" if Gasto == "A"
		replace Gasto = "Deuda" if Gasto == "B"
		replace Gasto = "Inversion" if Gasto == "C"
	
	* Variable Obligación
		* Obligación anual en millones de pesos y $ constantes de 2016
		* Se utilizaron las cifras del IPC provenientes del DANE (www.dane.gov.co)

		gen Obligacion2 = Obligacion/1000000
		lab var Obligacion2 "Obligacion mill"
		
		gen Obligacion3 = .
		replace Obligacion3 = Obligacion2 if Año == 2016 
		replace Obligacion3 = Obligacion2*133.39977/126.14945 if Año == 2015
		replace Obligacion3 = Obligacion2*133.39977/118.15166 if Año == 2014
		replace Obligacion3 = Obligacion2*133.39977/113.98254 if Año == 2013
		replace Obligacion3 = Obligacion2*133.39977/111.81576 if Año == 2012
		replace Obligacion3 = Obligacion2*133.39977/109.15740 if Año == 2011
		replace Obligacion3 = Obligacion2*133.39977/105.23651 if Año == 2010
		replace Obligacion3 = Obligacion2*133.39977/102.00181 if Año == 2009
		replace Obligacion3 = Obligacion2*133.39977/100 if Año == 2008
		replace Obligacion3 = Obligacion2*133.39977/92.87228 if Año == 2007
		replace Obligacion3 = Obligacion2*133.39977/87.86896 if Año == 2006
		replace Obligacion3 = Obligacion2*133.39977/84.10291 if Año == 2005
		replace Obligacion3 = Obligacion2*133.39977/80.20885 if Año == 2004
		replace Obligacion3 = Obligacion2*133.39977/76.02913 if Año == 2003
		replace Obligacion3 = Obligacion2*133.39977/71.39513 if Año == 2002
		lab var Obligacion3 "Obligacion mill $ cons 2016"
	
	* Variable Sector
		* Reducir el número de categorías en la variable Sector
	
		replace Sector = "AMBIENTE Y DESARROLLO RURAL" 			if 	Sector == "AMBIENTE, VIVIENDA Y DESARROLLO T." | /*
																*/	Sector == "AMBIENTE, VIVIENDA Y DESARROLLO TERR." | /*
																*/	Sector == "AMBIENTE, VIVIENDA Y DESARROLLO TERRITORIAL"
		replace Sector = "CULTURA Y DEPORTE" 					if 	Sector == "CULTURA" | /*
																*/	Sector == "CULTURA, DEPORTE Y RECREACION" | /*
																*/	Sector == "DEPORTE Y RECREACION" | /*
																*/	Sector == "DEPORTE Y RECREACIÓN"
		replace Sector = "DEFENSA Y POLICIA" 					if 	Sector == "DEFENSA Y POLICÍA" | /*
																*/	Sector == "DEFENSA Y SEGURIDAD"
		replace Sector = "DEUDA PUBLICA" 						if 	Sector == "DEUDA PÚBLICA"
		replace Sector = "EDUCACION" 							if 	Sector == "EDUCACIÓN"
		replace Sector = "EMPLEO PUBLICO" 						if 	Sector == "EMPLEO PÚBLICO"
		replace Sector = "ESTADISTICA" 							if 	Sector == "ESTADÍSTICA" | /*
																*/	Sector == "ESTADÍSTICAS" | /*
																*/ 	Sector == "INFORMACION ESTADISTICA" | /*
																*/	Sector == "INFORMACION ESTADÍSTICA"
		replace Sector = "FISCALIA" 							if 	Sector == "FISCALÍA"
		replace Sector = "INCLUSION SOCIAL Y RECONCILIACION" 	if 	Sector == "INCLUSIÓN SOCIAL Y RECONCILIACIÓN"
		replace Sector = "INTELIGENCIA" 						if 	Sector == "INTELIGENCIA Y SEGURIDAD"
		replace Sector = "INTERIOR Y JUSTICIA" 					if 	Sector == "INTERIOR" | /*
																*/	Sector == "JUSTICIA Y DEL DERECHO" | /*
																*/	Sector == "MINISTERIOR Y DE JUSTICIA"
		replace Sector = "MINAS Y ENERGIA" 						if 	Sector == "MINAS Y ENERGÍA"
		replace Sector = "ORGANISMOS DE CONTROL" 				if 	Sector == "ORGANOS DE CONTROL"
		replace Sector = "PLANEACION" 							if 	Sector == "PLANEACIÓN"
		replace Sector = "PRESIDENCIA" 							if 	Sector == "PRESIDENCIA DE LA REPUBLICA" | /*
																*/	Sector == "PRESIDENCIA DE LA REPÚBLICA" | /*
																*/	Sector == "ACCIÓN Y APOYO SOCIAL" | /*
																*/	Sector == "ACCION SOCIAL"
		replace Sector = "SALUD Y PROTECCION SOCIAL" 			if 	Sector == "PROTECCIÓN SOCIAL" | /*
																*/	Sector == "PROTECCION SOCIAL" | /*
																*/ 	Sector == "SALUD PROTECCION SOCIAL"
		replace Sector = "REGISTRADURIA" 						if 	Sector == "REGISTRADURÍA" | /*
																*/	Sector == "REGISTRADURÍA NACIONAL DEL ESTADO CIVIL"
		replace Sector = "SERVICIO DE LA DEUDA" 				if 	Sector == "SERVICIO A LA DEUDA" | /*
																*/	Sector == "SERVICIO DE LA DEUDA PÚBLICA NACIONAL"
		replace Sector = "CONGRESO" 							if 	Sector == "CONGRESO DE LA REPUBLICA"
		replace Sector = "CIENCIA Y TECNOLOGIA" 				if 	Sector == "CIENCIA Y TECNOLOGÍA"
		replace Sector = "DANSOCIAL" 							if 	Sector == "DEPARTAMENTO DE LA ECONOMÍA SOLIDARIA"	
	
	* Variable Unidad Ejecutora
		* Reducir el número de categorías en la variable Entidad
		
		gen UnidadEjecutora2 = UnidadEjecutora
		
		replace UnidadEjecutora2 = "AGENCIA COLOMBIANA DE COOPERACION INTERNACIONAL"	if 	UnidadEjecutora == "AGENCIA COL.DE COOP. INTERNACIONAL" |/*
																						*/	UnidadEjecutora == "AGENCIA PRESIDENCIAL PARA LA ACCION SOCIAL Y LA COOPERACION INTERNACIONAL - ACCION SOCIAL -" |/*
																						*/	UnidadEjecutora == "AGENCIA PRESIDENCIAL PARA LA ACCION SOCIAL Y LA COOPERACION INTERNACIONAL- ACCION SOCIAL" |/*
																						*/	UnidadEjecutora == "COOPERACION INTERNACIONAL" 	|/*
																						*/	UnidadEjecutora == "COOPINTERNACIONAL"	|/*
																						*/	UnidadEjecutora == "AGENCIA PRESIDENCIAL DE COOPERACIÓN INTERNACIONAL DE COLOMBIA, APC - COLOMBIA"
		
		replace UnidadEjecutora2 = "MINISTERIO DE AGRICULTURA" 							if 	UnidadEjecutora == "MINAGRICULTURA - BANCO AGRARIO DE COLOMBIA S.A." |/*
																						*/	UnidadEjecutora == "MINAGRICULTURA - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINAGRICULT.- BANCO AGRARIO" |/*
																						*/	UnidadEjecutora == "MINAGRICULTURA - BANCO AGRARIO DE COLOMBIA S.A." |/*
																						*/	UnidadEjecutora == "MINAGRICULTURA - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINAGRICULTURA - GESTION GRAL."
								
		replace UnidadEjecutora2 = "MINISTERIO DE AMBIENTE Y DESARROLLO SOSTENIBLE"		if	UnidadEjecutora == "MINDESARROLLO - GESTION GRAL." |/*
																						*/	UnidadEjecutora == "MINDESARROLLO - INDUSTRIA/CIO." |/*
																						*/	UnidadEjecutora == "MINISTERIO DE AMBIENTE Y DESARROLLO SOSTENIBLE - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINISTERIO DE AMBIENTE, VIVIENDA Y DESARROLLO TERRITORIAL  - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINAMBIENTE-GESTION GENERAL" 
								
		replace UnidadEjecutora2 = "MINISTERIO DE AMBIENTE, VIVIENDA Y DESARROLLO" 		if	UnidadEjecutora == "MINAMBIENTE VIVIENDA DESARROLLO T. - GESTION " |/*
																						*/	UnidadEjecutora == "MINAMBIENTE VIVIENDA DESARROLLO T. - UNIDAD ADMINISTRATIVA ESPECIAL COMISION DE REGULACION DE AGUA POTABLE Y SANEAMIENTO BASICO -CRAG-" |/*
																						*/	UnidadEjecutora == "MINAMBIENTE VIVIENDA DESARROLLO T. - UNIDAD ADMINISTRATIVA ESPECIAL DEL SISTEMA DE PARQUES NACIONALES NATURALES" |/*
																						*/	UnidadEjecutora == "MINAMBIENTE VIVIENDA-GESTION GENERAL" 
					
		replace UnidadEjecutora2 = "MINISTERIO DE COMERCIO, INDUSTRIA Y TURISMO" 		if	UnidadEjecutora == "MINCOMERCIO GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINCOMERCIO -GESTION GRAL." |/* 
																						*/	UnidadEjecutora == "MINCOMERCIO IND.Y TURISM-GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINCOMERCIO INDUSTRIA TURISMO - ARTESANIAS DE COLOMBIA S.A." |/*
																						*/	UnidadEjecutora == "MINCOMERCIO INDUSTRIA TURISMO - DIRECCION GENERAL" |/*
																						*/	UnidadEjecutora == "MINCOMERCIO INDUSTRIA TURISMO - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINCOMERCIO INDUSTRIA TURISMO - SUPERINTENDENCIA DE INDUSTRIA Y COMERCIO"
																							
		replace UnidadEjecutora2 = "COLDEPORTES"										if	UnidadEjecutora == "DEPARTAMENTO ADMINISTRATIVO DEL DEPORTE, LA RECREACIÓN, LA ACTIVIDAD FÍSICA Y EL APROVECHAMIENTO DEL TIEMPO LIBRE – COLDEPORTES - GESTIÓN GENERAL" |/*
																						*/	UnidadEjecutora == "DEPARTAMENTO ADMINISTRATIVO DEL DEPORTE, LA RECREACIÓN, LA ACTIVIDAD FÍSICA Y EL APROVECHAMIENTO DEL TIEMPO LIBRE – COLDEPORTES – GESTIÓN GENERAL" |/*
																						*/	UnidadEjecutora == "INSTITUTO COLOMBIANO DEL DEPORTE - COLDEPORTES"
								
		replace UnidadEjecutora2 = "MINISTERIO DE DEFENSA NACIONAL"						if 	UnidadEjecutora == "MINDEFENSA - ARMADA" |/*
																						*/	UnidadEjecutora == "MINDEFENSA - COMANDO GENERAL" |/*
																						*/	UnidadEjecutora == "MINDEFENSA - EJERCITO" |/*
																						*/	UnidadEjecutora == "MINDEFENSA - FUERZA AEREA" |/*
																						*/	UnidadEjecutora == "MINDEFENSA - GESTION GRAL." |/*
																						*/	UnidadEjecutora == "MINDEFENSA - SALUD" |/*
																						*/	UnidadEjecutora == "MINISTERIO DE DEFENSA NACIONAL - ARMADA" |/*
																						*/	UnidadEjecutora == "MINISTERIO DE DEFENSA NACIONAL - COMANDO GENERAL" |/*
																						*/	UnidadEjecutora == "MINISTERIO DE DEFENSA NACIONAL - COMISIONADO NACIONAL PARA LA POLICIA" |/*
																						*/	UnidadEjecutora == "COMISIONADO NAL. POLICIA" |/*
																						*/	UnidadEjecutora == "MINISTERIO DE DEFENSA NACIONAL - DIRECCION GENERAL MARITIMA - DIMAR" |/*
																						*/	UnidadEjecutora == "MINISTERIO DE DEFENSA NACIONAL - EJERCITO" |/*
																						*/	UnidadEjecutora == "MINISTERIO DE DEFENSA NACIONAL - FUERZA AEREA" |/*
																						*/	UnidadEjecutora == "MINISTERIO DE DEFENSA NACIONAL - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINISTERIO DE DEFENSA NACIONAL - SALUD" |/*
																						*/	UnidadEjecutora == "MINISTERIO DE DEFENSA NACIONAL - SUPERINTENDENCIA DE VIGILANCIA Y SEGURIDAD PRIVADA" |/*
																						*/	UnidadEjecutora == "MINISTERIO DE DEFENSA NACIONAL DIRECCION CENTRO DE REHABILITACION INCLUSIVA - DCRI"
											
		replace UnidadEjecutora2 = "POLICÍA NACIONAL"									if 	UnidadEjecutora == "POLICIA NACIONAL - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "POLICIA NACIONAL - SALUD" |/*
																						*/	UnidadEjecutora == "POLICIA NACIONAL (SALUD)" |/*
																						*/	UnidadEjecutora == "POLINAL - GESTION GENERAL"
											
		replace UnidadEjecutora2 = "MINISTERIO DE EDUCACIÓN NACIONAL"					if	UnidadEjecutora == "MINEDUCACION - GESTION GRAL." |/*
																						*/	UnidadEjecutora == "MINISTERIO EDUCACION NACIONAL - ESCUELA NACIONAL DEL DEPORTE" |/*
																						*/	UnidadEjecutora == "MINISTERIO EDUCACION NACIONAL - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINISTERIO EDUCACION NACIONAL - JUNTA CENTRAL DE CONTADORES"
											
		replace UnidadEjecutora2 = "FISCALÍA GENERAL DE LA NACIÓN"						if	UnidadEjecutora == "FISCALIA GENERAL DE LA NACION - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "FISCALIA - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "FISCALIA GENERAL DE LA NACION - GESTION GENERAL"
											
		replace UnidadEjecutora2 = "MEDICINA LEGAL"										if	UnidadEjecutora == "INSTITUTO NACIONAL DE MEDICINA LEGAL Y CIENCIAS FORENSES"								
											
		replace UnidadEjecutora2 = "MINISTERIO DE HACIENDA Y CRÉDITO PÚBLICO"			if	UnidadEjecutora == "MINHACIENDA Y CREDITO PUBLICO - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINHACIENDA Y CREDITO PUBLICO - SUPERINTENDENCIA DE VALORES" |/*
																						*/	UnidadEjecutora == "MINHACIENDA-GSTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINHACIENDA-SUPERVALORES" |/*
																						*/	UnidadEjecutora == "MINISTERIO DE HACIENDA Y CREDITO PUBLICO - GESTION GENERAL"
		
		replace UnidadEjecutora2 = "DIAN"												if	UnidadEjecutora == "UAE - DIAN" |/*
																						*/	UnidadEjecutora == "UNIDAD ADMINISTRATIVA ESPECIAL DIRECCION DE IMPUESTOS Y ADUANAS NACIONALES"
		
		replace UnidadEjecutora2 = "ICBF"												if	UnidadEjecutora == "INSTITUTO COLOMBIANO DE BIENESTAR FAMILIAR (ICBF)"
				
		replace UnidadEjecutora2 = "UACT"												if	UnidadEjecutora == "UNIDAD ADMINISTRATIVA ESPECIAL PARA LA CONSOLIDACIÓN TERRITORIAL"
		
		replace UnidadEjecutora2 = "DIRECCION NACIONAL DE ESTUPEFACIENTES"				if	UnidadEjecutora == "DIRECCIÓN NACIONAL DE ESTUPEFACIENTES EN LIQUIDACIÓN" |/*
																						*/	UnidadEjecutora == "ESTUPEFACIENTES"
												
		replace UnidadEjecutora2 = "INPEC"												if	UnidadEjecutora == "INSTITUTO NACIONAL PENITENCIARIO Y CARCELARIO - INPEC"									
		
		replace UnidadEjecutora2 = "MINISTERIO DEL INTERIOR"							if	UnidadEjecutora == "MININTERIOR - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MININTERIOR GESTION GENERAL"  |/*
																						*/	UnidadEjecutora == "MININTERIOR Y JUSTICIA - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MININTERIOR Y JUSTICIA-GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINISTERIO DEL INTERIOR - GESTIÓN GENERAL"
									
		replace UnidadEjecutora2 = "MINISTERIO DE JUSTICIA Y DEL DERECHO" 				if	UnidadEjecutora == "MINISTERIO DE JUSTICIA Y DEL DERECHO - GESTIÓN GENERAL" |/*
																						*/	UnidadEjecutora == "MINJUSTICIA - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINJUSTICIA - UAE - FIC)"
																							
		replace UnidadEjecutora2 = "FONDO ESTUPEFACIENTES"								if	UnidadEjecutora == "UAE-FONDO ESTUPEFACIENTES" |/*
																						*/	UnidadEjecutora == "UAE FONDO ESTUPEFACIENTES" |/*
																						*/	UnidadEjecutora == "UNIDAD ADMINISTRATIVA ESPECIAL - FONDO NACIONAL DE ESTUPEFACIENTES"
		
		replace UnidadEjecutora2 = "USPEC"												if	UnidadEjecutora == "UNIDAD DE SERVICIOS PENITENCIARIOS Y CARCELARIOS - SPC" |/*
																						*/	UnidadEjecutora == "UNIDAD DE SERVICIOS PENITENCIARIOS Y CARCELARIOS - USPEC"
		
		replace UnidadEjecutora2 = "PROCUDARIA"											if 	UnidadEjecutora == "PROCURADURIA - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "PROCURADURIA - INSTITUTO DE ESTUDIOS DEL MINISTERIO PUBLICO" |/*
																						*/	UnidadEjecutora == "PROCURADURIA GENERAL DE LA NACIÓN - GESTION GENERAL"
		
		replace UnidadEjecutora2 = "DNP"												if	UnidadEjecutora == "DEPARTAMENTO DE PLANEACION - COMISION NACIONAL DE REGALIAS - EN LIQUIDACION" |/*
																						*/	UnidadEjecutora == "DEPARTAMENTO DE PLANEACION - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "DNP - FONADE" |/*
																						*/	UnidadEjecutora == "DNP - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "DNP -COMIS. NAL. DE REGALIAS."
						
		replace UnidadEjecutora2 = "PRESIDENCIA DE LA REPÚBLICA"						if	UnidadEjecutora == "PRESIDENCIA DE LA REPUBLICA - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "PRESIDENCIA-GESTION GENERAL"
		
		replace UnidadEjecutora2 = "RED DE SOLIDARIDAD SOCIAL" 							if	UnidadEjecutora == "RED SOLIDARIDAD SOCIAL"
		
		replace UnidadEjecutora2 = "MINISTERIO DE RELACIONES EXTERIORES"				if	UnidadEjecutora == "MINIRELACIONES EXTERIORES - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINRELACIONES-GESTION GRAL"
												
		replace UnidadEjecutora2 = "MINISTERIO  DE SALUD Y PROTECCION SOCIAL"			if	UnidadEjecutora == "MINISTERIO  DE SALUD Y PROTECCION SOCIAL - CENTRO DERMATOLOGICO FEDERICO LLERAS ACOSTA" |/*
																						*/	UnidadEjecutora == "MINISTERIO  DE SALUD Y PROTECCION SOCIAL - EMPRESA TERRITORIAL PARA LA SALUD, ETESA EN LIQUIDACIÓN" |/*
																						*/	UnidadEjecutora == "MINISTERIO  DE SALUD Y PROTECCION SOCIAL - INSTITUTO NACIONAL DE CANCEROLOGIA " |/*
																						*/	UnidadEjecutora == "MINISTERIO  DE SALUD Y PROTECCION SOCIAL - SANATORIO DE AGUA DE DIOS" |/*
																						*/	UnidadEjecutora == "MINISTERIO  DE SALUD Y PROTECCION SOCIAL - SANATORIO DE CONTRATACION" |/*
																						*/	UnidadEjecutora == "MINISTERIO  DE SALUD Y PROTECCION SOCIAL - UNIDAD ADMINISTRATIVA ESPECIAL FONDO NACIONAL DE ESTUPEFACIENTES" |/*
																						*/	UnidadEjecutora == "MINISTERIO DE LA PROTECCION SOCIAL - ADMINISTRADORA COLOMBIANA DE PENSIONES – COLPENSIONES" |/*
																						*/	UnidadEjecutora == "MINISTERIO DE LA PROTECCION SOCIAL - INSTITUTO DE SEGUROS SOCIALES" |/*
																						*/	UnidadEjecutora == "MINISTERIO DE SALUD Y PROTECCION SOCIAL" |/*
																						*/	UnidadEjecutora == "MINISTERIO DE SALUD Y PROTECCION SOCIAL - GESTIÓN GENERAL" |/*
																						*/	UnidadEjecutora == "MINISTERIO PROTECCION SOCIAL - ADMINISTRADORA COLOMBIANA DE PENSIONES û COLPENSIONES" |/*
																						*/	UnidadEjecutora == "MINISTERIO PROTECCION SOCIAL - CAJA DE PREVISION SOCIAL DE COMUNICACIONES (CAPRECOM)" |/*
																						*/	UnidadEjecutora == "MINISTERIO PROTECCION SOCIAL - CENTRO DERMATOLOGICO FEDERICO LLERAS ACOSTA" |/*
																						*/	UnidadEjecutora == "MINISTERIO PROTECCION SOCIAL - EMPRESA TERRITORIAL PARA LA SALUD - ETESA" |/*
																						*/	UnidadEjecutora == "MINISTERIO PROTECCION SOCIAL - EMPRESA TERRITORIAL PARA LA SALUD, ETESA EN LIQUIDACIÓN" |/*
																						*/	UnidadEjecutora == "MINISTERIO PROTECCION SOCIAL - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINISTERIO PROTECCION SOCIAL - INSTITUTO DE SEGUROS SOCIALES" |/*
																						*/	UnidadEjecutora == "MINISTERIO PROTECCION SOCIAL - INSTITUTO NACIONAL DE CANCEROLOGIA" |/*
																						*/	UnidadEjecutora == "MINISTERIO PROTECCION SOCIAL - SANATORIO DE AGUA DE DIOS" |/*
																						*/	UnidadEjecutora == "MINISTERIO PROTECCION SOCIAL - SANATORIO DE CONTRATACIONMINISTERIO PROTECCION SOCIAL - SANATORIO DE AGUA DE DIOS" |/*
																						*/	UnidadEjecutora == "MINISTERIO PROTECCION SOCIAL - SUPERINTENDENCIA DE SUBSIDIO FAMILIAR" |/*
																						*/	UnidadEjecutora == "MINISTERIO PROTECCION SOCIAL - UNIDAD ADMINISTRATIVA ESPECIAL FONDO NACIONAL DE ESTUPEFACIENTES" |/*
																						*/	UnidadEjecutora == "MINPROTECCION SOCIAL-GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINSALUD - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINSALUD - INST. CANCEROLOGIA"
		
		replace UnidadEjecutora2 = "MINISTERIO DEL TRABAJO"								if	UnidadEjecutora == "MINISTERIO DE TRABAJO - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINISTERIO DEL TRABAJO - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINISTERIO DEL TRABAJO - INSTITUTO DE SEGUROS SOCIALES" |/*
																						*/	UnidadEjecutora == "MINTRABAJO - CAPRECOM" |/*
																						*/	UnidadEjecutora == "MINTRABAJO - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINTRABAJO - SUPERSUBSIDIO" |/*
																						*/	UnidadEjecutora == "MINISTERIO DEL TRABAJO - CAJA DE PREVISION SOCIAL DE COMUNICACIONES (CAPRECOM)" |/*
																						*/	UnidadEjecutora == "MINISTERIO DEL TRABAJO - GESTION GENERAL" |/*
																						*/	UnidadEjecutora == "MINISTERIO DEL TRABAJO - SUPERINTENDENCIA DE SUBSIDIO FAMILIAR"
		
		replace UnidadEjecutora2 = "SENA" 												if	UnidadEjecutora == "SERVICIO NACIONAL DE APRENDIZAJE (SENA)"
									
* 5. Guardar en formato .dta (SIIF)

	save "SIIF.dta", replace
		
* 6. Seleccionar los proyectos asociados a política de drogas
	
	* Gasto por Inversión: proyectos asociados a política de drogas
	
		gen Drogas1 = 0 
		lab var Drogas11 "INV - Proyectos / rubros drogas" 
		
		local list1  "droga narcotico narcótico ilícito ilicito estupefaciente spa sustancia psicoactiva lavado activos drogadicción drogadiccion" 
		local list2	 "helicóptero helicoptero arma armamento aspersión aspersion ccai coca cocaina marihuana bracna diran tumaco plante sae uiaf uact"
		local list3	 "consumo consumir antinarcótico antinarcotico guardabosque guardabosques cóndor condor erradicacion erradicación"
		local list4	 "consolidacion consolidación laboratorio critalizadero antidroga narco unodc simci"
		local list5	 "erradicar GME PCI incautar incautado incautación pnr frisco antipersona PMA aspersión glifosato abuso dare avión avion"
		local list6	 `" "grupos móviles" "grupos moviles" "sustancias psicoactivas" "escuelas saludables" "pactos por la vida" "colombia jóven" "k-53" "'
		local list7	 `" "colombia joven" "red de jóvenes" "ley 30" "desarrollo alternativo" "fondo paz" "s.a.e." "renovación territorial" "renovacion territorial" "'
		local list8	 `" "policía judicial" "policia judicial" "mina antipersona" "minas antipersona" "'
			
		forvalues j = 1/8 {	
			foreach i in `list`j'' {
				replace Drogas1 = 1 if strpos(Nombre, "`i'") & Gasto == "Inversion"
			}
		}
	
	* Gasto por Funcionamiento: rubros presupuestales entidades de interés 

		gen Drogas2 = 0 
		lab var Drogas2 "FUN - Entidades & rubros drogas"
		replace Drogas2 = 2 if 	Gasto == "Funcionamiento" 	& ( UnidadEjecutora2 == "AGENCIA COLOMBIANA DE COOPERACION INTERNACIONAL" | /*
															*/	UnidadEjecutora2 == "MINISTERIO DE AGRICULTURA" | /*
															*/	UnidadEjecutora2 == "MINISTERIO DE AMBIENTE Y DESARROLLO SOSTENIBLE" | /*
															*/	UnidadEjecutora2 == "MINISTERIO DE AMBIENTE, VIVIENDA Y DESARROLLO" | /*		
															*/	UnidadEjecutora2 == "MINISTERIO DE COMERCIO, INDUSTRIA Y TURISMO" | /*
															*/	UnidadEjecutora2 == "COLDEPORTES" | /*											
															*/	UnidadEjecutora2 == "PARQUES NACIONALES NATURALES DE COLOMBIA" | /*
															*/	UnidadEjecutora2 ==	"MINISTERIO DE DEFENSA NACIONAL" | /*
															*/	UnidadEjecutora2 == "POLICÍA NACIONAL" | /*									
															*/	UnidadEjecutora2 ==	"MINISTERIO DE EDUCACIÓN NACIONAL" | /*				
															*/	UnidadEjecutora2 ==	"FISCALÍA GENERAL DE LA NACIÓN" | /*
															*/	UnidadEjecutora2 ==	"MEDICINA LEGAL" | /*
															*/	UnidadEjecutora2 ==	"MINISTERIO DE HACIENDA Y CRÉDITO PÚBLICO" | /*
															*/	UnidadEjecutora2 ==	"DIAN" | /*
															*/	UnidadEjecutora2 ==	"ICBF" | /*
															*/	UnidadEjecutora2 ==	"UACT" | /*
															*/	UnidadEjecutora2 ==	"DIRECCION NACIONAL DE ESTUPEFACIENTES" | /*
															*/	UnidadEjecutora2 ==	"INPEC" | /*
															*/	UnidadEjecutora2 ==	"MINISTERIO DEL INTERIOR" | /*
															*/	UnidadEjecutora2 ==	"MINISTERIO DE JUSTICIA Y DEL DERECHO" | /*
															*/	UnidadEjecutora2 ==	"FONDO ESTUPEFACIENTES" | /*
															*/	UnidadEjecutora2 ==	"USPEC"	| /* 
															*/	UnidadEjecutora2 ==	"PROCUDARIA" | /*
															*/	UnidadEjecutora2 ==	"DNP" | /* 
															*/	UnidadEjecutora2 ==	"AGENCIA COLOMBIANA PARA LA REINTEGRACIÓN DE PERSONAS Y GRUPOS ALZADOS EN ARMAS" | /*
															*/	UnidadEjecutora2 ==	"PRESIDENCIA DE LA REPÚBLICA" | /*
															*/	UnidadEjecutora2 ==	"RED DE SOLIDARIDAD SOCIAL" | /*  
															*/	UnidadEjecutora2 ==	"MINISTERIO DE RELACIONES EXTERIORES" | /*
															*/	UnidadEjecutora2 ==	"MINISTERIO  DE SALUD Y PROTECCION SOCIAL" | /* 
															*/	UnidadEjecutora2 ==	"MINISTERIO DEL TRABAJO" | /*
															*/	UnidadEjecutora2 ==	"SENA" )
		gen Drogas3 = 0 
		lab var Drogas3 "FUN - Proyectos / rubros drogas" 
		
		local list1  "droga narcotico narcótico ilícito ilicito estupefaciente spa sustancia psicoactiva lavado activos drogadicción drogadiccion" 
		local list2	 "helicóptero helicoptero arma armamento aspersión aspersion ccai coca cocaina marihuana bracna diran tumaco plante sae uiaf uact"
		local list3	 "consumo consumir antinarcótico antinarcotico guardabosque guardabosques cóndor condor erradicacion erradicación"
		local list4	 "consolidacion consolidación laboratorio critalizadero antidroga narco unodc simci"
		local list5	 "erradicar GME PCI incautar incautado incautación pnr frisco antipersona PMA aspersión glifosato abuso dare avión avion"
		local list6	 `" "grupos móviles" "grupos moviles" "sustancias psicoactivas" "escuelas saludables" "pactos por la vida" "colombia jóven" "k-53" "'
		local list7	 `" "colombia joven" "red de jóvenes" "ley 30" "desarrollo alternativo" "fondo paz" "s.a.e." "renovación territorial" "renovacion territorial" "'
		local list8	 `" "policía judicial" "policia judicial" "mina antipersona" "minas antipersona" "'
		
		forvalues j = 1/8 {	
			foreach i in `list`j'' {
				replace Drogas3 = 1 if strpos(Nombre, "`i'") & Drogas2 == 1
			}
		}
		
		egen UnidadEjecutoraCOD = group(UnidadEjecutora)
		egen Unidadejecutora2COD = group(UnidadEjecutora2)
		egen UnidadEjecutora3 = concat(Unidadejecutora2COD UnidadEjecutoraCOD), decode p("-")
		
* 7. Double-check de los gasto por inversión filtrados y contar rubros
	* Mirar proyecto por proyecto manualmente
	* Proyecto no relacionado con drogas se cambia a 0 en la var Drogas
	* Hay 3 grupos de variables que clasifican los rubros presupuestales relacionados con drogas
		* 1. Drogas 1: proyectos de inversión de drogas
		* 2. Drogas 2: entidades del mapa institucional de drogas con sus rubros de gasto funcionamiento
		* 3. Drogas 3: rubros de las entidades del grupo Drogas 2 con rubros relacionados con drogas

	save "SIIF.dta", replace

	* 1. Drogas 1: pasa de 2.571 a 150 observaciones relacionados a política de drogas
	* 2. Drogas 3: pasa de 313 a 125 observaciones relacionados a política de drogas
	
	tab Drogas1 Año if Gasto == "Inversion"
	tab Drogas2 Año if Gasto == "Funcionamiento"
	tab Drogas3 Año
	
	* Para los años de interés (2013, 2014 & 2015):
		* 1. Drogas 1: 10 proyectos asociados a drogas
		* 2. Drogas 2: 5363 rubros presupuestales de las entidades de interés
		* 3. Drogas 3: 9 rubros presupuestales asociados a drogas del total de Drogas3
	
* 8. Resultados y exportar resultado a formato .xls
	* En excel los programas se clasificarán x estrategias
	* Se clasifica x estrategia con base a la definición de las estrategias CONPES
	
	clear
	cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"	
	use "SIIF.dta", clear
	cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Salidas .xls"
	rm "4. Gasto drogas - SIIF.xls" 
	
	* Índice
	
	putexcel set "4. Gasto drogas - SIIF.xls", sheet("Índice") modify
	putexcel (B8:Q8)   = ("Instrucciones - Sistema Integrado de Información Financiera 2012 - 2016"), merge hcenter vcenter
	putexcel (C10:Q10) = ("Información presupuestal de rubros del gasto por inversión relacionados con drogas"), merge vcenter
	putexcel (C11:Q11) = ("Información presupuestal de rubros del gasto por funcionamiento relacionados con drogas"), merge vcenter
	putexcel (C12:Q12) = ("Información presupuestal de rubros del gasto por funcionamiento de las entidades de interés"), merge vcenter
	putexcel (C13:Q13) = ("Suma total anual desagregada por Sector, Entidad del gasto por inversión en política de drogas"), merge vcenter
	putexcel (C14:Q14) = ("Suma total anual desagregada por Sector, Entidad del gasto por funcionamiento en política de drogas"), merge vcenter

	putexcel B10 = ("D1") B11 = ("D2") B12 = ("D3")	B13 = ("R1") B14 = ("R2")
	putexcel B16 = ("* Los datos están en millones de pesos colombianos")
	putexcel B17 = ("* Los datos están a precios constantes con base 2016")
	
	* 1. Información presupuestal de rubros del gasto por inversión relacionados con drogas
		
		export excel Año Sector UnidadEjecutora2 UnidadEjecutora Nombre Obligacion3 BPIN Objetivo Estrategia using "4. Gasto drogas - SIIF.xls" if Drogas1 == 1 & Año > 2011, sheet("D1") sheetreplace cell(B6) firstrow(variables)
		putexcel set "4. Gasto drogas - SIIF.xls", sheet("D1") modify
		putexcel (B2:J2) = ("GASTO POR INVERSIÓN RELACIONADO CON DROGAS"), merge hcenter vcenter
		putexcel (B3:J3) = ("Rubros presupuestales anuales por entidad, sector y B-PIN"), merge hcenter vcenter
		putexcel (B4:J4) = ("millones de pesos constantes (base 2016)"), merge

	* 2. Información presupuestal de rubros del gasto por funcionamiento relacionados con drogas
		
		export excel Año Sector UnidadEjecutora2 UnidadEjecutora Nombre Obligacion3 BPIN Objetivo Estrategia using "4. Gasto drogas - SIIF.xls" if Drogas3 == 1 & Año > 2011, sheet("D2") sheetreplace cell(B6) firstrow(variables)
		putexcel set "4. Gasto drogas - SIIF.xls", sheet("D2") modify
		putexcel (B2:J2) = ("GASTO POR FUNCIONAMIENTO RELACIONADO CON DROGAS"), merge hcenter vcenter
		putexcel (B3:J3) = ("Rubros presupuestales anuales por entidad, sector y B-PIN"), merge hcenter vcenter
		putexcel (B4:J4) = ("millones de pesos constantes (base 2016)"), merge
		
	* 2. Información presupuestal de rubros del gasto por funcionamiento
		* De las entidades identificadas en el mapa institucional
		
		export excel Año Sector UnidadEjecutora2 UnidadEjecutora Nombre Obligacion3 BPIN Objetivo Estrategia using "4. Gasto drogas - SIIF.xls" if Drogas2 == 1 & Año > 2011, sheet("D3") sheetreplace cell(B6) firstrow(variables)
		putexcel set "4. Gasto drogas - SIIF.xls", sheet("D3") modify
		putexcel (B2:J2) = ("GASTO POR FUNCIONAMIENTO DE LAS ENTIDADES DE INTERÉS"), merge hcenter vcenter
		putexcel (B3:J3) = ("Rubros presupuestales anuales por entidad, sector y B-PIN"), merge hcenter vcenter
		putexcel (B4:J4) = ("millones de pesos constantes (base 2016)"), merge
		
	* 3. Suma total anual desagregada por Sector, Entidad del gasto por inversión en política de drogas
		* Valor total en millones de pesos a $ constantes 2016
		
		table UnidadEjecutora Año if Drogas1 == 1 & Año > 2011, c(sum Obligacion3) row
		preserve
		collapse (sum) Obligacion3 if Drogas1 == 1, by(Año Sector UnidadEjecutora UnidadEjecutora2)
		export excel Sector UnidadEjecutora UnidadEjecutora2 Año Obligacion3 using "4. Gasto drogas - SIIF.xls" if Año > 2011, sheet("R1") sheetreplace cell(B6) firstrow(variables)
		restore
		putexcel set "4. Gasto drogas - SIIF.xls", sheet("R1") modify
		putexcel (B2:F2) = ("TOTAL OBLIGACIONES - GASTO POR INVERSIÓN EN POLÍTICAS DE DROGAS"), merge hcenter vcenter
		putexcel (B3:F3) = ("Suma total anual desagregada por sector y entidad"), merge hcenter vcenter
		putexcel (B4:F4) = ("millones de pesos constantes (base 2016)"), merge

	* 4. Suma total anual desagregada por Sector, Entidad del gasto por funcionamiento en política de drogas
		* Valor total en millones de pesos a $ constantes 2016
		
		table UnidadEjecutora Año if Drogas3 == 1 & Año > 2011, c(sum Obligacion3) row
		preserve
		collapse (sum) Obligacion3 if Drogas3 == 1, by(Año Sector UnidadEjecutora UnidadEjecutora2)
		export excel Sector UnidadEjecutora UnidadEjecutora2 Año Obligacion3 using "4. Gasto drogas - SIIF.xls" if Año > 2011, sheet("R2") sheetreplace cell(B6) firstrow(variables)
		restore
		putexcel set "4. Gasto drogas - SIIF.xls", sheet("R2") modify
		putexcel (B2:F2) = ("TOTAL OBLIGACIONES - GASTO POR FUNCIONAMIENTO EN POLÍTICAS DE DROGAS"), merge hcenter vcenter
		putexcel (B3:F3) = ("Suma total anual desagregada por sector y entidad"), merge hcenter vcenter
		putexcel (B4:F4) = ("millones de pesos constantes (base 2016)"), merge

