# Makefile para: elementos_esfera.tex
#
# Copyright (C) 2022--2026 José A. Navarro Ramón <janr.devel@gmail.com>
# Licencia del código GPLv2
# Licencia Creative Commons Recognition Non-Commercial Share-alike.
# (CC-BY-NC-SA)

FILES =	elementos_esfera.pkg.sty\
	elementos_esfera.defs.sty\
	texto/esferas.tex\
	texto/meridianos.tex\
	texto/paralelos.tex\
	texto/sgmparalelos.tex\
	texto/arcosmax.tex\
	texto/prueba.tex\
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
	datoslua/esf_sgmpar_01.lua\
	datoslua/esf_sgmpar_02.lua\
	datoslua/esf_arcosmax_01.lua\
	datoslua/esf_prueba.lua\
	datoslua/esf_merpar_01.lua

elementos_esfera.pdf: elementos_esfera.tex $(FILES)

%.pdf:	%.tex
	lualatex --enable-write18 $<
	lualatex --enable-write18 $<

all: elementos_esfera.pdf

.PHONY: clean

clean:
	rm -rf *.pdf *.ps *.dvi *.aux *.log *.toc *.out dat*~ *.dat *.script
	rm -rf auto
	rm -rf texto/*.aux texto/*~


