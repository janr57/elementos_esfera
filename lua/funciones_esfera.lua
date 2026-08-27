-- funciones_esferas.lua
--
-- Copyright (C) 2022--2026 José A. Navarro Ramón <janr.devel@gmail.com>
-- Licencia del código GPLv2
-- Licencia Creative Commons Recognition Non-Commercial Share-alike.
-- (CC-BY-NC-SA)

local M = {}

-- ----------------------------------------------------------------------------
-- FUNCIONES BÁSICAS
-- ----------------------------------------------------------------------------
function M.dibuja_tikzesfera(transp, esc)
   local esf = esc.esfera
   local smbresf = esc.smbresfera
   local obs = esc.observador
   local meridprops = esc.meridprops
   local meridianos = esc.meridianos
   local paralprops = esc.paralprops
   local paralelos = esc.paralelos
   local polprops = esc.polprops
   local sgmparprops= esc.sgmparprops
   local sgmparals = esc.sgmparals
   local arcmaxprops = esc.arcmaxprops
   local arcosmax = esc.arcosmax
   local arcmaxprops2 = esc.arcmaxprops2
   local arcosmax2 = esc.arcosmax2
--   local ptos = esc.puntos
--   local planos = esc.planos

   -- DIBUJO DE ESFERA
   if esf and not smbresf then
      M.dibuja_esfera(esf)
   end
   
   if esf and smbresf then
      local R = esf.radio
      M.dibuja_esfera(esf)
      M.dibuja_smbresfera(R, smbresf)
   end

   -- OBSERVADOR
   if obs then
      -- Se completa la tabla 'obs':
      obs.th = math.rad(obs.thetaD)
      obs.ph = math.rad(obs.phiD)
      obs.sth = math.sin(obs.th)
      obs.cth = math.cos(obs.th)
      obs.sph = math.sin(obs.ph)
      obs.cph = math.cos(obs.ph)
   end

   -- -------------------------------------------------------------------------
   -- FASE 1: Creación de tablas, dibujando elementos no visibles
   -- Meridianos
   if meridprops and meridianos then
      local R = esf.radio      
      merid_vis, merid_novis = M.meridianos(transp, R, obs, meridprops, meridianos)
      -- Dibuja los puntos invisibles si ha lugar:
      if transp then
	 M.dibuja_curvas(merid_novis)
      end
      merid_novis = nil
   end

   -- Polos
   if polprops and polos then
      local R = esf.radio
      pol_vis, pol_novis = M.polos(trandp, R, obs, polprops)
   end
   
   -- Paralelos
   if paralprops and paralelos then
      local R = esf.radio
      paral_vis, paral_novis = M.paralelos(transp, R, obs, paralprops, paralelos)
      -- Dibuja los puntos invisibles si ha lugar:
      if transp then
	 M.dibuja_curvas(paral_novis)
      end
      paral_novis = nil
   end

   -- Polos
   if polprops then
      local R = esf.radio
      polos_vis, polos_novis = M.polos(transp, R, obs, polprops)
      if transp then
	 M.dibuja_polos(polos_novis)
      end
      polos_novis = nil
   end

   -- Segmentos de paralelos
   if sgmparprops and sgmparals then
      local R = esf.radio

      sgmpar_vis, sgmpar_novis = M.sgmparals(transp, R, obs, sgmparprops, sgmparals)
      if transp then
	 M.dibuja_curvas(sgmpar_novis)
      end
      sgmpar_novis = nil  
   end
   
   -- Arcos máximos
   if arcmaxprops and arcosmax then
      local R = esf.radio
      
      arcmax_vis, arcmax_novis = M.arcsmaximos(transp, R, obs, arcmaxprops, arcosmax)
      if transp then
	 M.dibuja_curvas(arcmax_novis)
      end
      arcmax_novis = nil
   end

   -- Arcos máximos 2
   if arcmaxprops2 and arcosmax2 then
      
      local R = esf.radio
      
      arcmax2_vis, arcmax2_novis = M.arcsmaximos2(transp,R,obs,arcmaxprops2,arcosmax2)
      if transp then
	 M.dibuja_curvas(arcmax2_novis)
	 arcmax2_novis = nil
      end

   end

   -- -------------------------------------------------------------------------
   -- FASE 2: Dibujando elementos visibles
   -- Dibujo de todos los puntos visibles
   if meridprops and meridianos then
      M.dibuja_curvas(merid_vis)
      merid_vis = nil
   end
   if paralprops and paralelos then
      M.dibuja_curvas(paral_vis)
      
      merid_vis = nil
   end
   if polprops then
      M.dibuja_polos(polos_vis)

      polos_vis = nil
   end
   if sgmparprops and sgmparals then
      M.dibuja_curvas(sgmpar_vis)

      sgmpar_vis = nil
   end
   if arcmaxprops and arcosmax then
      M.dibuja_curvas(arcmax_vis)

      arcmax_vis = nil
   end

   if arcmaxprops2 and arcosmax2 then
      M.dibuja_curvas(arcmax2_vis)

      arcmax2_vis = nil
   end

   
