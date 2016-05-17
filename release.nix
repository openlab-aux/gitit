let
  np = import <nixpkgs> {};

  hp = np.haskellPackages.override {
    overrides = (self: super: {
      openlabGitit = np.haskell.lib.overrideCabal super.gitit (drv: {
        src = np.fetchFromGitHub {
          owner = "openlab-aux";
          repo = "gitit";
          rev = "e6e69d5c1a16e196416ce096ce3e006dabd6647b";
          sha256 = "0jgkw4i21fgq2fh54y3lv0kx0q7cw6rvbwvyzapngv2brf5s45k8";
        };
      });
    });
  };
in
{
  openlabGitit = hp.openlabGitit;

  deb = with np;
    releaseTools.debBuild (hp.openlabGitit.drvAttrs // {
      diskImage = vmTools.diskImageFuns.debian7x86_64 {
        packagesList = fetchurl {
          url = http://ftp.de.debian.org/debian/dists/wheezy/main/binary-amd64/Packages.bz2;
          sha256 = "1kir3j6y81s914njvs0sbwywq7qv28f8s615r9agg9s0h5g760fw";
        };
      };
      memSize = 16384;
      QEMU_OPTS = "-smp 12";
      configureFlags = [ "--prefix=/usr" ];
      installCommand = "./Setup install";
    });

  test = with np;
    releaseTools.debBuild (hello.drvAttrs // {
      diskImage = vmTools.diskImageFuns.debian7x86_64 {
        packagesList = fetchurl {
          url = http://ftp.de.debian.org/debian/dists/wheezy/main/binary-amd64/Packages.bz2;
          sha256 = "1kir3j6y81s914njvs0sbwywq7qv28f8s615r9agg9s0h5g760fw";
        };
      };
      memSize = 16384;
      QEMU_OPTS = "-smp 12";
    });
}
