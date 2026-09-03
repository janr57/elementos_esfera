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
   local arcparprops= esc.arcparprops
   local arcparals = esc.arcparals
   local arcmaxprops = esc.arcmaxprops
   local arcosmax = esc.arcosmax
   local ptosprops = esc.ptosprops
   local puntos = esc.puntos
   local ppvptosprops = esc.ppvptosprops
   local ppvplnsprops = esc.ppvplnsprops
   local ppvvectsprops = esc.ppvvectsprops
   local ppvs = esc.ppvs
   
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
	 M.dibuja_puntos(polos_novis)
      end
      polos_novis = nil
   end

   -- Arcos de paralelos
   if arcparprops and arcparals then
      local R = esf.radio

      arcpar_vis, arcpar_novis = M.arcparals(transp,R,obs,arcparprops, arcparals)
      if transp then
	 M.dibuja_curvas(arcpar_novis)
      end
      arcpar_novis = nil  
   end

   -- Arcos máximos
   if arcmaxprops and arcosmax then
      local R = esf.radio
      
      arcmax_vis, arcmax_novis = M.arcsmaximos(transp,R,obs,arcmaxprops,arcosmax)
      if transp then
	 M.dibuja_curvas(arcmax_novis)
	 arcmax_novis = nil
      end
   end

   -- Puntos
   if ptosprops and puntos then	 
      local R = esf.radio

      ptos_vis, ptos_novis = M.puntos(transp, R, obs, ptosprops, puntos)
      if transp then
	 M.dibuja_puntos(ptos_novis)
      end
   end

   -- Puntos, planos y vectores
   if ppvptosprops and ppvplnsprops and ppvvectsprops and ppvs then
      local R = esf.radio
      local tblprops = {ppvptosprops, ppvplnsprops, ppvvectsprops}
      
      ptos_vis, plns_vis, vects_vis = M.ppvs(transp, R, obs, tblprops, ppvs)
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
      
      paral_vis = nil
   end
   
   if polprops then
      M.dibuja_puntos(polos_vis)

      polos_vis = nil
   end
   
   if arcparprops and arcparals then
      M.dibuja_curvas(arcpar_vis)

      arcpar_vis = nil
   end

   if arcmaxprops and arcosmax then
      M.dibuja_curvas(arcmax_vis)

      arcmax_vis = nil
   end

   if ptosprops and puntos then
      M.dibuja_puntos(ptos_vis)

      ptos_vis = nil
   end

   if ppvptosprops and ppvplnsprops and ppvvectsprops and ppvs then
      M.dibuja_planos(plns_vis)
      M.dibuja_vectores(vects_vis)
      M.dibuja_puntos(ptos_vis)
   end

end

-- ----------------------------------------------------------------------------
-- USO:
--      local dim = "1.2pt"
--      local valor, unidad = M.separar_dimension(dim)
--
function M.separar_dimension(dim)
   -- Busca el número (incluyendo opcionalmente signo y decimales) y la unidad
   local valor, unidad

   valor, unidad = string.match(dim, "^%s*([%-+]?%d*%.?%d+)%s*(%a*)%s*$")

   if valor then
      return tonumber(valor), unidad
   else
      return nil, "Formato no válido"
   end
end

-- ----------------------------------------------------------------------------
-- FUNCIONES AUXILIARES
-- ----------------------------------------------------------------------------
function M.dibuja_puntos(puntos)
   local color, radio, u, v
   for i, punto in ipairs(puntos) do
      color, radio, u, v = punto[1], punto[2], punto[3], punto[4]
      tex.sprint(string.format(
		    "\\fill[%s] (%f, %f) circle[radius=%s];",
		    color, u, v, radio
      ))
   end
end

function M.dibuja_planos(planos)
   local draw, fill, opac
   local u1, v1, u2, v2, u3, v3, u4, v4
   for i, plano in ipairs(planos) do
      draw = plano.draw
      fill = plano.fill
      opac = plano.opac
      u1 = plano.u1
      v1 = plano.v1
      u2 = plano.u2
      v2 = plano.v2
      u3 = plano.u3
      v3 = plano.v3
      u4 = plano.u4
      v4 = plano.v4

      tex.sprint(
	 string.format(
	    "\\filldraw[draw=%s,fill=%s,opacity=%f] (%f,%f)--(%f,%f)--(%f,%f)--(%f,%f)--cycle;",
	    draw, fill, opac, u1, v1, u2, v2, u3, v3, u4, v4
      ))
   end
end


function M.dibuja_vectores(vects)
   local color, lw, arrow
   local ou, ov, u, v
         
   for i, vector in ipairs(vects) do
      color = vector.color
      lw = vector.lw
      arrow_length = vector.arrow_length
      arrow_width = vector.arrow_width
      ou = vector.ou
      ov = vector.ov
      u = vector.u
      v = vector.v