end

-- ----------------------------------------------------------------------------



-- ----------------------------------------------------------------------------
-- FUNCIONES AUXILIARES
-- ----------------------------------------------------------------------------
function M.dibuja_polos(polos)
   local color, radio, u, v
   for i, polo in ipairs(polos) do
      color, radio, u, v = polo[1], polo[2], polo[3], polo[4]
      tex.sprint(string.format(
		    "\\fill[%s] (%f, %f) circle[radius=%s];",
		    color, u, v, radio
      ))
   end
end


function M.dibuja_curvas(ptos_vis)
   local v1, v2, v3, v4, v5, v6
   for ind, curva in ipairs(ptos_vis) do
      for i, fila in ipairs(curva) do
	 v1,v2,v3,v4,v5,v6 = fila[1],fila[2],fila[3],fila[4],fila[5],fila[6]
	 tex.sprint(string.format(
		       "\\draw[%s,line width=%s] (%f, %f) -- (%f, %f);",
		       v1, v2, v3, v4, v5, v6
	 ))
      end
   end
end

function M.dibuja_esfera(esf)
   local R = esf.radio
   local draw = esf.draw
   local lw = esf.lw
   local fill = esf.fill
   local opac = esf.opac

   if draw ~= "--" and fill ~= "--" then
      tex.sprint(
	 string.format(
	    [[\filldraw[draw=%s,line width=%s,fill=%s,opacity=%f] (0,0) circle  [radius=%f];]],
	    draw, lw, fill, opac, R
      ))
   elseif fill == "--" then
      tex.sprint(
	 string.format(
	    [[\draw[%s,line width=%s,opacity=%f] (0,0) circle [radius=%f];]],
	    draw, lw, opac, R
      ))
   elseif draw == "--" then
      tex.sprint(
	 string.format(
	    [[\fill[%s,opacity=%f] (0,0) circle  [radius=%f];]],
	    fill, opac, R
      ))
   end
end

-- ----------------------------------------------------------------------------
function M.dibuja_smbresfera(R, smbresf)
   local ballcolor = smbresf.ballcolor
   local opac = smbresf.opac

      tex.sprint(string.format(
	   "\\shade[ball color=%s,opacity=%f] (0,0) circle [radius=%f];",
	    ballcolor, opac, R
      ))
end

