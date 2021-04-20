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
    rev = "9a1672105db0eebe8ef59f310397435f2d0298d0";
    sha256 = "06z4r0aaha5qyd0prg7h1f5sjrsndca75150zf5w4ff6g9vdv1rb";
  };
  nixpkgs-unstable = fetch {
    rev = "0a5f5bab0e08e968ef25cff393312aa51a3512cf";
    sha256 = "161xisa5a7wi2h5hs0p1w7zbf095w21cs0wp0524kp7p6cpvvfyn";
  };
}
