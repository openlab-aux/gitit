let pkgs =  import <nixpkgs> {};
    drv = (pkgs.haskellPackages.callPackage ./gitit.nix {}).drvAttrs;
  in pkgs.stdenv.mkDerivation (drv //
    {
      prePatch = "patchShebangs fetchDependencies.sh";
      configurePhase = "export CURL_CA_BUNDLE=/tmp/ca-cert.crt;" + (drv.configurePhase or "");
      nativeBuildInputs = (drv.nativeBuildInputs or []) ++ (with pkgs; [ curl unzip ]);
    })
