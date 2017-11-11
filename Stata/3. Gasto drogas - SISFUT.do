**************************************************************************************
**************************************************************************************
			* Metodología Estimación Gasto Fiscal en Política de Drogas *
						* Análisis Sistemas de Información  *
		* Sistema de Información del Formulario Único Territorial - SISFUT *
**************************************************************************************
**************************************************************************************
* Ejecutar desde el punto # 10
* Lo anterior corresponde a data preparation & cleaning  

	clear
	mat drop _all
	local drop _all
	scalar drop _all

* 1. Importar data
	
	cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .xls"
	set excelxlsxlargefile on
	set maxvar 32767 

* 2. Guardar en formato .dta (SISFUT)

	* Guardar en formato .dta data funcionamiento e inversión x año
	
		forvalues i = 11/15 {
			cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .xls"
			import excel "Data SISFUT.xlsx", sheet("FUT - GF `i'") firstrow
			cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"
			save "FUT GF `i'.dta", replace
			clear
	}
		forvalues i = 11/15 {
			cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .xls"
			import excel "Data SISFUT.xlsx", sheet("FUT - GI `i'") firstrow
			cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"
			save "FUT GI `i'.dta", replace
			clear
	}
	
	* Append SISFUT .dta data funcionamiento e inversión x año
		* Cambiar GI por GF para tener data append del gasto por funcionamiento
	
		local data "I F"
		foreach x of local data {
			use "FUT G`x' 15.dta", clear
			save FUT_G`x'.dta, replace
			
			forvalues i = 11/14 {
				use FUT_G`x'.dta, replace
				append using "FUT G`x' `i'.dta", force
				save FUT_G`x'.dta, replace
			}
			forvalues i = 11/15 {
				erase "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta\FUT G`x' `i'.dta"
			}
		}
	
		use "FUT_GF.dta", clear
		append using "FUT_GI.dta"
		
	* Guardar en formato .dta (SISFUT)
	
	cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"
	save "SISFUT.dta", replace
	
	erase "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta\FUT GI.dta"
	erase "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta\FUT GF.dta"
	
* 3. Llamar dataset en formato .dta (SGR)

	clear
	cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"
	use "SISFUT.dta", clear
			
* 4. Modificar variable "Total Obligaciones" en millones de pesos y $ constantes 2016
	* Se utilizaron las cifras del IPC provenientes del DANE (www.dane.gov.co)
	
	gen TotalObligaciones2 = TotalObligaciones/1000
	lab var TotalObligaciones2 "Total Obligaciones mill" 	

	gen TotalObligaciones3 = .
	replace TotalObligaciones3 = TotalObligaciones2*133.39977/126.14945 if Año == 2015
	replace TotalObligaciones3 = TotalObligaciones2*133.39977/118.15166 if Año == 2014
	replace TotalObligaciones3 = TotalObligaciones2*133.39977/113.98254 if Año == 2013
	replace TotalObligaciones3 = TotalObligaciones2*133.39977/111.81576 if Año == 2012
	replace TotalObligaciones3 = TotalObligaciones2*133.39977/109.15740 if Año == 2011
	lab var TotalObligaciones3 "Total Obligaciones mill $ const"

* 5. Guardar en formato .dta (SISFUT)

	save "SISFUT.dta", replace
	
* 7. Cambio en variable Tipo Entidad
	* Categoría Distrital por Municipal
	
	replace TipoEntidad = "Entidad Territorial Municipal" if TipoEntidad == "Entidad Territorial Distrital"

