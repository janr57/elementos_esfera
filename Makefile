# Makefile para: elementos_esfera.tex
#
# Copyright (C) 2022--2026 José A. Navarro Ramón <janr.devel@gmail.com>
# Licencia del código GPLv2
# Licencia Creative Commons Recognition Non-Commercial Share-alike.
# (CC-BY-NC-SA)

IMGSTATICDIR=img/static

FILES =	elementos_esfera.pkg.sty\
	elementos_esfera.defs.sty\
	portada/portada.tex\
	tablacontenidos/tablacontenidos.tex\
	texto/esferas.tex\
	texto/meridianos.tex\
	texto/paralelos.tex\
	texto/arcosparalelos.tex\
	texto/arcosmax.tex\
	texto/puntos.tex\
	texto/extra.tex\
	lua/funciones_esfera.lua\
	datoslua/esf_bas_01.lua\
	datoslua/esf_bas_02.lua\
	datoslua/esf_bas_03.lua\
	datoslua/esf_merid_01.lua\
	datoslua/esf_merid_02.lua\
	datoslua/esf_meridres_01.lua\
	datoslua/esf_meridres_02.lua\
	datoslua/esf_paral_01.lua\
	datoslua/esf_paral_02.lua\
	datoslua/esf_arcosparal_01.lua\
	datoslua/esf_arcosparal_02.lua\
	datoslua/esf_arcosmax_01.lua\
	datoslua/esf_arcosmax_02.lua\
	datoslua/esf_arcosmax_03.lua\
	datoslua/esf_arcosmax_04.lua\
	datoslua/esf_arcosmax_05.lua\
	datoslua/esf_arcosmax_06.lua\
	datoslua/esf_arcosmax_07.lua\
	datoslua/esf_arcosmax_08.lua\
	datoslua/esf_arcosmax_09.lua\
	datoslua/esf_arcosmax_10.lua\
	datoslua/esf_puntos_01.lua\
	datoslua/esf_merpar_01.lua\
	$(IMGSTATICDIR)/Cc-by-nc-sa_icon.pdf

elementos_esfera.pdf: elementos_esfera.tex $(FILES)

$(IMGSTATICDIR)/%.pdf: $(IMGSTATICDIR)/%.svg
	inkscape $< -o $@ --export-ignore-filters --export-ps-level=3

%.pdf:	%.tex
	lualatex --enable-write18 $<
	lualatex --enable-write18 $<

all: elementos_esfera.pdf

.PHONY: clean

clean:
	rm -rf *.pdf *.ps *.dvi *.aux *.log *.toc *.out dat*~ *.dat *.script
	rm -rf auto
	rm -rf portada/*.aux portada/*~
	rm -rf tablacontenidos/*.aux tablacontenidos/*~
	rm -rf texto/*.aux texto/*~


