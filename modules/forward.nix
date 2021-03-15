{ config, lib, pkgs, ... }:

{
  security.doas.enable = true;
  security.sudo.enable = false;

  users.users.forward = {
    isNormalUser = true;
  };
}
