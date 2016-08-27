with import <nixpkgs> {};
# { haskell, haskellPackages, fetchFromGitHub, makeWrapper }:

let
  mde = fetchFromGitHub {
    owner = "NextStepWebs";
    repo = "simplemde-markdown-editor";
    rev = "1.11.2";
    sha256 = "0pzbyg7vl7bk7wlwgcmch9zxw04f4hakysza9xq0iyrnal22ra9i";
  };

  deps = "${mde}/dist;

  hp = haskellPackages.override {
    overrides = with haskell.lib; (self: super: {
      openlabGitit = overrideCabal super.gitit (drv: {
        src = ./.;
        buildDepends = drv.buildDepends or [] ++ [ makeWrapper ];
        postInstall = drv.postInstall or "" + ''
          wrapProgram $out/bin/gitit --set gitit_deps ${deps}
        '';
      });
    });
  };

in
  hp.openlabGitit
