{ pkgs ? import <nixpkgs> {} }:
let self = {
  krops = import ./krops { };
  XD = pkgs.callPackage ./XD { };

  pinned = import ./pinned.nix;

  modulesPkgs = self // self.pinned;
}; in self