-- ----------------------------------------------------------------------------
function M.meridianos(transp, R, obs, meridprops, meridianos)
   local ptos_vis = {}
   local ptos_novis = {}
   
   -- Como son meridianos:
   -- "Polo Norte"
   local th1 = math.rad(0)
   local ph1 = math.rad(0)
   -- "Polo Sur"
   local th2 = math.rad(180)
   local ph2 = math.rad(0)

   -- Seno y coseno de los ángulos
   local sth1 = math.sin(th1)
   local cth1 = math.cos(th1)
   local sph1 = math.sin(ph1)
   local cph1 = math.cos(ph1)
   
   local sth2 = math.sin(th2)
   local cth2 = math.cos(th2)
   local sph2 = math.sin(ph2)
   local cph2 = math.cos(ph2)

   -- Coordenadas cartesianas de los puntos
   local x1 = R * sth1 * cph1
   local y1 = R * sth1 * sph1
   local z1 = R * cth1
   
   local x2 = R * sth2 * cph2
   local y2 = R * sth2 * sph2
   local z2 = R * cth2

   local dot = (x1*x2 + y1*y2 + z1*z2) / (R * R)
   if dot > 1 then dot = 1
   elseif dot < -1 then dot = -1
   end
   
   -- Ángulo central que forman los dos puntos con el centro de la esfera
   local omega = math.acos(dot)
   
   for index, meridiano in ipairs(meridianos) do
      local ph
      local loops, color_vis, lw_vis, color_novis, lw_novis
      local ux,uy,uz,vx,vy,vz

      table.insert(ptos_vis, {})
      table.insert(ptos_novis, {})

      ph = math.rad(meridiano.phiD)
      loops = meridprops.loops
      color_vis = meridiano.color_vis or meridprops.color_vis
      lw_vis = meridiano.lw_vis or meridprops.lw_vis
      color_novis = meridiano.color_novis or meridprops.color_novis
      lw_novis = meridiano.lw_novis or meridprops.lw_novis
      
      local ux, uy, uz
      if math.abs(omega - math.pi) < 1e-5 then
	 local th_orto = th1 + math.pi/2
	 ux = math.sin(th_orto) * math.cos(ph)
	 uy = math.sin(th_orto) * math.sin(ph)
	 uz = math.cos(th_orto)
	 
	 local dot_check = (x1*ux + y1*uy + z1*uz) / R
	 ux = ux - dot_check * (x1/R)
	 uy = uy - dot_check * (y1/R)
	 uz = uz - dot_check * (z1/R)
	 
	 local norm_check = math.sqrt(ux*ux + uy*uy + uz*uz)
	 ux, uy, uz = ux/norm_check, uy/norm_check, uz/norm_check
      else
	 local vx = x2 - dot * x1
	 local vy = y2 - dot * y1
	 local vz = z2 - dot * z1
	 local norm = math.sqrt(vx*vx + vy*vy + vz*vz)
	 ux, uy, uz = vx / norm, vy / norm, vz / norm
      end

      -- Muestreamos el arco en segmentos individuales para evaluar visibilidad
      -- tramo por tramo
      local pasos = loops
      local last_u, last_v, last_vis

      for i = 0, pasos do
	 local t = i / pasos
	 local current_angle = t * omega
	 
	 local cx = math.cos(current_angle)*x1 + math.sin(current_angle)*(ux*R)
	 local cy = math.cos(current_angle)*y1 + math.sin(current_angle)*(uy*R)
	 local cz = math.cos(current_angle)*z1 + math.sin(current_angle)*(uz*R)
	 
	 local u, v, vis = M.calcular_punto_y_visibilidad(cx, cy, cz, obs)

	 -- Solo será visible el segmento si AMBOS extremos del tramo son visibles
	 if i > 0 then
	    if vis and last_vis then
	       table.insert(ptos_vis[index], {color_vis,lw_vis,last_u,last_v,u,v})
	    elseif transp then
	       table.insert(ptos_novis[index],
			    {color_novis, lw_novis, last_u, last_v, u, v})
	    end
	 end
	 last_u, last_v, last_vis = u, v, vis
      end -- (for i = 0, pasos)
   end -- (for index, meridiano)

   return ptos_vis, ptos_novis
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

