# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, ... }: {
  imports = [
    # FIXME: The hardened kernel profile improves security but
    # decreases performance by ~50%.
    # Turn it off when not needed.
    # Source: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix
    <nix-darknet/modules/presets/hardened.nix>

    # FIXME: Uncomment next line to import your hardware configuration. If so,
    # add the hardware configuration file to the same directory as this file.
    # This is not needed when deploying to a virtual box.
    # ./hardware-configuration.nix

    <nix-darknet/modules/modules.nix>
    <nix-darknet/modules/deployment/krops.nix>
  ];
  # FIXME: Enable modules by uncommenting their respective line. Disable
  # modules by commenting out their respective line.

  ### I2PD-RELAY
  # Enable this module to set up a full i2p router using i2pd. Comes with a http
  # proxy and POP3/SMTP out tunnels. Default bandwidth limit set to 150 KBps
  # with a share ratio of 80%.
  # services.i2p-router.enable = true;
  # Enter the port you wish to use for your i2p router here.
  # Open this external ports on your network firewall.
  # services.i2pd.port = <random port, use ../helper/random_ports>;

  ### TOR-BRIDGE
  # Enable this module to set up a Tor bridge relay.
  # See https://support.torproject.org/censorship/censorship-7/ on "What is a
  # bridge?"
  # services.tor-bridge.enable = true;
  # Enter the ports you wish to use for your Tor node here. Note,
  # tor-bridge.port & tor-bridge.obfsproxy-port need to be two different ports.
  # Open these external ports on your network firewall.
  # services.tor-bridge.port = <random port, use ../helper/random_ports>;
  # services.tor-bridge.obfsproxy-port = <random port, use ../helper/random_ports>;

  ### ZNC
  # Enable this module to set up an IRC bouncer using znc.
  # services.irc-bouncer.enable = true;
  # Enter your username here (will be used for ZNC server and all networks)
  # services.irc-bouncer.username = "<your username>";
  # Enter your ZNC password hash & salt here. Generate in nix-shell with
  # `znc --makepass`.
  # services.irc-bouncer.password-hash = "<Hash from `znc --makepass`>";
  # services.irc-bouncer.password-salt = "<Salt from `znc --makepass`>";

  ## IRC-NETWORKS
  # Enable this option to automatically connect to the freenode IRC network
  # with your username. (Tor)
  # Place user.pem in <deployment dir>/secrets
  # See https://freenode.net/news/tor-online on how to generate and add your
  # client certificate (user.pem).
  # services.irc-bouncer.freenode = true;
  # Enable this option to automatically connect to the irc2p IRC network
  # with your username. (I2P)
  # Configure password with nickserv https://wiki.znc.in/Nickserv
  # services.irc-bouncer.irc2p = true;
  # Enable this option to automatically connect to the anarplex IRC network
  # with your username. (I2P)
  # Configure password with nickserv https://wiki.znc.in/Nickserv
  # services.irc-bouncer.anarplex = true;

  # FIXME: Define your hostname.
  networking.hostName = "nix-darknet";
  time.timeZone = "UTC";

  # FIXME: Add your SSH pubkeys
  # Key for root user
  services.openssh.enable = true;
  users.users.root = {
    openssh.authorizedKeys.keys = [ "" ];
  };
  # Key for less-privileged user, used for SSH forwarding
  users.users.forward = {
    openssh.authorizedKeys.keys = [ "" ];
  };

  # FIXME: add packages you need in your system
  environment.systemPackages = with pkgs; [
    vim
  ];

  # FIXME: Add custom options (like boot options, output of
  # nixos-generate-config, etc.):

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
