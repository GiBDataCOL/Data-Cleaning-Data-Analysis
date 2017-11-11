**************************************************************************************
**************************************************************************************
			* Metodología Estimación Gasto Fiscal en Política de Drogas *
						* Análisis Sistemas de Información  *
						* Sistema General de Regalías - SGR *
**************************************************************************************
**************************************************************************************
* Ejecutar desde el punto # 9 
* Lo anterior corresponde a data preparation & cleaning  

	clear
	mat drop _all
	local drop _all
	scalar drop _all

* 1. Importar data
		
	cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .xls"
	set excelxlsxlargefile on
	set maxvar 32767 
	import excel "Data SGR.xlsx", sheet("D1") cellrange() firstrow

* 2. Guardar en formato .dta (SGR)

	cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"
	save "SGR.dta", replace

* 3. Llamar dataset en formato .dta (SGR)

	clear
	cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"
	use "SGR.dta", clear
	
* 4. Keep, rename y lower case variables de interés

	keep CódigoBPIN Proyectonuevo CódigoDANE OCAD Departamento EntidadTerritorial Región SectorPGN Proyecto Mes Año VT_1
	rename (CódigoBPIN Proyectonuevo CódigoDANE OCAD Departamento EntidadTerritorial Región SectorPGN Proyecto Mes Año)(BPIN Nuevo Cod_DANE OCAD Depto Entidad Region Sector Proyecto Mes Año)
	replace Proyecto = lower(Proyecto)	

* 5. Valor Total del Proyecto en millones de pesos & precios constantes 2016

	gen VT_11 = VT_1/1000000
	lab var VT_11 "Obligacion mill"
		
	gen VT_2 = .
	replace VT_2 = VT_11 if Año == 2016 
	replace VT_2 = VT_11*133.39977/126.14945 if Año == 2015
	replace VT_2 = VT_11*133.39977/118.15166 if Año == 2014
	replace VT_2 = VT_11*133.39977/113.98254 if Año == 2013
	replace VT_2 = VT_11*133.39977/111.81576 if Año == 2012
	lab var VT_2 "Obligacion mill $ cons 2016"

		
* 6. Guardar en formato .dta (SGR)

	save "SGR.dta", replace
	
* 7. Seleccionar los proyectos asociados a política de drogas

	gen Drogas = 0 
	lab var Drogas "Proyectos drogas" 
	
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
			replace Drogas = 1 if strpos(Proyecto, "`i'")
		}
	}

* 8. Guardar en formato .dta (SGR drogas)
	* Paso de 11,189 a 398 observaciones

	drop if Drogas == 0
	save "SGR Drogas.dta", replace

* 9. Double-check de los proyectos filtrados 

	clear
	cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"
	use "SGR Drogas.dta", clear

	* Mirar proyecto por proyecto manualmente
	* Proyecto no relacionado con drogas se cambia a 0 en la var Drogas
	
	save "SGR Drogas 2.dta", replace

* 10. Resultados y exportar resultado a formato .xls
	* En excel los programas se clasificarán x estrategias
	* Se clasifica x estrategia con base a la definición de las estrategias CONPES
	
	clear
	cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .dta"	
	use "SGR Drogas 2.dta", clear
	cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Salidas .xls"
	rm "1. Gasto drogas - SGR.xls"
	
	* Índice
	
	putexcel set "1. Gasto drogas - SGR.xls", sheet("Índice") modify
	putexcel (B8:Q8)   = ("Instrucciones - Sistema General de Regalías 2012 - 2016"), merge hcenter vcenter
	putexcel (C10:Q10) = ("Suma total anual de los proyectos asociados a política de drogas"), merge vcenter
	putexcel (C11:Q11) = ("Suma total anual de los proyectos asociados a política de drogas por sector PGN"), merge vcenter
	putexcel (C12:Q12) = ("Suma total anual de los proyectos asociados a política de drogas por departamentos"), merge vcenter
	
	putexcel B10 = ("R1") B11 = ("R2") B12 = ("R3")	
	putexcel B14 = ("* Los datos están en millones de pesos colombianos")
	putexcel B15 = ("* Los datos están a precios constantes con base 2016")
	
	* 1. Suma total anual de los proyectos asociados a política de drogas
		* Valor total en millones de pesos a $ constantes 2016
	
		table Proyecto Año if Drogas == 1, c(sum VT_2) row
			
		preserve
		collapse (sum) VT_2 if Drogas == 1, by(Año Proyecto)
		table Proyecto Año, c(sum VT_2) row
		export excel Proyecto Año VT_2 using "1. Gasto drogas - SGR.xls", sheet("R1") sheetreplace cell(E6) firstrow(variables)
		restore
		
		tabstat VT_2 if Drogas == 1, by(Año) stat(sum) save
		matrix T1 = (r(Stat1)\r(Stat2)\r(Stat3)\r(Stat4))
		matrix rownames T1 = `r(name1)' `r(name2)' `r(name3)' `r(name4)'
		matrix colnames T1 = "Valor total"
		
		putexcel set "1. Gasto drogas - SGR.xls", sheet("R1") modify
		putexcel B6 = matrix(T1), names nformat(number_d2)
		putexcel F2 = " "
		putexcel (B2:G2) = ("VALOR TOTAL PROYECTOS ASOCIADOS A POLÍTICAS DE DROGAS"), merge hcenter vcenter
		putexcel (B3:G3) = ("Suma total anual desagregada por sector PGN"), merge hcenter vcenter
		putexcel (B4:G4) = ("millones de pesos constantes (base 2016)"), merge
			
	* 2. Suma total anual desagregada por sector PGN
		* Valor total en millones de pesos a $ constantes 2016
		
		table Proyecto Año Sector if Drogas == 1, c(sum VT_2) row
		preserve
		collapse (sum) VT_2 if Drogas == 1, by(Año Proyecto Sector)
		export excel Proyecto Año Sector VT_2 using "1. Gasto drogas - SGR.xls", sheet("R2") sheetreplace cell(B6) firstrow(variables)
		restore
		putexcel set "1. Gasto drogas - SGR.xls", sheet("R2") modify
		putexcel (B2:E2) = ("VALOR TOTAL PROYECTOS ASOCIADOS A POLÍTICAS DE DROGAS"), merge hcenter vcenter
		putexcel (B3:E3) = ("Suma total anual desagregada por sector PGN"), merge hcenter vcenter
		putexcel (B4:E4) = ("millones de pesos constantes (base 2016)"), merge

	* 3. Suma total anual desagregada por Departamento (Código DANE)
		* Valor total en millones de pesos a $ constantes 2016
		
		table Proyecto Año Depto if Drogas == 1, c(sum VT_2) row
		preserve
		collapse (sum) VT_2 if Drogas == 1, by(Año Proyecto Depto)
		export excel Proyecto Año Depto VT_2 using "1. Gasto drogas - SGR.xls", sheet("R3") sheetreplace cell(B6) firstrow(variables)
		restore
		putexcel set "1. Gasto drogas - SGR.xls", sheet("R3") modify
		putexcel (B2:E2) = ("VALOR TOTAL PROYECTOS ASOCIADOS A POLÍTICAS DE DROGAS"), merge hcenter vcenter
		putexcel (B3:E3) = ("Suma total anual desagregada por sector PGN"), merge hcenter vcenter
		putexcel (B4:E4) = ("millones de pesos constantes (base 2016)"), merge

		
		
		
