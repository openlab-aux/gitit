{
  nixpkgsSrc ? fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/1af8f3a980bb8ac92f5c09ac23cca4781571bcd1.tar.gz";
    sha256 = "1ak1kanmq1qw0r6bbk9fpz30p8dlifcc05mcyri6il7fj0cbplp1";
  }
}:

let
  nixpkgs = import nixpkgsSrc {};

  hp = nixpkgs.haskellPackages.override {
    overrides = self: super: with nixpkgs.haskell.lib; {

      hoauth2 = doJailbreak super.hoauth2;
      skylighting-core = overrideCabal super.skylighting-core (_: {
        version = "0.7.4";
        sha256 = "1awddq9cn5gyafz97ir21rncq97k2gzfxijn2xmxw35qhr2kbfl0";
      });
      skylighting = overrideCabal super.skylighting (_: {
        version = "0.7.4";
        sha256 = "0w1cv21rm4ssmr2zbn7bamlfc2pkswxg5plvqzrf7rs4h1y43672";
      });

      gitit = overrideCabal (self.callPackage ./gitit.nix {}) (old: {
        buildTools = with self; [ cabal-install ghcid ];
      });
    };
  };

in hp.gitit