-- ----------------------------------------------------------------------------
function M.paralelos(transp, R, obs, paralprops, paralelos)
   local ptos_vis = {}
   local ptos_novis = {}

   for index, paralelo in ipairs(paralelos) do
      local th = math.rad(paralelo.thetaD)
      local loops, color_vis, lw_vis, color_novis, lw_novis
      local sth = math.sin(th)
      local cth = math.cos(th)

      table.insert(ptos_vis, {})
      table.insert(ptos_novis, {})

      loops = paralprops.loops
      color_vis = paralelo.color_vis or paralprops.color_vis
      lw_vis = paralelo.lw_vis or paralprops.lw_vis
      color_novis = paralelo.color_novis or paralprops.color_novis
      lw_novis = paralelo.lw_novis or paralprops.lw_novis

      -- Adapta el número de puntos según la longitud de cada paralelo
      local pasos = math.ceil(loops * math.sin(th))
      local last_u, last_v, last_vis

      for i = 0, pasos do
	 -- Variamos ph de 0 a 360 grados
	 local ph = i * 2 * math.pi/pasos
	 
	 -- Coordenadas 3D del punto paralelo
	 local x = R * sth * math.cos(ph)
	 local y = R * sth * math.sin(ph)
	 local z = R * cth
	 
	 local u, v, vis = M.calcular_punto_y_visibilidad(x, y, z, obs)

	 if i > 0 then
	    if vis and last_vis then
	       table.insert(ptos_vis[index], {color_vis,lw_vis,last_u,last_v,u,v})
	    elseif transp then
	       table.insert(ptos_novis[index],
			    {color_novis, lw_novis, last_u, last_v, u, v})
	    end -- if vis and last_vis
	 end -- if i > 0
	 
	 last_u, last_v, last_vis = u, v, vis
	 
      end -- for 0, pasos
   end -- for index, paralelo

   return ptos_vis, ptos_novis
end

-- ----------------------------------------------------------------------------
function M.polos(trandp, R, obs, polprops)
   local polos_vis = {}
   local polos_novis = {}

   local color_vis = polprops.color_vis
   local radio_vis = polprops.radio_vis
   local color_novis = polprops.color_novis
   local radio_novis = polprops.radio_novis
   
   local x = 0
   local y = 0
   local z

   local u
   local v
   local vis

   -- Polo norte
   x = 0
   y = 0
   z = R
   u, v, vis = M.calcular_punto_y_visibilidad(x, y, z, obs)

   if vis then
      table.insert(polos_vis, {color_vis, radio_vis, u, v})
   elseif transp then
      table.insert(polos_novis,
		   {color_novis, radio_novis, u, v})
   end -- if vis

   -- Polo sur
   x = 0
   y = 0
   z = -R
   u, v, vis = M.calcular_punto_y_visibilidad(x, y, z, obs)
   
   if vis then
      table.insert(polos_vis, {color_vis, radio_vis, u, v})
   elseif true then
      table.insert(polos_novis, {color_novis, radio_novis, u, v})
   end -- if vis

   return polos_vis, polos_novis
end

