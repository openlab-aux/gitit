{
  nixpkgsSrc ? fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/1ffba9f2f683063c2b14c9f4d12c55ad5f4ed887.tar.gz";
    sha256 = "1zx5zvpvqrgk5mfxzmwf8gd270lz7dkfk563sccp1xlhac15cipg";
  }
}:

let
  nixpkgs = import nixpkgsSrc {};

  mathJax = nixpkgs.fetchurl {
    url = "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/MathJax.js?config=TeX-AMS_CHTML-full";
    sha256 = "0xhzriwlwkpg254m7pwzq8aqcfi55bavr0zi6m289gqan60yg1y9";
    name = "MathJax.js";
  };

  mathJaxZoom = nixpkgs.fetchurl {
    url = "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/extensions/MathZoom.js";
    sha256 = "14a4xyapyhnaagl9b0pz7k2s25h4ds3bc43kzm2p3myf56jfgp4j";
    name = "MathZoom.js";
  };

  mathJaxMenu = nixpkgs.fetchurl {
    url = "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/extensions/MathMenu.js";
    sha256 = "13bkjhmi3sv4lda1rjjlb96ybfpcxj9k3qn4ic53d34lb2fjw3hx";
    name = "MathMenu.js";
  };

  fontAwesome = nixpkgs.fetchzip {
    url = "https://github.com/FortAwesome/Font-Awesome/releases/download/5.13.0/fontawesome-free-5.13.0-web.zip";
    sha256 = "0hh631i8vy8b61h9drb9r2iacqn4cslwih768m706yinsp7bbbc0";
    name = "font-awesome";
  };

  simpleMDE = nixpkgs.fetchzip {
    url = "https://github.com/sparksuite/simplemde-markdown-editor/archive/1.11.2.tar.gz";
    sha256 = "0pzbyg7vl7bk7wlwgcmch9zxw04f4hakysza9xq0iyrnal22ra9i";
    name = "simplemde";
  };

  inherit (nixpkgs.haskell.lib.compose)
    overrideCabal
    justStaticExecutables
    ;

  makeGitit = haskellPackages:
    let
      newHaskellPackages = haskellPackages.override {
        overrides = self: super: {
          gitit = nixpkgs.lib.pipe super.gitit [
            (overrideCabal (old: {
              # get version number from the cabal file
              version =
                let
                  lines = builtins.filter builtins.isString
                    (builtins.split "\n" (builtins.readFile ./gitit.cabal));
                  versionMatches = nixpkgs.lib.concatLists (
                    builtins.filter (x: x != null) (
                      builtins.map (
                        builtins.match "version:[ ]+([0-9.]+)"
                      ) lines
                    )
                  );
                in assert builtins.length versionMatches == 1;
                  builtins.head versionMatches;
              # remove patches from nixpkgs
              patches = [];
              # enable RTS opts and run idle GC only every 10min
              configureFlags = [
                "--ghc-option=-rtsopts"
                "--ghc-option=-with-rtsopts=-I600"
              ] ++ (old.configureFlags or []);
              # provide web assets
              postPatch = ''
                rm -rf ./data/static/{font-awesome,js/mathjax}
                mkdir -p ./data/static/js/mathjax/extensions
                cp ${mathJax} ./data/static/js/mathjax/MathJax.js
                cp ${mathJaxMenu} ./data/static/js/mathjax/extensions/MathMenu.js
                cp ${mathJaxZoom} ./data/static/js/mathjax/extensions/MathZoom.js
                cp -R ${fontAwesome} data/static/font-awesome
                cp ${simpleMDE}/dist/simplemde.min.js ./data/static/js/
                cp ${simpleMDE}/dist/simplemde.min.css ./data/static/css/
              '';
              src = nixpkgs.nix-gitignore.gitignoreSource [
                ".git/"
                "release.nix"
                "default.nix"
                "shell.nix"
              ] ./.;
              passthru = old.passthru or {} // {
                haskellPackages = self;
              };
            }))
            justStaticExecutables
          ];
        };
      };
    in newHaskellPackages.gitit;

in

{
  dynamic = makeGitit nixpkgs.haskellPackages;
}
