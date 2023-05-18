let
  pkgs = import ./nixpkgs.nix {};

in pkgs.haskellPackages.shellFor {
  packages = _hps: [
    (import ./. {})
  ];
  nativeBuildInputs = [
    pkgs.cabal-install
    pkgs.haskell-language-server
  ];
}
