-- esf_arcosmax_05.lua
--
-- Copyright (C) 2022--2026 José A. Navarro Ramón <janr.devel@gmail.com>
-- Licencia del código GPLv2
-- Licencia Creative Commons Recognition Non-Commercial Share-alike.
-- (CC-BY-NC-SA)

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
      loops = 120, color_vis = "black!60", lw_vis="0.4pt",
      color_novis = "black!30", lw_novis="0.3pt",
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

   -- 4. Paralelos
   paralprops = {
      loops = 240, color_vis = "black!60", lw_vis="0.4pt",
      color_novis = "black!30", lw_novis="0.3pt",
   },

   paralelos = {
      {thetaD = 30},
      {thetaD = 60},
      {thetaD = 90},
      {thetaD = 120},
      {thetaD = 150},
   },

   -- 5. Polos
   polprops = {
      color_vis = "black!70", radio_vis="1pt",
      color_novis = "black!40", radio_novis="1pt",
   },
   
   -- Arcos máximos
      arcmaxprops = {
      loops = 240,
      color_vis = "red", lw_vis = "1.2pt",
      color_novis = "yellow!50", lw_novis = "0.8pt",
   },

   arcosmax = {
--      {theta1D = 130, phi1D = -100, theta2D = 10, phi2D = 290, giro = 1,},
      {theta1D = 60, phi1D = -30, theta2D = 120, phi2D = 150,
      punto = {thetaD = 90, phiD = 30}, giro = 1},
--      {theta1D = 60, phi1D = -30, theta2D = 60, phi2D = 90, giro= 1},
--      (theta1D = 90, phi1D = 0, theta2D = 90, phi2D = 180, phiD = 0},
   },

}



