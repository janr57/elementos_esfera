-- esf_ppv_01.lua
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

   -- 6. Puntos, planos y vectores
   -- Propiedades generales ppv:
   -- Puntos
   ppvptosprops = {
      color = "black", radio = "0.8pt", dibuja = true,
   },
   -- Planos
   ppvplnsprops = {
      angD = 0, draw = "blue", fill = "blue!40", opac = 0.5, dibuja = true,
   },
   -- Vectores (la dirección y sentido o ángulo se determina para cada vector)
   ppvvectsprops = {
      color = "black", mod = 1.0, dibuja = false
   },
   
   ppvs = {
      -- 1
      {
	 punto = {thetaD = 90, phiD = 0,},
	 plano = {ancho = 2.0, alto = 2.0,},
	 vects = {
	    {ang = 0,},
	    {ang = 90,},
	 },
      },
      
      -- 2
      {
	 punto = {thetaD = 0, phiD = 0,},
	 plano = {ancho = 2.0, alto = 2.0, draw="red", fill="red!50",},
	 vects = {
	    {ang = 0,},
	    {ang = 90,},
	 },
      },
   },
}

