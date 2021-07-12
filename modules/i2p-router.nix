{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.i2p-router;

in {
  options.services.i2p-router = {
    enable = mkEnableOption "i2p-router";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.packageOverrides = pkgs: {
      i2pd = config.nix-darknet.pkgs.i2pd;
    };

    networking.firewall = {
      allowedTCPPorts = [
        config.services.i2pd.port
        config.services.i2pd.ntcp2.port
      ];
      allowedUDPPorts = [ config.services.i2pd.port ];
    };

    services.i2pd = {
      enable = true;
      bandwidth = 150;
      limits.transittunnels = 500;
      ntcp2 = {
        enable = true;
        published = true;
      };
      share = 80;
      proto = {
        http.enable = true;
        httpProxy = {
          enable = true;
          keys = null;
        };
        sam.enable = true;
      };
      outTunnels = {
        POP3 = {
          enable = true;
          port = 7660;
          destination = "pop.postman.i2p";
          destinationPort = 110;
        };
        SMTP = {
          enable = true;
          port = 7659;
          destination = "smtp.postman.i2p";
          destinationPort = 25;
        };
      };
    };
  };
}
