{ mkDerivation, aeson, base, base64-bytestring, blaze-html
, bytestring, ConfigFile, containers, directory, feed, filepath
, filestore, ghc, ghc-paths, happstack-server, hoauth2, hslogger
, HStringTemplate, HTTP, http-client-tls, http-conduit, json, mtl
, network, network-uri, old-locale, old-time, pandoc, pandoc-types
, parsec, pretty, process, random, recaptcha, safe, SHA
, skylighting, split, stdenv, syb, tagsoup, text, time, uri
, uri-bytestring, url, utf8-string, uuid, xhtml, xml, xml-conduit
, xss-sanitize, zlib
}:
mkDerivation {
  pname = "gitit";
  version = "0.12.3";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson base base64-bytestring blaze-html bytestring ConfigFile
    containers directory feed filepath filestore ghc ghc-paths
    happstack-server hoauth2 hslogger HStringTemplate HTTP
    http-client-tls http-conduit json mtl network network-uri
    old-locale old-time pandoc pandoc-types parsec pretty process
    random recaptcha safe SHA skylighting split syb tagsoup text time
    uri uri-bytestring url utf8-string uuid xhtml xml xml-conduit
    xss-sanitize zlib
  ];
  executableHaskellDepends = [
    base bytestring directory filepath hslogger HTTP mtl network
    network-uri syb text url utf8-string
  ];
  homepage = "http://gitit.net";
  description = "Wiki using happstack, git or darcs, and pandoc";
  license = "GPL";
}
