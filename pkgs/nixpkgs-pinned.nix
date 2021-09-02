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
    rev = "110a2c9ebbf5d4a94486854f18a37a938cfacbbb";
    sha256 = "0v12ylqxy1kl06dgln6h5k8vhlfzp8xvdymljj7bl0avr0nrgrcm";
  };
  nixpkgs-unstable = fetch {
    rev = "8d8a28b47b7c41aeb4ad01a2bd8b7d26986c3512";
    sha256 = "1s29nc3ppsjdq8kgbh8pc26xislkv01yph58xv2vjklkvsmz5pzm";
  };
}
