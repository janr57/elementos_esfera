-- esf_merid_02.lua

return {
   -- 1. Datos y propiedades de la esfera:
   esfera = {
      radio=2.0, draw="black!25", lw="0.6pt", fill="black!8", opac=1.0,
   },

   smbresfera = {ballcolor="white", opac=0.4},
   
   -- 2, Posición angular del observador
   observador = {thetaD = 65, phiD = 15},
   
   -- 3. Meridianos
   meridprops = {
      loops = 120,
      color_vis = "black!60", lw_vis="0.8pt", estilo_vis = "linea",
      color_novis = "black!40", lw_novis="0.4pt", estilo_novis = "linea",
   },

   -- Si se quiere modificar el estilo de algún meridiano en particular, se 
   -- puede añadir el estilo deseado en el elemento correspondiente de la tabla:
   meridianos = {
      {phiD = 0,},
      {phiD = 30},
      {phiD = 60},
      {phiD = 90},
      {phiD = 120},
      {phiD = 150},
      {phiD = 180},
      {phiD = -30},
      {phiD = -60},
      {phiD = -90},
      {phiD = -120},
      {phiD = -150}
   },
}


