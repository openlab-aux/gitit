{
  pkgs ? import ./nixpkgs.nix {}
}:
let
  lib = pkgs.lib;

  mathJax = pkgs.fetchurl {
    url = "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/MathJax.js?config=TeX-AMS_CHTML-full";
    sha256 = "0xhzriwlwkpg254m7pwzq8aqcfi55bavr0zi6m289gqan60yg1y9";
    name = "MathJax.js";
  };

  mathJaxZoom = pkgs.fetchurl {
    url = "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/extensions/MathZoom.js";
    sha256 = "14a4xyapyhnaagl9b0pz7k2s25h4ds3bc43kzm2p3myf56jfgp4j";
    name = "MathZoom.js";
  };

  mathJaxMenu = pkgs.fetchurl {
    url = "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/extensions/MathMenu.js";
    sha256 = "13bkjhmi3sv4lda1rjjlb96ybfpcxj9k3qn4ic53d34lb2fjw3hx";
    name = "MathMenu.js";
  };

  fontAwesome = pkgs.fetchzip {
    url = "https://github.com/FortAwesome/Font-Awesome/releases/download/5.13.0/fontawesome-free-5.13.0-web.zip";
    sha256 = "0hh631i8vy8b61h9drb9r2iacqn4cslwih768m706yinsp7bbbc0";
    name = "font-awesome";
  };

  simpleMDE = pkgs.fetchzip {
    url = "https://github.com/sparksuite/simplemde-markdown-editor/archive/1.11.2.tar.gz";
    sha256 = "0pzbyg7vl7bk7wlwgcmch9zxw04f4hakysza9xq0iyrnal22ra9i";
    name = "simplemde";
  };

  extractRuntimeDependenciesTo = pkgs.writers.writeBashBin "extract-gitit-runtime-dependencies-to" ''
    set -euo pipefail
    set -x
    TARGET_DIR=''${1:?Please pass target dir as first argument}
    echo "Extracting runtime dependencies to the subdirectories of $TARGET_DIR" >&2
    cd $TARGET_DIR
    rm -rf ./data/static/{font-awesome,js/mathjax}
    mkdir -p ./data/static/js/mathjax/extensions
    cp ${mathJax} ./data/static/js/mathjax/MathJax.js
    cp ${mathJaxMenu} ./data/static/js/mathjax/extensions/MathMenu.js
    cp ${mathJaxZoom} ./data/static/js/mathjax/extensions/MathZoom.js
    cp -R ${fontAwesome} data/static/font-awesome
    cp ${simpleMDE}/dist/simplemde.min.js ./data/static/js/
    cp ${simpleMDE}/dist/simplemde.min.css ./data/static/css/
  '';

  hp = pkgs.haskellPackages.override {
    overrides = self: super: with pkgs.haskell.lib.compose; {

      gitit = lib.pipe super.gitit [
        # We don’t need plugin support, this removes the runtime dependency on `GHC.Paths`!
        (disableCabalFlag "plugins")
        (overrideCabal (old: {
          # get version number from the cabal file
          version =
            let
              lines = builtins.filter builtins.isString
                (builtins.split "\n" (builtins.readFile ./gitit.cabal));
              versionMatches = pkgs.lib.concatLists (
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
            ${extractRuntimeDependenciesTo}/bin/extract-gitit-runtime-dependencies-to .
          '';
          src = pkgs.nix-gitignore.gitignoreSource [ ".git/" "default.nix" "release.nix" "shell.nix" ] ./.;
          postInstall = old.postInstall or "" + ''
            remove-references-to \
              -t ${self.pandoc-types} \
              $out/bin/gitit
            remove-references-to \
              -t ${self.HTTP} \
              $out/bin/gitit
            remove-references-to \
              -t ${self.pandoc} \
              $out/bin/gitit
            remove-references-to \
              -t ${self.happstack-server} \
              $out/bin/gitit
            remove-references-to \
              -t ${self.filestore} \
              $out/bin/gitit
          '';
          passthru = {
            inherit extractRuntimeDependenciesTo;
          };
        }))
      ];
    };
  };

in pkgs.haskell.lib.justStaticExecutables hp.gitit
# in hp.gitit