--      tex.sprint(
--	 string.format(
--	    [[\node at (3,3.5) {(color,lw)= (%s, %s)};]], color, lw
--      ))
--      tex.sprint(
--	 string.format(
--	    [[\node at (3,3) {(length,width)= (%s, %s)};]], arrow_length,arrow_width
--      ))
--      tex.sprint(
--	 string.format(
--	    [[\node at (3,2.5) {(ou,ov)= (%.2f, %.2f)};]], ou, ov
--      ))
--      tex.sprint(
--	 string.format(
--	    [[\node at (3,2) {(u,v)= (%.2f, %.2f)};]], u, v
--      ))

      tex.sprint(
	 string.format(
	    [[\draw[%s,line width=%s,-{Latex[length=%s,width=%s]}]              (%f,%f) -- (%f,%f);]],
	    color, lw, arrow_length, arrow_width, ou, ov, u, v
      ))
   end
end

--function M.dibuja_curvas(ptos_vis)
--   local v1, v2, v3, v4, v5, v6
--   for ind, curva in ipairs(ptos_vis) do
--      for i, fila in ipairs(curva) do
--	 v1,v2,v3,v4,v5,v6 = fila[1],fila[2],fila[3],fila[4],fila[5],fila[6]
--	 tex.sprint(string.format(
--		       "\\draw[%s,line width=%s] (%f, %f) -- (%f, %f);",
--		       v1, v2, v3, v4, v5, v6
--	 ))
--      end
--   end
--end

function M.dibuja_curvas(ptos_vis)
   local color, lw, style, on, off
   local last_u, last_v
   local u, v
   
   for ind, curva in ipairs(ptos_vis) do
      for i, fila in ipairs(curva) do
	 --v1,v2,vi3,v4,v5,v6 = fila[1],fila[2],fila[3],fila[4],fila[5],fila[6]
	 color = fila.color
	 lw = fila.lw
	 style = fila.style
	 on = fila.on
	 off = fila.off
	 last_u = fila.last_u
	 last_v = fila.last_v
	 u = fila.u
	 v = fila.v

--	 if ind == 1 and i == 1 then
--	    tex.sprint(
--	       string.format(
--		  "\\node at (3,4.5) {(color,lw)= (%s,%s)};", color, lw
--	    ))
--	    tex.sprint(
--	       string.format(
--		  "\\node at (3,4) {(style,on,off)= (%s,%s,%s)};", style,on,off
--	    ))
--	    tex.sprint(
--	       string.format(
--		  "\\node at (3,3.5) {(lastu,lastv)= (%.2f, %.2f)};", last_u, last_v
--	    ))
--	    tex.sprint(
--	       string.format(
--		  "\\node at (3,3) {(u,v)= (%.2f, %.2f)};", u, v
--	    ))
--	 end
	 
	 if style == "linea" then
	    tex.sprint(string.format(
			  "\\draw[%s,line width=%s] (%f, %f) -- (%f, %f);",
			  color, lw, last_u, last_v, u, v
	    ))
	 end
      end
   end
end

--color= color_vis, lw = lw_vis,
--style = style_vis, on = on_vis, off = off_vis,
--last_u = last_u, last_v = last_v, u = u, v = v

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
      local style_vis, on_vis, off_vis
      local style_novis, on_novis, off_novis
      local ux,uy,uz,vx,vy,vz

      table.insert(ptos_vis, {})
      table.insert(ptos_novis, {})

      ph = math.rad(meridiano.phiD)
      loops = meridprops.loops
      color_vis = meridiano.color_vis or meridprops.color_vis
      lw_vis = meridiano.lw_vis or meridprops.lw_vis
      color_novis = meridiano.color_novis or meridprops.color_novis
      lw_novis = meridiano.lw_novis or meridprops.lw_novis
      style_vis = meridiano.style_vis or meridprops.style_vis
      on_vis = meridiano.on_vis or meridprops.on_vis
      off_vis = meridiano.off_vis or meridprops.off_vis
      style_novis = meridiano.style_novis or meridprops.style_novis
      on_novis = meridiano.on_novis or meridprops.on_novis
      off_novis = meridiano.off_novis or meridprops.off_novis
      
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
	       table.insert(
		  ptos_vis[index],
		  {
		     color = color_vis, lw = lw_vis,
		     style = style_vis, on = on_vis, off = off_vis,
		     last_u = last_u, last_v = last_v, u = u, v = v
		  }
	       )
	    elseif transp then
	       table.insert(
		  ptos_novis[index],
		  {
		     color = color_novis, lw = lw_novis,
		     style = style_novis, on = on_novis, off = off_novis,
		     last_u = last_u, last_v = last_v, u = u, v = v
		  }
	       )
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
      local style_vis, on_vis, off_vis
      local style_novis, on_novis, off_novis
      
      local sth = math.sin(th)
      local cth = math.cos(th)

      table.insert(ptos_vis, {})
      table.insert(ptos_novis, {})

      loops = paralprops.loops
      color_vis = paralelo.color_vis or paralprops.color_vis
      lw_vis = paralelo.lw_vis or paralprops.lw_vis
      style_vis = paralelo.style_vis or paralprops.style_vis
      on_vis = paralelo.on_vis or paralprops.on_vis
      off_vis = paralelo.off_vis or paralprops.off_vis
      color_novis = paralelo.color_novis or paralprops.color_novis
      lw_novis = paralelo.lw_novis or paralprops.lw_novis
      style_novis = paralelo.style_novis or paralprops.style_novis
      on_novis = paralelo.on_novis or paralprops.on_novis
      off_novis = paralelo.off_novis or paralprops.off_novis

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

