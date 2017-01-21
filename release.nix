let
  np = import <nixpkgs> {};

  hp = np.haskellPackages.override {
    overrides = with np.haskell.lib; (self: super: {
      openlabGitit = overrideCabal super.gitit (drv: {
        src = ./.;
      });
    });
  };

  openlabGitit = hp.openlabGitit;


  channel =
    let mkChannel = (import <vuizvui> {}).pkgs.vuizvui.mkChannel;
    in mkChannel {
      name = "gitit-channel";
      src = ./.;
      constituents = [ openlabGitit ];
    };

in
  { inherit openlabGitit deb debTar channel; }