* 6. Generar variable para identificar departamentos y municipios de interés

	gen Deptos = . 
	replace Deptos = 1 if 	NombreDANEDepartamento == "BOGOTÁ, D.C." | /*
						*/	NombreDANEDepartamento == "ANTIOQUIA" | /*
						*/	NombreDANEDepartamento == "VALLE DEL CAUCA" | /*
						*/	NombreDANEDepartamento == "CUNDINAMARCA" | /*
						*/	NombreDANEDepartamento == "ATLÁNTICO" | /*
						*/	NombreDANEDepartamento == "BOLÍVAR" | /*
						*/	NombreDANEDepartamento == "SANTANDER" | /*
						*/	NombreDANEDepartamento == "CAQUETÁ" | /*
						*/	NombreDANEDepartamento == "META" | /*
						*/	NombreDANEDepartamento == "NARIÑO" | /*
						*/	NombreDANEDepartamento == "CAUCA" | /*
						*/	NombreDANEDepartamento == "PUTUMAYO" | /* 
						*/	NombreDANEDepartamento == "QUINDIO" | /* 
						*/	NombreDANEDepartamento == "CALDAS" | /* 
						*/	NombreDANEDepartamento == "CÓRDOBA"
	replace Deptos = 0 if Deptos == . 

	gen Muni = . 
	replace Muni = 1 if 	NombreDANEMunicipio == "BOGOTÁ, D.C." | /*
						*/	NombreDANEMunicipio == "MEDELLÍN" | /*
						*/	NombreDANEMunicipio == "CALI" | /*
						*/	NombreDANEMunicipio == "BARRANQUILLA" | /*
						*/	NombreDANEMunicipio == "CARTAGENA" | /*
						*/	NombreDANEMunicipio == "CÚCUTA" | /*
						*/	NombreDANEMunicipio == "SOLEDAD" | /*
						*/	NombreDANEMunicipio == "IBAGUÉ" | /*
						*/	NombreDANEMunicipio == "SOACHA" | /*
						*/	NombreDANEMunicipio == "BUCARAMANGA" | /* 
						*/	NombreDANEMunicipio == "VILLAVICENCIO"
	replace Muni = 0 if Muni == . 	
	
	save "SISFUT.dta", replace
 
* 7. Keep observaciones de interés
	* Se utilizarán las cifras de:
		* A.2. SALUD 
		* A.2.2. SALUD PÚBLICA
		* A.2.2.4. SALUD MENTAL Y LESIONES VIOLENTAS EVITABLES
		* A.2.2.4.1. SUSTANCIA PSICOACTIVAS
		* A.2.2.4.1.1. CONTRATACIÓN CON LAS EMPRESAS SOCIALES DEL ESTADO
		* A.2.2.4.1.2. ADQUISICIÓN DE INSUMOS Y ELEMENTOS, PUBLICACIONES Y EQUIPOS PARA DESARROLLAR PROGRAMAS DE SALUD PÚBLICA
		* A.2.2.4.1.3. CONTRATACIÓN CON PERSONAS JURÍDICAS QUE NO SEAS ESES
		* A.2.2.4.1.4. CONCURRENCIA A MUNICIPIOS
		* A.2.2.4.1.5. TALENTO HUMANO QUE DESARROLLA FUNCIONES DE CARÁCTER OPERATIVO

		* A.2.2.14 GASTOS POR VENTA DE MEDICAMENTOS CONTROLADOS (FONDO ROTATORIO DE ESTUPEFACIENTES)
		* A.2.2.14.1 CONTRATACIÓN, CON LAS EMPRESAS SOCIALES DEL ESTADO
		* A.2.2.14.2 ADQUISICIÓN DE INSUMOS, ELEMENTOS, PUBLICACIONES Y EQUIPOS PARA DESARROLLAR LAS PRIORIDADES  DE SALUD PÚBLICA, SEGÚN COMPETENCIAS
		* A.2.2.14.3 CONTRATACIÓN CON PERSONAS  JURÍDICAS QUE NO SEAN ESE´S
		* A.2.2.14.4 CONCURRENCIA A MUNICIPIOS
		* A.2.2.14.5 TALENTO HUMANO QUE DESARROLLA FUNCIONES DE CARÁCTER OPERATIVO
		
		* A.18.4 FONDO DE SEGURIDAD DE LAS ENTIDADES 
		* A.18.4 FONDO TERRITORIAL DE SEGURIDAD (LEY 1106 DE 2006)
		* A.18.4.1 DOTACIÓN Y MATERIAL DE GUERRA
		* A.18.4.2 RECONSTRUCCIÓN DE CUARTELES Y DE OTRAS INSTALACIONES
		* A.18.4.3 COMPRA DE EQUIPO DE COMUNICACIÓN, MONTAJE Y OPERACIÓN DE REDES DE INTELIGENCIA
		* A.18.4.4 RECOMPENSAS A PERSONAS QUE COLABOREN CON LA JUSTICIA Y SEGURIDAD DE LAS MISMAS
		* A.18.4.5 SERVICIOS PERSONALES, DOTACIÓN Y RACIONES PARA NUEVOS AGENTES Y SOLDADOS
		* A.18.4.6 GASTOS DESTINADOS A GENERAR AMBIENTES QUE PROPICIEN LA SEGURIDAD CIUDADANA Y LA PRESERVACIÓN DEL ORDEN PÚBLICO.
		* A.18.4.7 DESARROLLO DEL PLAN INTEGRAL DE SEGURIDAD Y CONVIVENCIA CIUDADANA
		* A.18.4.8 COMPRA DE TERRENOS
		
	keep if CódigoConcepto == "A.2.2.4.1" | CódigoConcepto == "A.2.2.14" | CódigoConcepto == "A.18.4"
	
	* Paso de 2.165.253 a 7.880 observaciones
	* FONSET: 5.197 observaciones
	* FNE: 211 observaciones
	* SALUD MENTAL: 2.473 observaciones
	
