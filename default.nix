let nixpkgs =  import <nixpkgs> {};
in nixpkgs.haskellPackages.callPackage ./gitit.nix {}
