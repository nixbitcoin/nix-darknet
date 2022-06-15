{ pkgs ? import <nixpkgs> {} }:

let
  src = pkgs.fetchgit {
    url = "https://cgit.krebsco.de/krops";
    rev = "89e5e67659bbbf0da53cc2cc5dea644b9a2301f6";
    sha256 = "0gxx412wqwi65djyp6x8bpkkmi79v3jqcjvk1y1c8qrfpqizyx90";
  };
in {
  lib = import "${src}/lib";
  pkgs = import "${src}/pkgs" {};
}