* 8. Drop Año 2011
	* Inconsistencias en la información
	* Departamentos con gasto por inversión inconsistente
	
	drop if Año == 2011
	
	* Paso de 7.880 a 6.566 observaciones
	* FONSET: 4.314 observaciones
	* FNE: 211 observaciones
	* SALUD MENTAL: 2.041 observaciones
	
* 9. Modificaciones en la data por inconsistencias
	* Departamental: $6,221 (2012), $6,194 (2013), $7,377 (2014) & $30,933 (2015) mill
		* Problema: Arauca reporta $604 (2012), $600 (2013), $128 (2014) & $24,305 (2015) mill
			* Opción 1: Se le quitan 2 ceros al valor de 2015
			* Opción 2: Se elimina la obseración
			* La diferencia entre ambas opciones no es significativa
			* Nos quedamos con la opción 1
		
	replace TotalObligaciones3 = 243 if TipoEntidad == "Entidad Territorial Departamental" /*
									*/	& NombreDANEDepartamento == "ARAUCA" /*
									*/  & Año == 2015
	save "SISFUT Drogas.dta", replace

	* Municipal: $20,201 (2012), $399,581 (2013), $20,426 (2014) & $26,909 (2015) mill
		* Problema: * Pamplona reporta $18 (2012) & $40,875 (2013)
					* Solano reporta $329,922 (2013)
					* Tolú Viejo reporta $0.1 (2012), $9,362 (2013), $4 (2014) & $4(2015)
		* Opción 1: Se le quitan la cantidad de ceros X para que sea consistente
		* Opción 2: Se elimina la observación
		* La diferencia entre ambas opciones no es significativa
		* Nos quedamos con la opción 2
		
	drop if 	NombreDANEMunicipio == "PAMPLONA" /*
		*/	| 	NombreDANEMunicipio == "SOLANO" /*
		*/	| 	NombreDANEMunicipio == "TOLÚ VIEJO" /*
		*/  | 	NombreDANEMunicipio == "SAN PELAYO"
	
	save "SISFUT Drogas.dta", replace

* 10. Guardar en formato .dta (SISFUT drogas)
	* Número de observaciones final: 6.546 observaciones
	* No se tiene en cuenta el gasto por funcionamiento: no tiene rubros asociados a drogas

	save "SISFUT Drogas.dta", replace

