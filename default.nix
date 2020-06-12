{
  nixpkgsSrc ? fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/91340aeea87aa25f8265b0a69af88d7d36fcf04f.tar.gz";
    sha256 = "0npma33j6a7cx6gmi4x8acxlffp482dfv2l4acrmpadv2v7nayzi";
  }
}:

let
  nixpkgs = import nixpkgsSrc {};

  hp = nixpkgs.haskellPackages.override {
    overrides = self: super: with nixpkgs.haskell.lib; {


      gitit = super.gitit.overrideAttrs (old: {
        src = nixpkgs.nix-gitignore.gitignoreSource [ ".git/" ] ./.;
      });
    };
  };

#      hoauth2 = doJailbreak super.hoauth2;
#      skylighting-core = overrideCabal super.skylighting-core (_: {
#        version = "0.7.4";
#        sha256 = "1awddq9cn5gyafz97ir21rncq97k2gzfxijn2xmxw35qhr2kbfl0";
#      });
#      skylighting = overrideCabal super.skylighting (_: {
#        version = "0.7.4";
#        sha256 = "0w1cv21rm4ssmr2zbn7bamlfc2pkswxg5plvqzrf7rs4h1y43672";
#      });

in hp.gitit