--	 if i == 1 then
--	    tex.sprint(
--	       string.format(
--		  "\\node at (3,3) {(lastu,lastv)= (%.2f, %.2f)};", last_u, last_v
--	    ))
--	    tex.sprint(
--	       string.format(
--		  "\\node at (3,2.5) {(u,v)= (%.2f, %.2f)};", u, v
--	    ))
--	 end
	 
	 if i > 0 then
	    if vis and last_vis then
	       table.insert(
		  ptos_vis[index],
		  {
		     color = color_vis, lw = lw_vis,
		     style = style_vis, on = on_vis, off = off_vis,
		     last_u = last_u, last_v = last_v, u = u, v = v
		  }
	       )
	    elseif transp then
	       table.insert(
		  ptos_novis[index],
		  {
		     color = color_novis, lw = lw_novis,
		     style = style_novis, on = on_novis, off = off_novis,
		     last_u = last_u, last_v = last_v, u = u, v = v
		  }
	       )
	    end -- if vis and last_vis
	 end -- if i > 0
	 
	 last_u, last_v, last_vis = u, v, vis
	 
      end -- for 0, pasos
   end -- for index, paralelo

   return ptos_vis, ptos_novis
end

-- ----------------------------------------------------------------------------
function M.polos(transp, R, obs, polprops)
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
function M.puntos(transp, R, obs, ptosprops, puntos)
   local ptos_vis = {}
   local ptos_novis = {}

   for index, punto in ipairs(puntos) do
      local x, y, z
      local u, v, vis
      
      local color_vis = punto.color_vis or ptosprops.color_vis
      local radio_vis = punto.radio_vis or ptosprops.radio_vis
      local color_novis = punto.color_novis or ptosprops.color_novis
      local radio_novis = punto.radio_novis or ptosprops.radio_novis

      local th = math.rad(punto.thetaD)
      local ph = math.rad(punto.phiD)
      
      local sth = math.sin(th)
      local cth = math.cos(th)
      local sph = math.sin(ph)
      local cph = math.cos(ph)
      
      x = R * sth * cph
      y = R * sth * sph
      z = R * cth
      
      u, v, vis = M.calcular_punto_y_visibilidad(x, y, z, obs)
      if vis then
	 table.insert(ptos_vis, {color_vis, radio_vis, u, v})
      elseif transp then
	 table.insert(ptos_novis, {color_novis, radio_novis, u, v})
      end -- if vis

   end -- for index
   
   return ptos_vis, ptos_novis
end

-- ----------------------------------------------------------------------------
function M.arcparals(transp, R, obs, arcparprops, arcparals)
   local ptos_vis = {}
   local ptos_novis = {}
   
   for index, arcparal in ipairs(arcparals) do
      local th = math.rad(arcparal.thetaD)
      local loops, color_vis, lw_vis, color_novis, lw_novis
      local style_vis, on_vis, off_vis
      local style_novis, on_novis, off_novis
      local sth = math.sin(th)
      local cth = math.cos(th)

      table.insert(ptos_vis, {})
      table.insert(ptos_novis, {})

      loops = arcparprops.loops
      color_vis = arcparal.color_vis or arcparprops.color_vis
      lw_vis = arcparal.lw_vis or arcparprops.lw_vis
      style_vis = arcparal.style_vis or arcparprops.style_vis
      on_vis = arcparal.on_vis or arcparprops.on_vis
      off_vis = arcparal.off_vis or arcparprops.off_vis
      color_novis = arcparal.color_novis or arcparprops.color_novis
      lw_novis = arcparal.lw_novis or arcparprops.lw_novis
      style_novis = arcparal.style_novis or arcparprops.style_novis
      on_novis = arcparal.on_novis or arcparprops.on_novis
      off_novis = arcparal.off_novis or arcparprops.off_novis
      
      local ph1 = math.rad(arcparal.phi1D)
      local ph2 = math.rad(arcparal.phi2D)

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
	       table.insert(
		  ptos_vis[index],
		  {
		     color= color_vis, lw = lw_vis,
		     style = style_vis, on = on_vis, off = off_vis,
		     last_u = last_u, last_v = last_v, u = u, v = v
		  }
	       )
	    elseif transp then
	       table.insert(
		  ptos_novis[index],
		  {
		     color = color_novis, lw = lw_novis,
		     style =style_novis, on = on_novis, off = off_novis,
		     last_u = last_u, last_v = last_v, u = u, v = v
		  }
	       )
	    end -- if vis and last_vis
	 end -- if i > 0
	 
	 last_u, last_v, last_vis = u, v, vis
	 
      end -- for 0, pasos
   end -- for index, arcparalelo

   return ptos_vis, ptos_novis
end


