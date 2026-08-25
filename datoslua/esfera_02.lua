-- esfera_02.lua

return {
   -- 1. Datos y propiedades de la esfera:
   esfera = {
      radio=2.0, draw="black!15", fill="black!3", opac=1.0,
      smbrcolor="gray!2", smbropac=0.3
   },
   
   -- 2, Posición angular del observador
   observador = {thetaD = 65, phiD = 15},
   
   -- 3. Meridianos
   meridprops = {estilo_vis = "black!50, line width=0.4pt",
		 estilo_novis = "black!25, line width=0.2pt"},

   -- Si se quiere modificar el estilo de algún meridiano en particular, se 
   -- puede añadir el estilo deseado en el elemento correspondiente de la tabla:
   meridianos = {
      {phiD=0,},
      {phiD=30,},
      {phiD=60,},
      {phiD=90,},
      {phiD=120,},
      {phiD=150,},
      {phiD=180,},
      {phiD=210,},
      {phiD=240,},
      {phiD=270,},
      {phiD=300,}, 
      {phiD=330,},
   },
   
   -- 3. Paralelos
   paralprops = {estilo_vis = "black!60, line width=0.4pt",
		 estilo_novis = "black!30, line width=0.2pt"},

   -- Si se desea utilizar un estilo en particular para un paralelo, se puede
   -- añadir el estilo en el elemento que interese de la siguiente tabla:
   paralelos = {
      {thetaD=30},
      {thetaD=60},
      {thetaD=90},
      {thetaD=120},
      {thetaD=150},
   },

   -- 4. Segmentos
   segmprops = {estilo_vis = "red, line width=0.5pt",
		 estilo_novis = "black!10, line width=0.3pt"},
   
   segmentos = {
      {theta1D=60, phi1D=-60, theta2D=60, phi2D=60, phimerD=180},
      {theta1D=60, phi1D=-60, theta2D=120, phi2D=120, phimerD=20,
      estilo_vis="purple, line width=0.8pt", estilo_novis="purple, line width=0.3pt"},
   },
}