-- ----------------------------------------------------------------------------
function M.sgmparals(transp, R, obs, sgmparprops, sgmparals)
   local ptos_vis = {}
   local ptos_novis = {}
   
   for index, sgmparal in ipairs(sgmparals) do
      local th = math.rad(sgmparal.thetaD)
      local loops, color_vis, lw_vis, color_novis, lw_novis
      local sth = math.sin(th)
      local cth = math.cos(th)

      table.insert(ptos_vis, {})
      table.insert(ptos_novis, {})

      loops = sgmparprops.loops
      color_vis = sgmparal.color_vis or sgmparprops.color_vis
      lw_vis = sgmparal.lw_vis or sgmparprops.lw_vis
      color_novis = sgmparal.color_novis or sgmparprops.color_novis
      lw_novis = sgmparal.lw_novis or sgmparprops.lw_novis
      local ph1 = math.rad(sgmparal.phi1D)
      local ph2 = math.rad(sgmparal.phi2D)

      -- Adapta el número de puntos según la longitud de cada segmento
      local pasos = math.ceil(math.abs(ph2-ph1) * loops * math.sin(th)/(2*math.pi))
      local last_u, last_v, last_vis
      
      for i = 0, pasos do
	 -- Variamos ph de ph1 a ph2 radianes
	 local ph = ph1 + i * (ph2-ph1)/pasos
	 
	 
	 -- Coordenadas 3D del punto paralelo
	 local x = R * sth * math.cos(ph)
	 local y = R * sth * math.sin(ph)
	 local z = R * cth
	 
	 local u, v, vis = M.calcular_punto_y_visibilidad(x, y, z, obs)

	 if i > 0 then
	    if vis and last_vis then
	       table.insert(ptos_vis[index],
			    {color_vis,lw_vis,last_u,last_v,u,v})
	    elseif transp then
	       table.insert(ptos_novis[index],
			    {color_novis, lw_novis, last_u, last_v, u, v})
	    end -- if vis and last_vis
	 end -- if i > 0
	 
	 last_u, last_v, last_vis = u, v, vis
	 
      end -- for 0, pasos
   end -- for index, sgmparalelo

   return ptos_vis, ptos_novis
end


-- ----------------------------------------------------------------------------
function M.arcsmaximos(transp, R, obs, arcmaxprops, arcosmax)
   local ptos_vis = {}
   local ptos_novis = {}


   for index, arcmax in ipairs(arcosmax) do
      local th1, ph1, th2, ph2, ph
      local sth1, cth1, sph1, cph1, sth2, cth2, sph2, sph2, cph1ph2
      local x1, y1, z1, x2, y2, z2
      local ux,uy,uz,vx,vy,vz

      table.insert(ptos_vis, {})
      table.insert(ptos_novis, {})
      
      loops = arcmaxprops.loops
      color_vis = arcmax.color_vis or arcmaxprops.color_vis
      lw_vis = arcmax.lw_vis or arcmaxprops.lw_vis
      color_novis = arcmax.color_novis or arcmaxprops.color_novis
      lw_novis = arcmax.lw_novis or arcmaxprops.lw_novis

      th1 = math.rad(arcmax.theta1D)
      ph1 = math.rad(arcmax.phi1D)
      th2 = math.rad(arcmax.theta2D)
      ph2 = math.rad(arcmax.phi2D)
      ph = math.rad(arcmax.phiD)
      
      sth1 = math.sin(th1)
      cth1 = math.cos(th1)
      sph1 = math.sin(ph1)
      cph1 = math.cos(ph1)
      
      sth2 = math.sin(th2)
      cth2 = math.cos(th2)
      sph2 = math.sin(ph2)
      cph2 = math.cos(ph2)

      cph1ph2 = math.cos(ph1-ph2)
      
      -- Coordenadas cartesianas de los puntos
      x1 = R * sth1 * cph1
      y1 = R * sth1 * sph1
      z1 = R * cth1
      
      x2 = R * sth2 * cph2
      y2 = R * sth2 * sph2
      z2 = R * cth2
      
      local dot = (x1*x2 + y1*y2 + z1*z2) / (R * R)
      if dot > 1 then dot = 1
      elseif dot < -1 then dot = -1
      end
      
      local omega = math.acos(dot)
	 
      local ux, uy, uz
      if math.abs(omega - math.pi) < 1e-5 then
	 local th_orto = th1 + math.pi/2
	 ux = math.sin(th_orto) * math.cos(ph)
	 uy = math.sin(th_orto) * math.sin(ph)
	 uz = math.cos(th_orto)
	 
	 local dot_check = (x1*ux + y1*uy + z1*uz) / R
	 ux = ux - dot_check * (x1/R)
	 uy = uy - dot_check * (y1/R)
	 uz = uz - dot_check * (z1/R)
	 
	 local norm_check = math.sqrt(ux*ux + uy*uy + uz*uz)
	 ux, uy, uz = ux/norm_check, uy/norm_check, uz/norm_check
      else
	 local vx = x2 - dot * x1
	 local vy = y2 - dot * y1
	 local vz = z2 - dot * z1
	 local norm = math.sqrt(vx*vx + vy*vy + vz*vz)
	 ux, uy, uz = vx / norm, vy / norm, vz / norm
      end

      -- Adapta el número de puntos según la longitud de cada segmento
      local dist
      dist = R * math.acos(cth1 * cth2 + sth1 * sth2 * cph1ph2)
      local pasos = math.ceil(loops * dist /(2 * math.pi * R))
      local last_u, last_v, last_vis
      
      -- Muestreamos el arco en segmentos individuales para evaluar visibilidad
      -- tramo por tramo
      local last_u, last_v, last_vis

      for i = 0, pasos do
	 local t = i / pasos
	 local current_angle = t * omega
	 
	 local cx = math.cos(current_angle)*x1 + math.sin(current_angle)*(ux*R)
	 local cy = math.cos(current_angle)*y1 + math.sin(current_angle)*(uy*R)
	 local cz = math.cos(current_angle)*z1 + math.sin(current_angle)*(uz*R)
	 
	 local u,v,vis = M.calcular_punto_y_visibilidad(cx, cy, cz, obs)

	 if i > 0 then
	    if vis and last_vis then
	       table.insert(ptos_vis[index],
			    {color_vis,lw_vis,last_u,last_v,u,v})
	    elseif transp then
	       table.insert(ptos_novis[index],
			    {color_novis, lw_novis, last_u, last_v, u, v})
	    end -- if vis and last_vis
	 end -- if i > 0
	 
	 last_u, last_v, last_vis = u, v, vis
	 
      end -- for 0, pasos	 
   end -- (for index, arcmax)

      return ptos_vis, ptos_novis
