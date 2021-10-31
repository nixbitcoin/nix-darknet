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
    rev = "e3699f9a4be7f9e12e697e7dc8ee6a0ec790e9e1";
    sha256 = "0dqgwmpfmzcinfk21kqmvjgwm6j0dlc9pd2614my5dfjjl9nfx9w";
  };
  nixpkgs-unstable = fetch {
    rev = "2deb07f3ac4eeb5de1c12c4ba2911a2eb1f6ed61";
    sha256 = "0036sv1sc4ddf8mv8f8j9ifqzl3fhvsbri4z1kppn0f1zk6jv9yi";
  };
}
