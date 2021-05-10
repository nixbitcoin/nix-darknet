{ config, lib, pkgs, ... }:

let
  cfg = config.services;
  ndLib = config.nix-darknet.lib;

in {
  config =  {

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        22
      ];
    };

    services.tor.hiddenServices.sshd = ndLib.mkHiddenService { port = 22; };
  };
}