-- ----------------------------------------------------------------------------
--function M.arcsmaximos(transp, R, obs, arcmaxprops, arcosmax)
--   local ptos_vis = {}
--   local ptos_novis = {}
--
--
--   for index, arcmax in ipairs(arcosmax) do
--      local th1, ph1, th2, ph2, ph
--      local sth1, cth1, sph1, cph1, sth2, cth2, sph2, sph2, cph1ph2
--      local x1, y1, z1, x2, y2, z2
--      local ux,uy,uz,vx,vy,vz
--
--      table.insert(ptos_vis, {})
--      table.insert(ptos_novis, {})
--      
--      loops = arcmaxprops.loops
--      color_vis = arcmax.color_vis or arcmaxprops.color_vis
--      lw_vis = arcmax.lw_vis or arcmaxprops.lw_vis
--      color_novis = arcmax.color_novis or arcmaxprops.color_novis
--      lw_novis = arcmax.lw_novis or arcmaxprops.lw_novis
--
--      th1 = math.rad(arcmax.theta1D)
--      ph1 = math.rad(arcmax.phi1D)
--      th2 = math.rad(arcmax.theta2D)
--      ph2 = math.rad(arcmax.phi2D)
--      ph = math.rad(arcmax.phiD)
--      
--      sth1 = math.sin(th1)
--      cth1 = math.cos(th1)
--      sph1 = math.sin(ph1)
--      cph1 = math.cos(ph1)
--      
--      sth2 = math.sin(th2)
--      cth2 = math.cos(th2)
--      sph2 = math.sin(ph2)
--      cph2 = math.cos(ph2)
--
--      cph1ph2 = math.cos(ph1-ph2)
--      
--      -- Coordenadas cartesianas de los puntos
--      x1 = R * sth1 * cph1
--      y1 = R * sth1 * sph1
--      z1 = R * cth1
--      
--      x2 = R * sth2 * cph2
--      y2 = R * sth2 * sph2
--      z2 = R * cth2
--      
--      local dot = (x1*x2 + y1*y2 + z1*z2) / (R * R)
--      if dot > 1 then dot = 1
--      elseif dot < -1 then dot = -1
--      end
--      
--      local omega = math.acos(dot)
--	 
--      local ux, uy, uz
--      if math.abs(omega - math.pi) < 1e-5 then
--	 local th_orto = th1 + math.pi/2
--	 ux = math.sin(th_orto) * math.cos(ph)
--	 uy = math.sin(th_orto) * math.sin(ph)
--	 uz = math.cos(th_orto)
--	 
--	 local dot_check = (x1*ux + y1*uy + z1*uz) / R
--	 ux = ux - dot_check * (x1/R)
--	 uy = uy - dot_check * (y1/R)
--	 uz = uz - dot_check * (z1/R)
--	 
--	 local norm_check = math.sqrt(ux*ux + uy*uy + uz*uz)
--	 ux, uy, uz = ux/norm_check, uy/norm_check, uz/norm_check
--      else
--	 local vx = x2 - dot * x1
--	 local vy = y2 - dot * y1
--	 local vz = z2 - dot * z1
--	 local norm = math.sqrt(vx*vx + vy*vy + vz*vz)
--	 ux, uy, uz = vx / norm, vy / norm, vz / norm
--      end
--
--      -- Adapta el número de puntos según la longitud de cada segmento
--      local dist
--      dist = R * math.acos(cth1 * cth2 + sth1 * sth2 * cph1ph2)
--      local pasos = math.ceil(loops * dist /(2 * math.pi * R))
--      local last_u, last_v, last_vis
--      
--      -- Muestreamos el arco en segmentos individuales para evaluar visibilidad
--      -- tramo por tramo
--      local last_u, last_v, last_vis
--
--      for i = 0, pasos do
--	 local t = i / pasos
--	 local current_angle = t * omega
--	 
--	 local cx = math.cos(current_angle)*x1 + math.sin(current_angle)*(ux*R)
--	 local cy = math.cos(current_angle)*y1 + math.sin(current_angle)*(uy*R)
--	 local cz = math.cos(current_angle)*z1 + math.sin(current_angle)*(uz*R)
--	 
--	 local u,v,vis = M.calcular_punto_y_visibilidad(cx, cy, cz, obs)
--
--	 if i > 0 then
--	    if vis and last_vis then
--	       table.insert(ptos_vis[index],
--			    {color_vis,lw_vis,last_u,last_v,u,v})
--	    elseif transp then
--	       table.insert(ptos_novis[index],
--			    {color_novis, lw_novis, last_u, last_v, u, v})
--	    end -- if vis and last_vis
--	 end -- if i > 0
--	 
--	 last_u, last_v, last_vis = u, v, vis
--	 
--      end -- for 0, pasos	 
--   end -- (for index, arcmax)
--
--      return ptos_vis, ptos_novis
--end

