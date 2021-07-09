let
  fetch = { rev, sha256 }:
    builtins.fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${rev}.tar.gz";
      inherit sha256;
    };
in
{
  # To update, run ../helper/fetch-channel REV
  nixpkgs = fetch {
    rev = "e9148dc1c30e02aae80cc52f68ceb37b772066f3";
    sha256 = "1xs5all93r3fg4ld13s9lmzri0bgq25d9dydb08caqa7pc10f5ki";
  };
  nixpkgs-unstable = fetch {
    rev = "3a8d7958a610cd3fec3a6f424480f91a1b259185";
    sha256 = "0bmxrdn9sn6mxvkyyxdlxlzczfh59iy66c55ql144ilc1cjk28is";
  };
}