* 11. Resultados y exportar resultado a formato .xls
	* En excel los programas se clasificarán x estrategias
	* Se clasifica x estrategia con base a la definición de las estrategias CONPES
	
	clear
	cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"	
	use "SISFUT Drogas.dta", clear
	cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Salidas .xls"
	rm "3. Gasto drogas - SISFUT.xls" 
	
	* Índice
	
	putexcel set "3. Gasto drogas - SISFUT.xls", sheet("Índice") modify
	putexcel (B8:Q8)   = ("Instrucciones - Sistema de Información del Formulario Único Territorial 2012 - 2015"), merge hcenter vcenter
	putexcel (C10:Q10) = ("Suma total anual gastos en salud mental por consumo de SPA y en gasto por venta de medicamentos controlados"), merge vcenter
	putexcel (C11:Q11) = ("Suma total anual gastos en salud mental por consumo de SPA y en gasto por venta de medicamentos controlados por tipo de entidad"), merge vcenter
	putexcel (C12:Q12) = ("Suma total anual gastos en salud mental por consumo de SPA y en gasto por venta de medicamentos controlados por departamento"), merge vcenter
	putexcel (C13:Q13) = ("Suma total anual gastos en salud mental por consumo de SPA y en gasto por venta de medicamentos controlados por municipio"), merge vcenter
	putexcel (C14:Q14) = ("Suma total anual gasto FONSET por tipo de entidad"), merge vcenter

	putexcel B10 = ("R1") B11 = ("R2") B12 = ("R3")	B13 = ("R4") B14 = ("R5")
	putexcel B16 = ("* Los datos están en millones de pesos colombianos")
	putexcel B17 = ("* Los datos están a precios constantes con base 2016")
	
	* 1. Suma total anual  del gasto en salud - sustancias psicoactivas & FNE
		* Valor total en millones de pesos a $ constantes 2016
	
		tabstat TotalObligaciones3 if CódigoConcepto == "A.2.2.4.1" | CódigoConcepto == "A.2.2.14", by(Año) stat(sum) save

		matrix T1 = (r(Stat1)\r(Stat2)\r(Stat3)\r(Stat4))
		matrix rownames T1 = `r(name1)' `r(name2)' `r(name3)' `r(name4)'
		matrix colnames T1 = "Total Obligaciones"
		
		putexcel set "3. Gasto drogas - SISFUT.xls", sheet("R1") modify
		putexcel B6 = matrix(T1), names nformat(number_d2)
		putexcel F2 = " "
		putexcel (B2:G2) = ("TOTAL OBLIGACIONES - POLÍTICAS DE DROGAS SECTOR SALUD"), merge hcenter vcenter
		putexcel (B3:G3) = ("Suma total anual desagregada por sector PGN"), merge hcenter vcenter
		putexcel (B4:G4) = ("millones de pesos constantes (base 2016)"), merge
			
	* 2. Suma total anual desagregada por tipo de entidad
		* Valor total en millones de pesos a $ constantes 2016
		
		table TipoEntidad Año if CódigoConcepto == "A.2.2.4.1" | CódigoConcepto == "A.2.2.14", c(sum TotalObligaciones3) row
		preserve
		collapse (sum) TotalObligaciones3, by(Año TipoEntidad)
		export excel TipoEntidad Año TotalObligaciones3 using "3. Gasto drogas - SISFUT.xls", sheet("R2") sheetreplace cell(B6) firstrow(variables)
		restore
		putexcel set "3. Gasto drogas - SISFUT.xls", sheet("R2") modify
		putexcel (B2:E2) = ("TOTAL OBLIGACIONES - POLÍTICAS DE DROGAS SECTOR SALUD"), merge hcenter vcenter
		putexcel (B3:E3) = ("Suma total anual desagregada por sector PGN"), merge hcenter vcenter
		putexcel (B4:E4) = ("millones de pesos constantes (base 2016)"), merge

	* 3. Suma total anual desagregada por Departamento (Código DANE)
		* Valor total en millones de pesos a $ constantes 2016
		
		table NombreDANEDepartamento Año  if TipoEntidad == "Entidad Territorial Departamental" & CódigoConcepto == "A.2.2.4.1" | /*
										*/   TipoEntidad == "Entidad Territorial Departamental" & CódigoConcepto == "A.2.2.14", c(sum TotalObligaciones3) row
		preserve
		collapse (sum) TotalObligaciones3 if TipoEntidad == "Entidad Territorial Departamental" & CódigoConcepto == "A.2.2.4.1" | /*
										*/	 TipoEntidad == "Entidad Territorial Departamental" & CódigoConcepto == "A.2.2.14", by(Año NombreDANEDepartamento CódigoConcepto)
		export excel CódigoConcepto NombreDANEDepartamento Año TotalObligaciones3 using "3. Gasto drogas - SISFUT.xls", sheet("R3") sheetreplace cell(B6) firstrow(variables)
		restore
		putexcel set "3. Gasto drogas - SISFUT.xls", sheet("R3") modify
		putexcel (B2:E2) = ("TOTAL OBLIGACIONES - POLÍTICAS DE DROGAS SECTOR SALUD"), merge hcenter vcenter
		putexcel (B3:E3) = ("Suma total anual desagregada por Departamento"), merge hcenter vcenter
		putexcel (B4:E4) = ("millones de pesos constantes (base 2016)"), merge

	* 4. Suma total anual desagregada por Municipio (Código DANE)
		* Valor total en millones de pesos a $ constantes 2016
		
		table NombreDANEMunicipio Año 	 if TipoEntidad == "Entidad Territorial Municipal" & CódigoConcepto == "A.2.2.4.1" | /*
										*/	TipoEntidad == "Entidad Territorial Municipal" & CódigoConcepto == "A.2.2.14", c(sum TotalObligaciones3) row
		preserve
		collapse (sum) TotalObligaciones3 if TipoEntidad == "Entidad Territorial Municipal" & CódigoConcepto == "A.2.2.4.1" | /*
										*/	 TipoEntidad == "Entidad Territorial Municipal" & CódigoConcepto == "A.2.2.14", by(Año NombreDANEMunicipio CódigoConcepto)
		export excel CódigoConcepto NombreDANEMunicipio Año TotalObligaciones3 using "3. Gasto drogas - SISFUT.xls", sheet("R4") sheetreplace cell(B6) firstrow(variables)
		restore
		putexcel set "3. Gasto drogas - SISFUT.xls", sheet("R4") modify
		putexcel (B2:E2) = ("TOTAL OBLIGACIONES - POLÍTICAS DE DROGAS SECTOR SALUD"), merge hcenter vcenter
		putexcel (B3:E3) = ("Suma total anual desagregada por Municipio"), merge hcenter vcenter
		putexcel (B4:E4) = ("millones de pesos constantes (base 2016)"), merge		
	
	* 5. Suma total anual gasto FONSET por tipo de entidad
		* Valor total en millones de pesos a $ constantes 2016

		table TipoEntidad Año if CódigoConcepto == "A.18.4", c(sum TotalObligaciones3) row
		table TipoEntidad Año if CódigoConcepto == "A.18.4" & Depto == 1 |/*
							*/	 CódigoConcepto == "A.18.4" & Muni == 1, c(sum TotalObligaciones3) row

		preserve
		collapse (sum) TotalObligaciones3 if CódigoConcepto == "A.18.4", by(Año TipoEntidad)
		export excel TipoEntidad Año TotalObligaciones3 using "3. Gasto drogas - SISFUT.xls", sheet("R5") sheetreplace cell(B6) firstrow(variables)
		restore
		preserve
		collapse (sum) TotalObligaciones3 if CódigoConcepto == "A.18.4" & Depto == 1 & TipoEntidad == "Entidad Territorial Departamental" |/*
										*/	 CódigoConcepto == "A.18.4" & Muni == 1 & TipoEntidad == "Entidad Territorial Municipal", by(Año TipoEntidad NombreDANEDepartamento NombreDANEMunicipio)
		export excel NombreDANEDepartamento NombreDANEMunicipio TipoEntidad Año TotalObligaciones3 using "3. Gasto drogas - SISFUT.xls", sheet("R5") sheetmodify cell(F6) firstrow(variables) 
		restore
		putexcel set "3. Gasto drogas - SISFUT.xls", sheet("R5") modify
		putexcel (B2:J2) = ("TOTAL OBLIGACIONES - POLÍTICAS DE DROGAS FONSET"), merge hcenter vcenter
		putexcel (B3:J3) = ("Suma total anual desagregada por sector PGN"), merge hcenter vcenter
		putexcel (B4:J4) = ("millones de pesos constantes (base 2016)"), merge
	
		