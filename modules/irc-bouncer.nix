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
    liberachat = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable liberachat IRC over Tor.";
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
          Server = "127.0.0.1 4321";
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
          ${pkgs.socat}/bin/socat TCP4-LISTEN:4321,fork SOCKS4A:localhost:vxecvd6lc4giwtasjhgbrr3eop6pzq6i5rveracktioneunalgqlwfad.onion:6667,socksport=9050
        '';
        serviceConfig = {
          User = "znc";
          Group = "znc";
        };
      };
    })
    (mkIf cfg.liberachat {
      services.tor.client.enable = true;
      services.tor.settings.MapAddress = ''
        palladium.libera.chat libera75jm6of4wxpxt4aynol3xjmbtxgfyjpu34ss4d7r7q2v5zrpyd.onion
      '';

      services.znc.config.User.${cfg.username} = {
        Network.liberachat = {
          Server = "127.0.0.1 +4322";
          LoadModule = [ "simple_away" "cert" "sasl" "keepnick" ];
          Chan = {
            "#nix-bitcoin" = { };
          };
          extraConfig = ''
            TrustAllCerts = true
          '';
        };
      };

      # copy user client certificate from /var/src/secrets/user.pem to ZNC
      # moddata directory
      systemd.services.znc.serviceConfig = {
        IPAddressAllow = "127.0.0.1/32 ::1/128";
        IPAddressDeny = "any";
        ExecStartPost = "+${pkgs.writers.writeBash "script" ''
          set -eo pipefail
          mkdir -p -m 700 {config.services.znc.dataDir}/users/${cfg.username}/networks/liberachat/moddata/cert/
          cp /var/src/secrets/user.pem ${config.services.znc.dataDir}/users/${cfg.username}/networks/liberachat/moddata/cert/user.pem
          chown -R znc: ${config.services.znc.dataDir}/users/${cfg.username}/networks/liberachat/
          chmod -R 700 ${config.services.znc.dataDir}/users/${cfg.username}/networks/liberachat/
        ''}";
      };

      systemd.services.liberachat-socat = {
        bindsTo = [ "znc.service" ];
        wantedBy = [ "znc.service" ];
        before = [ "znc.service" ];
        script = ''
          ${pkgs.socat}/bin/socat TCP4-LISTEN:4322,fork SOCKS4A:localhost:palladium.libera.chat:6697,socksport=9050
        '';
        serviceConfig = {
          User = "znc";
          Group = "znc";
        };
      };
    })
  ]);
}
