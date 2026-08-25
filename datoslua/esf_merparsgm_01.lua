-- esf_merparsgm_01.lua

return {
   -- 1. Datos y propiedades de la esfera:
   esfera = {
      radio=2.0, draw="black!25", lw="0.6pt", fill="black!8", opac=1.0,
   },

   smbresfera = {ballcolor="green", opac=0.4},

   -- 2, Posición angular del observador
   observador = {thetaD = 65, phiD = 15},

   -- 3. Meridianos
   meridprops = {
      loops = 120, color_vis = "black!60", lw_vis="0.5pt",
      color_novis = "black!40", lw_novis="0.35pt",
   },

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
      loops = 240, color_vis = "black!60", lw_vis="0.5pt",
      color_novis = "black!40", lw_novis="0.35pt",
   },

   paralelos = {
      --{thetaD = 0},
      {thetaD = 30},
      {thetaD = 60},
      {thetaD = 90},
      {thetaD = 120},
      {thetaD = 150},
   },

   sgmparalprops = {
      loops = 240, color_vis = "red!60", lw_vis="0.5pt",
      color_novis = "black!40", lw_novis="0.35pt",
   },

   sgmparalelos = {
      phi1D = 0, phi2D = 60, thetaD = 60
   }
}


