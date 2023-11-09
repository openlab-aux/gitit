all:
	cabal v2-configure -fplugins --prefix=/usr/local
	cabal v2-build

install:
	cabal v2-copy

setup-runtime-dependencies:
	extract-gitit-runtime-dependencies-to $(CURDIR)

.PHONY: all clean install
