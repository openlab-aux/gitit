let

  openlabGitit = import ./. { nixpkgsSrc = <nixpkgsSrc>; };

  # channel =
  #   let mkChannel = (import <vuizvui> {}).pkgs.vuizvui.mkChannel;
  #   in mkChannel {
  #     name = "gitit-channel";
  #     src = ./.;
  #     constituents = [ openlabGitit ];
  #   };

in
  { inherit openlabGitit /*channel*/; }
