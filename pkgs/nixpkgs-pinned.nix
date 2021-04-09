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
    rev = "d6f63659a7021051a46035373ed50fbea7e4e924";
    sha256 = "0vblhzg57sfzqpdm24lgs08vjv2204lzcp6hv4cbjd20rz0mxs4y";
  };
  nixpkgs-unstable = fetch {
    rev = "9e377a6ce42dccd9b624ae4ce8f978dc892ba0e2";
    sha256 = "1r3ll77hyqn28d9i4cf3vqd9v48fmaa1j8ps8c4fm4f8gqf4kpl1";
  };
}
