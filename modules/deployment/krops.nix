{ lib, ... }:
{
  environment.variables.NIX_PATH = lib.mkForce "/var/src";
}
