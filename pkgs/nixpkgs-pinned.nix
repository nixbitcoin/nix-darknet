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
    rev = "0f85665118d850aae5164d385d24783d0b16cf1b";
    sha256 = "1x60c4s885zlqm1ffvjj09mjq078rqgcd08l85004cijfsqld263";
  };
  nixpkgs-unstable = fetch {
    rev = "73ad5f9e147c0d2a2061f1d4bd91e05078dc0b58";
    sha256 = "01j7nhxbb2kjw38yk4hkjkkbmz50g3br7fgvad6b1cjpdvfsllds";
  };
}
