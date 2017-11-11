######################################################################################
######################################################################################
            # Metodología Estimación Gasto Fiscal en Política de Drogas #
                        # Análisis Sistemas de Información #
                          # Colombianos en el exterior #
######################################################################################
######################################################################################

# 1. Instalar paquetes

  library("ggplot2")
  library("ggmap")
  library("maptools")
  library("maps")
  library("mapdata")
  library("sp")
  library("readxl")
  library("leaflet")

# 2. Importar Data Colombianos en el Exterior MRE

  data = read_excel("C:/Users/lgoyeneche/OneDrive/Costo Drogas/Entregables/Análisis .do/Datasets .xls/Data Condenados.xlsx")

# 3. Opción 1:
  
  # 3.1. Georeferenciación de oficinas consulares
  
    consul        = as.matrix(data[,1])
    ll.consul     = geocode(consul)
    consul.x      = ll.consul$lon
    consul.y      = ll.consul$lat
  
  # 3.2. Gráfica Mapa con World Imagery
    
    # La función addProviderTiles() permite cambiar el fondo 
    
      # Esri.WorldImagery: fondo de la tierra
      # Esri.WorldStreetMap, .DeLorme, .WorldTopoMap, .WorldTerrain, 
        # .WorldShadedRelief, .WorldPhysical, .OceanBasemap, .NatGeoWorldMap, .WorldGrayCanvas
      # Stamen.TonerHybrid: Nombres de continentes
      # Stamen.Watercolor: en watercolor
      # providers$Esri.NatGeoWorldMap: sin comillas
      # providers$CartoDB.Positron: sin comillas
      # providers$Stamen.Toner: sin comiilas
      # providers$Esri.WorldStreetMap: sin comillas
  
    data[data[,8] == 1,7] = data[data[,8] == 1,7]/100
    data[data[,8] == 0,7] = data[data[,8] == 0,7]/25
    
    mapa = data.frame(long = consul.x, lat = consul.y, total = data[,2], name = data[,1], ID = data$ID)
    m    = leaflet(data = mapa) %>% addTiles() %>%  addProviderTiles("Esri.WorldGrayCanvas") %>% 
      addCircleMarkers(~long, ~lat, radius=~TOTAL.CONSULADO*3, color=~ifelse(mapa$ID>0, "red", "blue"), stroke = TRUE, 
                       fillOpacity = 0.3, popup = ~as.character(OFICINA.CONSULAR))
    m
  
  # 3.2. Gráfica Mapa con colores automáticos

    mapa = data.frame(long = consul.x, lat = consul.y, total = data[,2], name = data[,1], ID = data[,2], ID2 = data[,3])
    m    = leaflet(data = mapa) %>% addTiles() %>% 
      addCircleMarkers(~lon, ~V4, radius=~ID__1*12, color=~ifelse(mapa$ID==1,"green",ifelse(mapa$ID==2,"blue",ifelse(mapa$ID==3,"orange","black"))),
                       stroke = TRUE, fillOpacity = 0.5, popup = ~as.character(CIUDAD))
    m
  
# 4. Opción 2:
  # 4.1 Georeferenciación de oficinas consulares 1
    # Oficinas que concentran el 80% de los colombianos en el exterior
  
    consul        = as.matrix(data[data[,8] == 1,1])
    col_exterior  = as.matrix(data[data[,8] == 1,7])
    ll.consul     = geocode(consul)
    consul.x      = ll.consul$lon
    consul.y      = ll.consul$lat
  
    data1         = cbind(data[data[,8] == 1,1], data[data[,8] == 1,7], consul.x, consul.y)
    data1         = data1[order(data1$`TOTAL CONSULADO`),]
    data1[,5]     = seq_len(nrow(data1))
    
  # 4.2. Georeferenciación de oficinas consulares 2 
    # Todas las oficinas
  
    consul2       = as.matrix(data[data[,8] == 0,1])
    col_exterior2 = as.matrix(data[data[,8] == 0,7])
    ll.consul2    = geocode(consul2)
    consul.x2     = ll.consul2$lon
    consul.y2     = ll.consul2$lat
    
    data2         = cbind(data[data[,8] == 0,1], data[data[,8] == 0,7], consul.x2, consul.y2)
    data2         = data1[order(data2$`TOTAL CONSULADO`),]
    data2[,5]     = seq_len(nrow(data2))
    data2[,6]     = seq_len(0.5, 6.9, by = 0.1)
  
  # 4.3. Gráfica Mapa
  
    map("world", fill = T, interior = F, col=terrain.colors(1), bg="white", ylim=c(-60, 90), mar=c(0,0,0,0))
    points(consul.x2, consul.y2, col=adjustcolor("red", alpha = 0.5), pch = 19, bg = "blue", cex = 0.2)
    points(consul.x, consul.y, col=adjustcolor("red", alpha = 0.5), pch = 19, bg = "red", cex = 2.5)
    
    # 4.3.2. Otros atributos
    
    text(x = ll.consul$lon, y = ll.consul$lat, labels = col_exterior, col = "white", cex = 0.6)
    title("Colombianos actualmente detenidos en el exterior según delito de narcotráfico", cex.main = 0.9)
    legend("bottomleft", inset = 0.04, c("Reportes registrados", "> 80% de los reportes"), 
           cex = 0.8, col = c("blue", "red"), pch = c(19, 25), box.col = "white")
  
  # 4.4. Anexo: Ejemplo aplicación código
  
    visited     = as.matrix(c("London", "Melbourne", "Johannesbury, SA"))
    ejemplo     = as.matrix(c(2,3,4))
    ll.visited  = geocode(visited)
    visit.x     = ll.visited$lon
    visit.y     = ll.visited$lat
  
    map("world", fill = T, interior = F, col="gray60", bg="gray95", ylim=c(-60, 90), mar=c(0,0,0,0))
    points(visit.x, visit.y, col="red", pch = 25, bg = "red", cex = 2.5)
    text(x = ll.visited$lon, y = ll.visited$lat, labels = capturas, col = "white", cex = 0.6)
