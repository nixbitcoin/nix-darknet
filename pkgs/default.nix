{ pkgs ? import <nixpkgs> {} }:
let self = {
  krops = import ./krops { };

  pinned = import ./pinned.nix;

  modulesPkgs = self // self.pinned;
}; in self
