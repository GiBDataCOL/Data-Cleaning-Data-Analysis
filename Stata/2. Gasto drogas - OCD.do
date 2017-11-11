**************************************************************************************
**************************************************************************************
			* Metodología Estimación Gasto Fiscal en Política de Drogas *
						* Análisis Sistemas de Información *
						 * Infraestructuras Desmanteladas *
**************************************************************************************
**************************************************************************************
**************************************************************************************
* Ejecutar desde el punto # 5
* Lo anterior corresponde a data preparation & cleaning 

	clear
	mat drop _all
	local drop _all
	scalar drop _all
	
* 1. Instalar comandos

	ssc install spmap
	ssc install shp2dta

* 2. Convertir archivos en formato .dta
	* Descargar archivos de http://www.diva-gis.org/gdata
	* Todos los archivos se deben guardar en una misma carpeta
	* Con esos archivos se crea dataset .dta
	
	cd "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Datasets .xls\Geographic Data"
	shp2dta using COL_adm1, data(COL_datad) coor(COL_coordinatesd) genid(id)
	
* 3. Dataset desmantalación en .dta

	import excel "Infraestructura.xlsx", sheet("DIVIPOLA-_Codigos_municipios") firstrow clear
	save Infraestructura.dta, replace
	
* 4. Merge con dataset infraestrutura desmantelada

	use COL_datad.dta, clear
	merge m:m NAME_1 using Infraestructura.dta
	save COL_data2.dta, replace

* 5. Graficar mapa

	use COL_data2.dta, clear	
	spmap Desmantelacion using COL_coordinatesd.dta, id(id) fcolor(BuRd) ocolor(black) osize(vvthin) legend(size(*1.4))
	graph export "C:\Users\lgoyeneche\OneDrive\Costo Drogas\Entregables\Análisis .do\Salidas .xls\2. Gasto drogas - OCD.png"
	
	
	