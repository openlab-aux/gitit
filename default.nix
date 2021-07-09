{
  nixpkgsSrc ? fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/87807e64a5ef5206b745a40af118c7be8db73681.tar.gz";
    sha256 = "056jv0m6x3q95ndj8mrwsy90s4imv34dl1lri9qyjrvl8r33kzzy";
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

  hp = nixpkgs.haskellPackages.override {
    overrides = self: super: with nixpkgs.haskell.lib; {
      gitit =
        overrideCabal super.gitit (old: {
          # remove patches from nixpkgs
          patches = [];
          # enable RTS opts so we can disable idle GC
          configureFlags = [
            "--ghc-option=-rtsopts"
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
          src = nixpkgs.nix-gitignore.gitignoreSource [ ".git/" "default.nix" "release.nix" "shell.nix" ] ./.;
        });
    };
  };

in hp.gitit
