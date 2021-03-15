let
  # This is either a path to a local nix-darknet source or an attribute set to
  # be used as the fetchurl argument.
  nix-darknet-release = import ./nix-darknet-release.nix;

  nix-darknet-path =
    if builtins.isAttrs nix-darknet-release then nix-darknet-unpacked
    else nix-darknet-release;

  nixpkgs-path = (import "${toString nix-darknet-path}/pkgs/nixpkgs-pinned.nix").nixpkgs;
  nixpkgs = import nixpkgs-path {};
  nix-darknet = nixpkgs.callPackage nix-darknet-path {};

  nix-darknet-unpacked = (import <nixpkgs> {}).runCommand "nix-darknet-src" {} ''
    mkdir $out; tar xf ${builtins.fetchurl nix-darknet-release} -C $out
  '';
in
with nixpkgs;

stdenv.mkDerivation rec {
  name = "nix-darknet-environment";

  path = lib.makeBinPath [ figlet znc ];

  shellHook = ''
    export NIX_PATH="nixpkgs=${nixpkgs-path}:nix-darknet=${toString nix-darknet-path}:."
    export PATH="${path}''${PATH:+:}$PATH"

    alias fetch-release="${toString nix-darknet-path}/helper/fetch-release"

    krops-deploy() {
      # Ensure strict permissions on secrets/ directory before rsyncing it to
      # the target machine
      chmod 700 ${toString ./secrets}
      $(nix-build --no-out-link ${toString ./krops/deploy.nix})
    }

    figlet "nix-darknet"

    # Don't run this hook when another nix-shell is run inside this shell
    unset shellHook
  '';
}
