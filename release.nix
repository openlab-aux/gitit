let
  np = import <nixpkgs> {};

  hp = np.haskellPackages.override {
    overrides = with np.haskell.lib; (self: super: {
      openlabGitit = disableSharedExecutables (overrideCabal super.gitit (drv: {
        src = np.fetchFromGitHub {
          owner = "openlab-aux";
          repo = "gitit";
          rev = "f787065a5462f1f3f9e906f2665dec8c3da56468";
          sha256 = "1fd04iq24rzhpjmyfgr9xygwp75id329pscgv30zxvqkyw0j2r9y";
        };
      }));
    });
  };

  openlabGitit = hp.openlabGitit;

  # deb = with np;
  #   releaseTools.debBuild (hp.openlabGitit.drvAttrs // {
  #     diskImage = vmTools.diskImageFuns.debian7x86_64 {
  #       packagesList = fetchurl {
  #         url = http://ftp.de.debian.org/debian/dists/wheezy/main/binary-amd64/Packages.bz2;
  #         sha256 = "1kir3j6y81s914njvs0sbwywq7qv28f8s615r9agg9s0h5g760fw";
  #       };
  #     };
  #     memSize = 16384;
  #     QEMU_OPTS = "-smp 12";
  #     configureFlags = [ "--prefix=/usr" ];
  #     installCommand = "./Setup install";
  #   });

  deb =
    let debian_sonames = [
      { from = "liblua.so.5.1";
        to   = "liblua5.1.so.0.0.0"; }
      { from = "libpcre.so.1";
        to   = "libpcre.so.3"; }
    ];
        replace = e: ''--replace-needed "${e.from}" "${e.to}"'';
        patchelf = file: arg: ''patchelf ${arg} ${file}'';
    in np.runCommand "gitit-debian" { src = hp.openlabGitit; } ''
      mkdir $out
      cp -r "$src"/* "$out"
      chmod -R +w "$out/bin"
      ${np.lib.concatMapStringsSep "\n" (patchelf "$out/bin/gitit") ([
        ''--set-interpreter "/lib64/ld-linux-x86-64.so.2"''
        ''--set-rpath ""''
      ] ++ map replace debian_sonames)}
  '';

  debTar = np.runCommand "gitit-debian-tar" { src = deb; } ''
    mkdir $out && cd $src
    tar czf $out/gitit.tar.gz *
  '';

in
  { inherit openlabGitit deb debTar; }
