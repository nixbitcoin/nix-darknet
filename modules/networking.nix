{ config, lib, pkgs, ... }:

let
  cfg = config.services;
  nbLib = config.nix-darknet.lib;

in {
  config =  {

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        22
      ];
    };

    services.tor.hiddenServices.sshd = nbLib.mkHiddenService { port = 22; };
  };
}