end

-- ----------------------------------------------------------------------------
function M.arcsmaximos2(transp, R, obs, arcmaxprops2, arcosmax2)
   local ptos_vis = {}
   local ptos_novis = {}
   
   for index, arcmax2 in ipairs(arcosmax2) do
      local loops, dist, giro
      local th1D, th2D, ph1D, ph2D
      local th1, ph1, th2, ph2, ph
      local sth1, cth1, sph1, cph1, sth2, cth2, sph2, sph2, cph1ph2
      local x1, y1, z1, x2, y2, z2
      local ux, uy, uz, vx, vy, vz, wx, wy, wz, nx, ny, nz, nmod
      local delta_phi, n
      local last_u, last_v, last_vis
      
      table.insert(ptos_vis, {})
      table.insert(ptos_novis, {})

      loops = arcmaxprops2.loops
      color_vis = arcmax2.color_vis or arcmaxprops2.color_vis
      lw_vis = arcmax2.lw_vis or arcmaxprops2.lw_vis
      color_novis = arcmax2.color_novis or arcmaxprops2.color_novis
      lw_novis = arcmax2.lw_novis or arcmaxprops2.lw_novis

      th1 = math.rad(arcmax2.theta1D)
      ph1 = math.rad(arcmax2.phi1D)
      th2 = math.rad(arcmax2.theta2D)
      ph2 = math.rad(arcmax2.phi2D)
      giro = arcmax2.giro
      
      sth1 = math.sin(th1)
      cth1 = math.cos(th1)
      sph1 = math.sin(ph1)
      cph1 = math.cos(ph1)
      
      sth2 = math.sin(th2)
      cth2 = math.cos(th2)
      sph2 = math.sin(ph2)
      cph2 = math.cos(ph2)

      cph1ph2 = math.cos(ph1-ph2)
      
      -- Coordenadas cartesianas de los puntos
      x1 = R * sth1 * cph1
      y1 = R * sth1 * sph1
      z1 = R * cth1
      
      x2 = R * sth2 * cph2
      y2 = R * sth2 * sph2
      z2 = R * cth2

