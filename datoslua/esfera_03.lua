-- esfera_03.lua

return {
   -- 1. Datos y propiedades de la esfera:
   esfera = {
      radio=2.0, draw="black!15", fill="black!3", opac=1.0,
      smbrcolor="gray!2", smbropac=0.3
   },
   
   -- 2, Posición angular del observador
   observador = {thetaD = 65, phiD = 15},
   
   -- 3. Meridianos
   meridprops = {loops=120, color_vis = "black", lw_vis="0.5pt",
		 colr_novis = "black!25", lw_novis="0.3pt"},

   -- Si se quiere modificar el estilo de algún meridiano en particular, se 
   -- puede añadir el estilo deseado en el elemento correspondiente de la tabla:
   meridianos = {
      {
	 phiD=180.0,
      },
   },
   
   -- 3. Paralelos
   paralprops = {loops=240, color_vis = "black!50", lw_vis="0.4pt",
		 color_novis = "black!10", lw_novis="0.3pt"},

   -- Si se desea utilizar un estilo en particular para un paralelo, se puede
   -- añadir el estilo en el elemento que interese de la siguiente tabla:
   paralelos = {
      {thetaD=90.0},
   },

   -- 4. Segmentos
   segmprops = {color_vis = "black!50", lw_vis="0.4pt",
		 color_novis = "black!10", lw_novis="0.3pt"},
   
   segmentos = {
      {theta1D=60.0, phi1D=-60.0, theta2D=120.0, phi2D=120, phimerD=20},
   },
}


