{ config, pkgs, lib, ... }:

with lib;
{
  imports = [
    <nixpkgs-unstable/nixos/modules/services/networking/i2pd.nix>

    ./i2p-router.nix
    ./tor-bridge.nix
    ./irc-bouncer.nix

    ./networking.nix
    ./forward.nix
  ];

  disabledModules = [ "services/networking/i2pd.nix" ];

  options = {
    nix-darknet = {
      pkgs = mkOption {
        type = types.attrs;
        default = (import ../pkgs { inherit pkgs; }).modulesPkgs;
      };

      lib = mkOption {
        readOnly = true;
        default = import ../pkgs/lib.nix lib pkgs;
      };
    };
  };
}
