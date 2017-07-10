all:
	gf -make LogicSpa.gf LogicSym.gf
	ghc --make -o trans Trans.hs