--      th1D = arcmax2.theta1D
--      ph1D = arcmax2.phi1D
--      th2D = arcmax2.theta2D
--      ph2D = arcmax2.phi2D

      -- El vector unitario de 1 se define en todos los casos:
      ux = x1 / R
      uy = y1 / R
      uz = z1 / R
      u = {ux, uy, uz}

      -- La distancia entre los puntos 1 y 2 se puede calcular ahora,
      -- pues en todos los casos se calcula igual:
      dist = R * math.acos(cth1 * cth2 + sth1 * sth2 * cph1ph2)

      -- Cálculo del ángulo que forman los puntos 1 y 2
      -- para poder decidir si son puntos antipodales o no:
      local dot = (x1*x2 + y1*y2 + z1*z2) / (R * R)
      if dot > 1 then dot = 1
      elseif dot < -1 then dot = -1
      end
      local omega = math.acos(dot)
      
      if math.abs(omega - math.pi) < 1e-5 then
	 -- Los puntos son antipodales:
	 -- En este caso hace falta algún dato más, como puede ser un punto
	 -- adicional del arco.
	 -- Utilizo la variable 'punto' (que define el punto 3) en lugar del
	 -- punto 2 para determinar la normal y su perpendicular y la distancia
	 -- entre 1 y 2 (no 3, que se utiliza para poder definir el círculo máximo).
	 -- Esféricas del punto
	 local th3 = math.rad(arcmax2.punto.thetaD)
	 local ph3 = math.rad(arcmax2.punto.phiD)

	 -- Cartesianas del punto
	 local x3 = math.sin(th3) * math.cos(ph3)
	 local y3 = math.sin(th3) * math.sin(ph3)
	 local z3 = math.cos(ph3)

--	 tex.sprint(
--	    string.format(
--	       "\\node at (3.5,4) {(th3,ph3)= (%.2f, %.2f)};", th3, ph3
--	 ))
	 
	 nx =y1*z3-y3*z1
	 ny = x3*z1-x1*z3
	 nz = x1*y3-x3*y1

      else
	 -- Los puntos no son antipodales: forman un arco.
	 
	 -- Si queremos el arco mayor, hay que cambiar la distancia entre 1 y 2
	 -- en este caso (esto no ocutre cuando son antipodales)
	 if type(giro) == "string" and giro == "M" then
	    -- Si hemos elegido el arco de círculo máximo, la distancia es mayor
	    dist = 2 * math.pi * R - dist
	 end
	 
	 -- Matriz de transformación del paralelo a arco de círculo máximo
	 local u, v, w
	 
	 nx = y1*z2-y2*z1
	 ny = x2*z1-x1*z2
	 nz = x1*y2-x2*y1
	 
      end

      nmod = math.sqrt(nx^2 + ny^2 + nz^2)
      
      wx = nx / nmod
      wy = ny / nmod
      wz = nz / nmod
      w = {wx, wy, wz}
      
      vx = wy*uz-uy*wz
      vy = ux*wz-wx*uz
      vz = wx*uy-ux*wy
      v = {vx, vy, vz}
      
      -- Cálculo del punto final en el ecuador
      -- Punto inicial (theta = pi/2, phi = 0) o (x=R, y=0, z=0)
      delta_phi = dist / R
      
      if delta_phi > math.pi and type(giro)=="string" and giro=="M" then
	 n = 1
      elseif delta_phi > math.pi and type(giro)=="string" and giro=="m" then
	 n = -1
      elseif delta_phi < math.pi and type(giro)=="string" and giro=="M" then
	 n = -1
      elseif delta_phi < math.pi and type(giro)=="string" and giro=="m" then
	 n = 1
      elseif type(giro) == "number" and giro == 1 then
	 n = 1
      elseif type(giro) == "number" and giro == -1 then
	 n = -1
      end
      
      
--      tex.sprint(
--	 string.format(
--	    "\\node at (3.5,4.5) {loops= %.2f, dist= %.2f, giro= %s};",
--	    loops, dist, giro
--      ))
            
      -- Adapta el número de puntos según la longitud de cada segmento
      pasos = math.ceil(loops * dist /(2 * math.pi * R))

