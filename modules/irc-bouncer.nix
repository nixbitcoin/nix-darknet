{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.irc-bouncer;

in {
  options.services.irc-bouncer = {
    enable = mkEnableOption "irc-bouncer";
    username = mkOption {
      type = types.str;
      description = "Username for ZNC.";
    };
    password-hash = mkOption {
      type = types.str;
      description = "Password Hash from `znc --makepass`";
    };
    password-salt = mkOption {
      type = types.str;
      description = "Password Salt from `znc --makepass`";
    };
    irc2p = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable irc2p IRC over i2p";
    };
    anarplex = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable Agora IRC over i2p";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {

      services.znc = {
        enable = true;
        useLegacyConfig = false;
        openFirewall = true;
        dataDir = "/var/lib/znc";
        mutable = false;
        config = {
          LoadModule = [ "webadmin" ];
          User.${cfg.username} = {
            Admin = true;
            Nick = "${cfg.username}";
            RealName = "${cfg.username}";
            QuitMsg = "${cfg.username} out";
            LoadModule = [ "chansaver" "controlpanel" "perform" ];
            Pass.password = {
              Method = "sha256";
              Hash = cfg.password-hash;
              Salt = cfg.password-salt;
            };
          };
        };
      };
    }
    (mkIf cfg.irc2p {
      services.i2p-router.enable = true;

      services.znc.config.User.${cfg.username} = {
        Network.irc2p = {
          Server = "127.0.0.1 6668";
          LoadModule = [ "simple_away" "nickserv" "keepnick" ];
          Chan = {
            "#i2p" = { };
          };
        };
      };

      services.i2pd.outTunnels = {
        IRC-IRC2P = {
          enable = true;
          port = 6668;
          destination = "irc.postman.i2p";
          destinationPort = 6667;
          keys = "";
        };
      };
    })
    (mkIf cfg.anarplex {
      services.i2p-router.enable = true;

      services.znc.config.User.${cfg.username} = {
        Network.anarplex = {
          Server = "127.0.0.1 4322";
          LoadModule = [ "simple_away" "nickserv" "keepnick" ];
          Chan = {
            "#agora" = { };
          };
        };
      };

      # socat tunnel to connect znc to tor
      # https://wiki.znc.in/Tor
      systemd.services.anarplex-socat = {
        bindsTo = [ "znc.service" ];
        wantedBy = [ "znc.service" ];
        before = [ "znc.service" ];
        script = ''
          ${pkgs.socat}/bin/socat TCP4-LISTEN:4322,fork SOCKS4A:localhost:vxecvd6lc4giwtasjhgbrr3eop6pzq6i5rveracktioneunalgqlwfad.onion:6667,socksport=9050
        '';
        serviceConfig = {
          User = "znc";
          Group = "znc";
        };
      };
    })
  ]);
}
