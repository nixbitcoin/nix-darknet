{ extraSources, krops }:

krops.lib.evalSource [({
  nixos-config.file = toString ../krops-configuration.nix;

  "configuration.nix".file = toString ../configuration.nix;

  # Enable `useChecksum` for sources which might be located in the nix store
  # and which therefore might have static timestamps.

  nixpkgs.file = {
    path = toString <nixpkgs>;
    useChecksum = true;
  };

  nix-darknet.file = {
    path = toString <nix-darknet>;
    useChecksum = true;
    filters = [{
      type = "exclude";
      pattern = ".git";
    }];
  };

  secrets.file = toString ../secrets;
} // extraSources)]