--      tex.sprint(
--	 string.format(
--	    "\\node at (3.5,4) {pasos=%.2f};", pasos
--      ))
      
      -- Coordenadas de puntos en el ecuador: (theta=90, phi=0-360)
      -- theta no varía
      local theta = math.pi/2
      local sth = math.sin(theta)
      local cth = math.cos(theta)
      local phi      

      -- Muestreamos el arco en segmentos individuales para evaluar visibilidad
      -- tramo por tramo      
      for i = 0, pasos do
	 
	 phi = i * n * delta_phi /pasos
	 
	 local cx = R * sth * math.cos(phi)
	 local cy = R * sth * math.sin(phi)
	 local cz = R * cth
	 
	 -- Aplicamos la matriz de transformación
	 xp = cx*ux+cy*vx+cz*wx
	 yp = cx*uy+cy*vy+cz*wy
	 zp = cx*uz+cy*vz+cz*wz
	 
	 local u, v, vis = M.calcular_punto_y_visibilidad(xp, yp, zp, obs)
	       
	 if i > 0 then
	    if vis and last_vis then
	       table.insert(ptos_vis[index],
			    {color_vis,lw_vis,last_u,last_v,u,v})
	    elseif transp then
	       table.insert(ptos_novis[index],
			    {color_novis, lw_novis, last_u, last_v, u, v})
	    end -- if vis and last_vis
	 end -- if i > 0
	 
	 last_u, last_v, last_vis = u, v, vis
	 
      end -- for 0, pasos	 
      
   end -- for index, arcmax2

   return ptos_vis, ptos_novis
end

-- ----------------------------------------------------------------------------
---- Función auxiliar para proyectar 3D a 2D y calcular la visibilidad del punto
function M.calcular_punto_y_visibilidad(x, y, z, obs)
   local th_obs = obs.th
   local ph_obs = obs.ph
   local sth = obs.sth
   local cth = obs.cth
   local sph = obs.sph
   local cph = obs.cph

   -- 1. Dirección del observador (eje z de la pantalla)
   local z_hat_x = sth * cph
   local z_hat_y = sth * sph
   local z_hat_z = cth

   -- 2. Dirección de la pantalla 2D (u, v)
    local u_hat_x, u_hat_y, u_hat_z = -sph, cph, 0
    local v_hat_x = -cth * cph
    local v_hat_y = -cth * sph
    local v_hat_z = sth

    -- 3. Productos escalares
    local u = x * u_hat_x + y * u_hat_y + z * u_hat_z
    local v = x * v_hat_x + y * v_hat_y + z * v_hat_z
    local visible = (x * z_hat_x + y * z_hat_y + z * z_hat_z) > -1e-5
    -- -1e-5 es la tolerancia matemática

--    -- 1. Dirección del observador (Eje Z de la pantalla)
--    local z_hat_x = math.sin(th_obs) * math.cos(ph_obs)
--    local z_hat_y = math.sin(th_obs) * math.sin(ph_obs)
--    local z_hat_z = math.cos(th_obs)
--
--    -- 2. Ejes de la pantalla 2D (u, v)
--    local u_hat_x, u_hat_y, u_hat_z = -math.sin(ph_obs), math.cos(ph_obs), 0
--    local v_hat_x = -math.cos(th_obs) * math.cos(ph_obs)
--    local v_hat_y = -math.cos(th_obs) * math.sin(ph_obs)
--    local v_hat_z = math.sin(th_obs)
--
--    -- 3. Productos escalares
--    local u = x * u_hat_x + y * u_hat_y + z * u_hat_z
--    local v = x * v_hat_x + y * v_hat_y + z * v_hat_z
--    local visible = (x * z_hat_x + y * z_hat_y + z * z_hat_z) > -1e-5 -- Tolerancia matemática
    
    return u, v, visible
end
-- ----------------------------------------------------------------------------



return M

