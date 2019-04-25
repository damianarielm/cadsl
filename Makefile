all:
	happy Parser.y
	ghc Main.hs -O2