-- ----------------------------------------------------------------------------
-- Info:
-- Punto antipodal de (theta1, phi1) es (theta2=180-theta1, phi2=(phi1+180)/(2pi)
--
function M.arcsmaximos(transp, R, obs, arcmaxprops, arcosmax)
   local ptos_vis = {}
   local ptos_novis = {}
   
   for index, arcmax in ipairs(arcosmax) do
      local loops, dist, distmin, distmax, giro
      local style_vis, on_vis, off_vis
      local style_novis, on_novis, off_novis
      local th1D, th2D, ph1D, ph2D
      local th1, ph1, th2, ph2, th3, ph3
      local sth1, cth1, sph1, cph1, sth2, cth2, sph2, sph2, cph1ph2
      local x1, y1, z1, x2, y2, z2, x3, y3, z3
      local ux, uy, uz, vx, vy, vz, wx, wy, wz
      --local vec_u, vec_v, vec_w
      local nx, ny, nz, nmod
      local xp, yp, zp
      local delta_phi, omega, omegamin, omegamax, signo_bucle
      local u, v, vis, last_u, last_v, last_vis
      local dot, phi, cx, cy, cz
      
      table.insert(ptos_vis, {})
      table.insert(ptos_novis, {})

      loops = arcmaxprops.loops
      color_vis = arcmax.color_vis or arcmaxprops.color_vis
      lw_vis = arcmax.lw_vis or arcmaxprops.lw_vis
      style_vis = arcmax.style_vis or arcmaxprops.style_vis
      on_vis = arcmax.on_vis or arcmaxprops.on_vis
      off_vis = arcmax.off_vis or arcmaxprops.off_vis
      color_novis = arcmax.color_novis or arcmaxprops.color_novis
      lw_novis = arcmax.lw_novis or arcmaxprops.lw_novis
      style_novis = arcmax.style_novis or arcmaxprops.style_novis
      on_novis = arcmax.on_novis or arcmaxprops.on_novis
      off_novis = arcmax.off_novis or arcmaxprops.off_novis

      th1 = math.rad(arcmax.theta1D)
      ph1 = math.rad(arcmax.phi1D)
      th2 = math.rad(arcmax.theta2D)
      ph2 = math.rad(arcmax.phi2D)
      
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

      -- La distancia entre los puntos 1 y 2 se puede calcular ahora,
      -- pues en todos los casos se calcula igual:
      distmin = R * math.acos(cth1 * cth2 + sth1 * sth2 * cph1ph2)
      distmax = 2 * math.pi * R - distmin
      dist = distmin

      -- Cálculo del ángulo que forman los puntos 1 y 2
      -- para poder decidir si son puntos antipodales o no:
      -- Cálculo del punto final en el ecuador
      -- Punto inicial (theta = pi/2, phi = 0) o (x=R, y=0, z=0)
      -- delta_phi es igual a omega
      delta_phi = dist / R
      
      dot = (x1*x2 + y1*y2 + z1*z2) / (R * R)
      if dot > 1 then dot = 1
      elseif dot < -1 then dot = -1
      end -- dot
      omegamin = math.acos(dot)
      omegamax = math.abs(2*math.pi-omegamin)
      omega = omegamin

      -- Proporciona incialmente un valor imposible
      signo_bucle = 0

      if omega == 0 then
	 -- Los puntos inicial y final son el mismo: círculo máximo
	 distmin = 2 * math.pi * R
	 distmax = distmin
	 dist = distmax
	 -- No contemplo el ángulo cero, sino 2pi
	 omega = 2 * math.pi
	 delta_phi = omega

	 -- Ángulos del punto extra en radianes
	 th3 = math.rad(arcmax.punto.thetaD)
	 ph3 = math.rad(arcmax.punto.phiD)

	 -- Coordenadas cartesianas del punto extra
	 x3 = R * math.sin(th3) * math.cos(ph3)
	 y3 = R * math.sin(th3) * math.sin(ph3)
	 z3 = R * math.cos(th3)

	 signo_bucle = 1
	 vec_u, vec_v, vec_w = M.matriz_transformacion(x1,y1,z1,x3,y3,z3,R)
	 
      elseif math.abs(omega - math.pi) < 1e-5 then
	 -- Los puntos son antipodales:
	 -- En este caso hace falta algún dato más, como puede ser un punto
	 -- adicional del arco.
	 -- Utilizo la variable 'punto' (que define el punto 3) en lugar del
	 -- punto 2 para determinar la normal y su perpendicular y la distancia que
	 -- se dibuja es entre 1 y 2 (no 3, que se utiliza para poder definir el
	 -- círculo máximo). Si se añade giro = -1, se dibuja el arco opuesto.
	 giro = arcmax.giro

	 -- Esféricas del punto
	 th3 = math.rad(arcmax.punto.thetaD)
	 ph3 = math.rad(arcmax.punto.phiD)

	 -- Cartesianas del punto
	 x3 = math.sin(th3) * math.cos(ph3)
	 y3 = math.sin(th3) * math.sin(ph3)
	 z3 = math.cos(th3)
	 
	 if giro == 1 then
	    vec_u, vec_v, vec_w = M.matriz_transformacion(x1, y1, z1, x3, y3, z3, R)
	    signo_bucle = 1
	 elseif giro == -1 then
	    vec_u, vec_v, vec_w = M.matriz_transformacion(x1, y1, z1, x3, y3, z3, R)
	    signo_bucle = -1
	 end
      else
	 -- Los puntos no son antipodales: forman un arco.
	 
	 giro = arcmax.giro

	 -- Si queremos el arco mayor, hay que cambiar la distancia entre 1 y 2
	 -- en este caso (esto no ocutre cuando son antipodales)
	 if giro == "M" then
	    -- Si hemos elegido el arco de círculo máximo, la distancia es mayor
	    dist = distmax
	    omega = omegamax
	    delta_phi = omega
	    signo_bucle = -1
	    vec_u, vec_v, vec_w = M.matriz_transformacion(x2, y2, z2, x1, y1, z1, R)
	 elseif giro == "m" then
	    dist = distmin
	    omega = omegamin
	    delta_phi = omega
	    signo_bucle = 1
	    vec_u, vec_v, vec_w = M.matriz_transformacion(x1, y1, z1, x2, y2, z2, R)
	 end -- type(giro) == "string" and giro
      end -- omega
      
      ux = vec_u[1]
      uy = vec_u[2]
      uz = vec_u[3]
      
      vx = vec_v[1]
      vy = vec_v[2]
      vz = vec_v[3]
      
      wx = vec_w[1]
      wy = vec_w[2]
      wz = vec_w[3]
      
--      if delta_phi > math.pi and giro == "M" then
--	 signo_bucle = -1
--      elseif delta_phi > math.pi and giro == "m" then
--	 signo_bucle= 1
--      elseif delta_phi < math.pi and giro == "M" then
--	 signo_bucle = -1
--      elseif delta_phi < math.pi and giro == "m" then
--	 signo_bucle = 1
--      end
      
      -- Adapta el número de puntos según la longitud de cada segmento
      pasos = math.ceil(loops * dist /(2 * math.pi * R))

      theta = math.pi/2
      sth = math.sin(theta)
      cth = math.cos(theta)

      -- Muestreamos el arco en segmentos individuales para evaluar visibilidad
      -- tramo por tramo
      cz = R * cth
      
      for i = 0, pasos do

	 phi = (i * signo_bucle * omega /pasos) % (2 * math.pi)
	 
	 cx = R * sth * math.cos(phi)
	 cy = R * sth * math.sin(phi)
--	 cz = R * cth

	 -- Aplicamos la matriz de transformación
	 xp = cx*ux + cy*vx + cz*wx
	 yp = cx*uy + cy*vy + cz*wy
	 zp = cx*uz + cy*vz + cz*wz
	 
	 u, v, vis = M.calcular_punto_y_visibilidad(xp, yp, zp, obs)
	       
	 if i > 0 then
	    if vis and last_vis then
	       table.insert(
		  ptos_vis[index],
		  {
		     color = color_vis, lw = lw_vis,
		     style = style_vis, on = on_vis, off = off_vis,
		     last_u = last_u, last_v = last_v, u = u, v = v
		  }
	       )
	    elseif transp then
	       table.insert(
		  ptos_novis[index],
		  {
		     color = color_novis, lw = lw_novis,
		     style = style_vis, on = on_vis, off = off_vis,
		     last_u = last_u, last_v = last_v, u = u, v = v
		  }
	       )
	    end -- if vis and last_vis
	 end -- if i > 0
	 
	 last_u, last_v, last_vis = u, v, vis
	 
      end -- for 0, pasos	 
      
   end -- for index, arcmax

   return ptos_vis, ptos_novis
end

-- ----------------------------------------------------------------------------
-- Puntos, planos y vectores
function M.ppvs(transp, R, obs, tblprops, ppvs)
   local ptos_vis = {}
   local plns_vis = {}
   local vects_vis = {}

   -- Recuperamos las tablas de propiedades
   local ptosprops = tblprops[1]
   local plnsprops = tblprops[2]
   local vectsprops = tblprops[3]

   for index, ppv in ipairs(ppvs) do
      local x, y, z
      local u, v, vis
      local punto = ppv.punto
      local plano = ppv.plano
      local vects = ppv.vects
      
--      if index == 1 then
--	 tex.sprint("\\node at (3,5) {index 1};")
--      elseif index == 2 then
--	 tex.sprint("\\node at (3,4.5) {index 2};")
      --      end
      
      -- PUNTO
      -- Propiedades tomadas de los datos
      local th = math.rad(punto.thetaD)
      local ph = math.rad(punto.phiD)
      local pto_dibuja = punto.dibuja or ptosprops.dibuja
      local pto_color = punto.color or ptosprops.color
      local pto_radio = punto.radio or ptosprops.radio

      -- Cálculos previos para no repetirlos varias veces cuando se necesiten
      local sth = math.sin(th)
      local cth = math.cos(th)
      local sph = math.sin(ph)
      local cph = math.cos(ph)

      -- El punto se situa en la coordenada r = R, theta = 90, phi = 0
      -- Coordenadas cartesianas del punto en la posición ecuatorial
      local ptox, ptoy, ptoz
      pto_x = 2
      pto_y = 0
      pto_z = 0
      -- Ángulo de giro para llevarlo a (R, th, phi)
      -- Girar punto (R,th,ph) un ángulo (theta, girophi)
      local giro_theta, giro_phi
      giro_theta = th - math.pi/2
      giro_phi = ph - 0
      -- Nuevas coordenadas cartesianas del punto en la posición final
      x, y, z = M.giro_theta_phi(pto_x, pto_y, pto_z, giro_theta, giro_phi)
      -- Cálculo de las coordenadas visuales y su visibilidad en la esfera
      u, v, vis = M.calcular_punto_y_visibilidad(x, y, z, obs)
      if pto_dibuja and vis then
	 table.insert(ptos_vis, {pto_color, pto_radio, u, v})
      end
      -- Guarda las coordenadas en patalla del punto para los vectores
      local pto_u = u
      local pto_v = v

      -- PLANO
      -- Características tomadas de los datos
      local pln_draw = plano.draw or plnsprops.draw
      local pln_fill = plano.fill or plnsprops.fill
      local pln_opac = plano.opac or plnsprops.opac
      local pln_ancho = plano.ancho
      local pln_alto = plano.alto
      local pln_giro = math.rad(plano.giro_planoD or plnsprops.giro_planoD)
      local pln_dibuja = plano.dibuja or plnsprops.dibuja

--      tex.sprint(
--	 string.format(
--	    "\\node at (3,-2) {plnopac= %.2f};", pln_opac
--      ))
      -- Punto 1 del plano
      -- Coordenadas cartesianas respecto de la posición en el ecuador
      -- del primer punto del plano
      local p1x = pto_x
      local p1y = pto_y - pln_ancho/2
      local p1z = pto_z - pln_alto/2
      -- Giramos el plano el ángulo indicado en giro
      p1y = p1y * math.cos(pln_giro) - p1z * math.sin(pln_giro)
      p1z = p1y * math.sin(pln_giro) + p1z * math.cos(pln_giro)
      -- Nuevas coordenadas cartesianas del punto del plano en la posición final
      local x1, y1, z1
      x1, y1, z1 = M.giro_theta_phi(p1x, p1y, p1z, giro_theta, giro_phi)
      -- Cálculo de las coordenadas visuales y su visibilidad en la esfera
      local u1, v1, vis1
      u1, v1, vis1 = M.calcular_punto_y_visibilidad(x1, y1, z1, obs)
      -- Punto 2 del plano
      -- Coordenadas cartesianas respecto de la posición en el ecuador
      -- del segundo punto del plano
      local p2x = pto_x
      local p2y = pto_y + pln_ancho/2
      local p2z = pto_z - pln_alto/2
      -- Giramos el plano el ángulo indicado en giro
      p2y = p2y * math.cos(pln_giro) - p2z * math.sin(pln_giro)
      p2z = p2y * math.sin(pln_giro) + p2z * math.cos(pln_giro)
      -- Nuevas coordenadas cartesianas del punto del plano en la posición final
      local x2, y2, z2
      x2, y2, z2 = M.giro_theta_phi(p2x, p2y, p2z, giro_theta, giro_phi)
      -- Cálculo de las coordenadas visuales y su visibilidad en la esfera
      local u2, v2, vis2
      u2, v2, vis2 = M.calcular_punto_y_visibilidad(x2, y2, z2, obs)
      -- Punto 3 del plano
      -- Coordenadas cartesianas respecto de la posición del punto en el ecuador
      -- del tercer punto del plano
      local p3x = pto_x
      local p3y = pto_y + pln_ancho/2
      local p3z = pto_z + pln_alto/2
      -- Giramos el plano el ángulo indicado en giro
      p3y = p3y * math.cos(pln_giro) - p3z * math.sin(pln_giro)
      p3z = p3y * math.sin(pln_giro) + p3z * math.cos(pln_giro)
      -- Nuevas coordenadas cartesianas del punto del plano en la posición final
      local x3, y3, z3
      x3, y3, z3 = M.giro_theta_phi(p3x, p3y, p3z, giro_theta, giro_phi)
      -- Cálculo de las coordenadas visuales y su visibilidad en la esfera
      local u3, v3, vis3
      u3, v3, vis3 = M.calcular_punto_y_visibilidad(x3, y3, z3, obs)
      -- Punto 4 del plano
      -- Coordenadas cartesianas respecto de la posición del punto en el ecuador
      local p4x = pto_x
      local p4y = pto_y - pln_ancho/2
      local p4z = pto_z + pln_alto/2
      -- Giramos el plano el ángulo indicado en giro
      p4y = p4y * math.cos(pln_giro) - p4z * math.sin(pln_giro)
      p4z = p4y * math.sin(pln_giro) + p4z * math.cos(pln_giro)
      -- Nuevas coordenadas cartesianas del punto del plano en la posición final
      local x4, y4, z4
      x4, y4, z4 = M.giro_theta_phi(p4x, p4y, p4z, giro_theta, giro_phi)
      -- Cálculo de las coordenadas visuales y su visibilidad en la esfera
      local u4, v4, vis4
      u4, v4, vis4 = M.calcular_punto_y_visibilidad(x4, y4, z4, obs)
      if pln_dibuja and pto_dibuja then
	 table.insert(plns_vis,
		      {
			 draw= pln_draw, fill= pln_fill, opac= pln_opac,
			 u1=u1, v1=v1, u2=u2, v2=v2, u3=u3, v3=v3, u4=u4, v4=v4,
		      }
	 )
	 
      end

      -- VECTORES
      -- En cada entrada de punto hay un plano, pero puede haber muchos vectores
--      table.insert(vects_vis, {})

--      tex.sprint("\\node at (3,5) {Llega aquí};")
--      tex.sprint(
--	 string.format(
--	    [[\node at (3,4.5) {vectslen= %.2f};]], #vects
--      ))
      
      for indvect, vect in ipairs(vects) do
	 local vect_color = vect.color or vectsprops.color
	 local vect_lw = vect.lw or vectsprops.lw
	 local vect_arrow_length = vect.arrow_length or vectsprops.arrow_length
	 local vect_arrow_width = vect.arrow_width or vectsprops.arrow_width
	 local vect_dibuja = vect.dibuja or vectsprops.dibuja
	 local vect_mod = vect.mod
	 local vect_ang = math.rad(vect.angD)
	 
--	 tex.sprint(
--	    string.format(
--	       [[\node at (3,4) {(vectcolor,vectdibuja)= (%s, %s)};]],
--	       vect_color, vect_dibuja
--	 ))
--	 if indvect == 1 then
--	    tex.sprint(
--	       string.format(
--		  [[\node at (3,3.5) {(mod,ang)= (%.2f, %.2f)};]],
--		  vect_mod, vect_ang
--	    ))
--	 elseif indvect == 2 then
--	    tex.sprint(
--	       string.format(
--		  [[\node at (3,3) {(mod,ang)= (%.2f, %.2f)};]],
--		  vect_mod, vect_ang
--	    ))
--	 end

	 -- Coordenadas del extremo del vector
	 local vx, vy, vz
	 vx = pto_x
	 vy = pto_y + vect_mod * math.cos(vect_ang)
	 vz = pto_z + vect_mod * math.sin(vect_ang)

	 -- Giramos el vector de acuerdo con el ángulo de giro para el plano
	 vy = vy * math.cos(pln_giro) - vz * math.sin(pln_giro)
	 vz = vy * math.sin(pln_giro) + vz * math.cos(pln_giro)
	 
--	 tex.sprint(
--	    string.format(
--	       [[\node at (3,4) {(vx,vy,vz)= (%.2f, %.2f, %.2f)};]],
--	       vx, vy, vz
--	 ))

      -- Nuevas coordenadas cartesianas del vector en la posición final
      --local x3, y3, z3
      vx, vy, vz = M.giro_theta_phi(vx, vy, vz, giro_theta, giro_phi)

--      tex.sprint(
--	 string.format(
--	    [[\node at (3,3.5) {(vx,vy,vz)= (%.2f, %.2f, %.2f)};]],
--	    vx, vy, vz
--      ))
      
--      local vu, vv, vvis
      u, v, vis = M.calcular_punto_y_visibilidad(vx, vy, vz, obs)

--      tex.sprint(
--	 string.format(
--	    [[\node at (3,3) {(u,v,vis)= (%.2f, %.2f, %s)};]],
--	    u, v, vis
--      ))

      if vect_dibuja and pto_dibuja then
	 table.insert(vects_vis,
		      {
			 color= vect_color, lw= vect_lw,
			 arrow_length= vect_arrow_length,
			 arrow_width = vect_arrow_width,
			 ou= pto_u, ov = pto_v,
			 u= u, v= v,
		      }
	 )
	 
      end
      
      
      end
      
   end

--   tex.sprint(
--      string.format(
--	 "\\node at (3,4) {ptosvislen= %.2f};", #ptos_vis
--   ))
--   tex.sprint(
--      string.format(
--	 "\\node at (3,3.5) {plnsvislen= %.2f};", #plns_vis
--   ))
   
   return ptos_vis, plns_vis, vects_vis
end

-- ----------------------------------------------------------------------------

--x, y, z = M.giro_theta_phi(x, y, z, girotheta, girophi)
function M.giro_theta_phi(x, y, z, th, ph)
   local xprima, yprima, zprima
   local sth = math.sin(th)
   local cth = math.cos(th)
   local sph = math.sin(ph)
   local cph = math.cos(ph)
   
   xprima = x * cth * cph - y * sph + z * sth * cph
   yprima = x * cth * sph + y * cph + z * sth * sph
   zprima = -x * sth + z * cth

   return xprima, yprima, zprima
end

--
function M.matriz_transformacion(x1, y1, z1, x2, y2, z2, R)
   local vec_u, vec_v, vec_w
   local nx, ny, nz, nmod
   local ux, uy, uz
   local vx, vy, vz
   local wx, wy, wz

   ux = x1 / R
   uy = y1 / R
   uz = z1 / R
   
   nx = y1*z2 - y2*z1
   ny = x2*z1 - x1*z2
   nz = x1*y2 - x2*y1
   nmod = math.sqrt(nx^2 + ny^2 + nz^2)

   wx = nx / nmod
   wy = ny / nmod
   wz = nz / nmod
   
   vx = wy*uz - uy*wz
   vy = ux*wz - wx*uz
   vz = wx*uy - ux*wy
   
   vec_u = {ux, uy, uz}
   vec_v = {vx, vy, vz}
   vec_w = {wx, wy, wz}
   
   return vec_u, vec_v, vec_w
end


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
-- Función para registrar mensajes
function M.log(tipo, mensaje)
    -- Abrir archivo en modo "append" (anexar)
    local archivo = io.open("ejecucion.log", "a")
    if not archivo then return end

    -- Obtener fecha y hora actual
    local fecha = os.date("%Y-%m-%d %H:%M:%S")

    -- Escribir la línea de log
    archivo:write(string.format("[%s] [%s] %s\n", fecha, tipo, mensaje))

    -- Cerrar el archivo
    archivo:close()
end

-- M.log("INFO", "Fin de puntos.")

-- ----------------------------------------------------------------------------



return M

