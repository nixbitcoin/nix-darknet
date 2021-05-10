{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.XD;
  ndLib = config.nix-darknet.lib;
in {
  options.services.XD = {
    enable = mkEnableOption "XD";
    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/XD";
      description = "The data directory for XD.";
    };
    user = mkOption {
      type = types.str;
      default = "XD";
      description = "The user as which to run XD.";
    };
    group = mkOption {
      type = types.str;
      default = cfg.user;
      description = "The group as which to run XD.";
    };
    cli = mkOption {
      readOnly = true;
      default = pkgs.writeScriptBin "XD-CLI" ''
        cd ${cfg.dataDir} && doas -u ${cfg.user} ${config.nix-darknet.pkgs.XD}/bin/XD-CLI "$@"
      '';
      description = "Binary to connect with XD instance.";
    };
    enforceTor = ndLib.enforceTor;
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = config.services.i2pd.proto.sam.enable;
        message = "XD requires i2pd SAM bridge.";
      }
    ];

    environment.systemPackages = [
      (hiPrio cfg.cli)
    ];

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0770 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.XD = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "i2pd.service" ];
      after = [ "i2pd.service" ];
      serviceConfig = ndLib.defaultHardening // {
        WorkingDirectory = "${cfg.dataDir}";
        ExecStart = ''
          ${config.nix-darknet.pkgs.XD}/bin/XD ${cfg.dataDir}/xd.ini
        '';
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        RestartSec = "10s";
        ReadWritePaths = "${cfg.dataDir}";
      } // ndLib.allowedIPAddresses cfg.enforceTor;
    };

    users.users.${cfg.user} = {
      group = cfg.group;
    };
    users.groups.${cfg.group} = {};
  };
}
