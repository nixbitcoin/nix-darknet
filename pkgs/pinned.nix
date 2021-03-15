let
  nixpkgsPinned = import ./nixpkgs-pinned.nix;
  nixpkgsStable = import nixpkgsPinned.nixpkgs { config = {}; overlays = []; };
  nixpkgsUnstable = import nixpkgsPinned.nixpkgs-unstable { config = {}; overlays = []; };
  nixDarknetPkgsStable = import ./. { pkgs = nixpkgsStable; };
  nixDarknetPkgsUnstable = import ./. { pkgs = nixpkgsUnstable; };
in
{
  inherit (nixpkgsUnstable)
    tor
    i2pd;

  stable = nixDarknetPkgsStable;
  unstable = nixDarknetPkgsUnstable;
}
