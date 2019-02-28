
library(shiny)
library(raster)
library(rgdal)


shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    
    topo <- raster(x = "./data_sets/DEM_geotiff/alwdgg.tif")
  
    if (input$month=="January")          {
      month <- "01"
    } else if (input$month=="February")  {
      month <- "02"
    } else if (input$month=="March")     {
      month <- "03"
    } else if (input$month=="April")     {
      month <- "04"
    } else if (input$month=="May")       {
      month <- "05"
    } else if (input$month=="June")      {
      month <- "06"
    } else if (input$month=="July")      {
      month <- "07"
    } else if (input$month=="August")    {
      month <- "08"
    } else if (input$month=="September") {
      month <- "09"
    } else if (input$month=="October")   {
      month <- "10"
    } else if (input$month=="November")  {
      month <- "11"
    } else if (input$month=="December")  {
      month <- "12"
    }
      
    if (input$clim_var=="Min temp")          {
      clim_var <- "tmin"
    } else if (input$clim_var=="Max temp")  {
      clim_var <- "tmax"
    }
      
    var_col <- ifelse(clim_var == "tmin", "blue", "red")
    clim <- raster(x = paste("./data_sets/WorldClim2/wc2.0_5m_",clim_var,"_",month,".tif", sep=""))
    
    input_1 <- input$lat_1
    input_2 <- input$lat_2
    input_3 <- ifelse(input$lon==180, 180-0.1, input$lon) #to avoid exceeding the limits of the map
    
    if (input_1 != input_2) {
    
    # crop Raster
    box <- as(extent(input_3, input_3+0.1, min(c(input_1, input_2)),max(c(input_1, input_2))), 'SpatialPolygons')
    
    crs(box) <- crs(topo)
    cropped.topo <- crop(topo, box)
    
    crs(box) <- crs(clim)
    cropped.clim <- crop(clim, box)
    

    
    #extract values and coordinates from raster
    #code taken from:
    #https://gis.stackexchange.com/questions/142156/r-how-to-get-latitudes-and-longitudes-from-a-rasterlayer
    
    
    #topography
    r2p.topo <- rasterToPoints(cropped.topo, spatial = TRUE)
    proj.topo <-  "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"
    trns.topo <- spTransform(r2p.topo, CRS(proj.topo))
    df.topo <- as.data.frame(trns.topo)
    
    par(mar=c(4,4,4,4))
    plot(df.topo$y,df.topo$alwdgg, type="n", col="red", bty='n',xlab="", ylab = "", axes=FALSE)
    axis(side=2, col.axis="black", las=1)
    mtext("Elevation (m)",line=3, side=2, las=0, col="black")
    axis(side=1, col.axis="black")
    mtext("Latitude", line=3, side=1, las=0, col="black")
    
    
    
    elev <- df.topo$alwdgg
    elev[elev>0] <- 0
    polygon(c(df.topo$y, rev(df.topo$y)),c(elev,(rep(0, length(elev)))), col="lightblue", border="lightblue")
    
    polygon(c(df.topo$y, rev(df.topo$y)),c(df.topo$alwdgg,(rep(min(df.topo$alwdgg), length(df.topo$alwdgg)))), col="darkgrey", border="darkgrey")
    
    #temperature

    r2p.clim <- rasterToPoints(cropped.clim, spatial = TRUE)
    
    if (nrow(as.data.frame(r2p.clim))>0) {
      
      proj.clim <-  "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"
      trns.clim <- spTransform(r2p.clim, CRS(proj.clim))
      df.clim <- as.data.frame(trns.clim)
      
      #The above approach does not preserve NAs, so gaps in the data are not visible when 
      #plotting the curve.
      
      #solution: convert all the cropped data to 1s, so that all cells
      #are preserved when converted to spatial object
      #then merge this list with the cropped box to see which cells have no values
      
      cropped.clim_1 <- cropped.clim
      cropped.clim_1[is.na(cropped.clim_1)] <- 1
      cropped.clim_1[cropped.clim_1] <- 1
      
      
      r2p.clim_1 <- rasterToPoints(cropped.clim_1, spatial = TRUE)
      proj.clim_1 <-  "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"
      trns.clim_1 <- spTransform(r2p.clim_1, CRS(proj.clim_1))
      
      
      df.clim_1 <- as.data.frame(trns.clim_1)
      df.clim.merged <- merge(df.clim_1, df.clim, by.x=c("x","y"),by.y=c("x","y"), all.x=TRUE)
      df.clim.merged <- df.clim.merged[order(df.clim.merged$y),]
      
      
      
      par(new=TRUE)
      plot(df.clim.merged$y,df.clim.merged[,4], type="l", col=var_col, bty='n', axes=FALSE, xlab="", ylab = "")
      axis(side=4, col.axis=var_col, col=var_col, las=1)
      mtext("degrees C", line=3, side=4, las=0, col=var_col)
      
    }
    
    }
    
  })
  
})
