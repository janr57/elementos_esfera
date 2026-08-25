-- esf_sgmpar_01.lua

return {
   -- 1. Datos y propiedades de la esfera:
   esfera = {
      radio=2.0, draw="black!25", lw="0.6pt", fill="black!8", opac=1.0,
   },

   smbresfera = {ballcolor="white", opac=0.4},   

   -- 2, Posición angular del observador
   observador = {thetaD = 65, phiD = 15},
   
--   -- 3. Paralelos
--   paralprops = {
--      loops = 240, color_vis = "black!60", lw_vis="0.4pt",
--      color_novis = "black!30", lw_novis="0.3pt",
--   },
--
--   -- 4. Paralelos
--   paralelos = {
--      {thetaD = 30},
--      {thetaD = 60},
--      {thetaD = 90},
--      {thetaD = 120},
--      {thetaD = 150},
--   },

--   -- 5. Polos
--   polprops = {
--      color_vis = "black!70", radio_vis="1pt",
--      color_novis = "black!40", radio_novis="1pt",
--   },

   -- 6. Segmentos de paralelos
   sgmparprops = {
      loops = 240,
      color_vis = "black!60", lw_vis = "1pt",
      color_novis = "black!30", lw_novis = "0.8pt",
   },

      sgmparals = {
      {thetaD = 60, phi1D = 45, phi2D = 200,},
      {thetaD = 90, phi1D = 0, phi2D = 60,},
      {thetaD = 110, phi1D = -140, phi2D = 40,},
   }

}


