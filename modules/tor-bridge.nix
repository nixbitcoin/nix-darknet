{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tor-bridge;

in {
  options.services.tor-bridge = {
    enable = mkEnableOption "tor-bridge";
    port = mkOption {
      type = types.port;
      description = ''
        Tor port (ORPort) of your choice.
        This port must be externally reachable.
        Avoid port 9001 because it's commonly associated with Tor and censors
        may be scanning the Internet for this port.
      '';
    };
    obfsproxy-port = mkOption {
      type = types.port;
      description = ''
        obfs4 port of your choice.
        This port must be externally reachable and must be different from the
        one specified for ORPort.
        Avoid port 9001 because it's commonly associated with Tor and censors
        may be scanning the Internet for this port.
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [
        config.services.tor-bridge.port
        config.services.tor-bridge.obfsproxy-port
      ];
    };

    services.tor = {
      enable = true;
      settings = {
        ORPort = cfg.port;
        ServerTransportListenAddr = "obfs4 0.0.0.0:${toString cfg.obfsproxy-port}";
      };
      package = config.nix-darknet.pkgs.tor;
      relay = {
        enable = true;
        role = "bridge";
      };
    };
  };
}
