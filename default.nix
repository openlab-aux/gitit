with import <nixpkgs> {};
let
  hp = haskellPackages.override {
    overrides = self: super: {
      gitit = haskell.lib.overrideCabal (self.callPackage ./gitit.nix {}) (old: {
        buildTools = with self; [ cabal-install ghcid ];
      });
    };
  };

in hp.gitit
