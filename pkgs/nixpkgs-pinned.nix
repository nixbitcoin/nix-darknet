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
    rev = "9ff91ce2e4c5d70551d4c8fd8830931c6c6b26b8";
    sha256 = "1i8ds4v6zbmnbhsrs9pby63sfbvd9sgba4w76ic9ic3lxmgy8b7z";
  };
  nixpkgs-unstable = fetch {
    rev = "29399e5ad1660668b61247c99894fc2fb97b4e74";
    sha256 = "0x8brwpxnj3hhz3fy0xrkx5jpm7g0jnm283m8317wal5k7gh6mwf";
  };
}
