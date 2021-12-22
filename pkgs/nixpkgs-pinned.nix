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
    rev = "9ab7d12287ced0e1b4c03b61c781901f178d9d77";
    sha256 = "0bbd2pgcyavqn5wgq0xp8p67lha0kv9iqnh49i9w5fb5g29q7i30";
  };
  nixpkgs-unstable = fetch {
    rev = "81cef6b70fb5d5cdba5a0fef3f714c2dadaf0d6d";
    sha256 = "1mj9psy1hfy3fbalwkdlyw3jmc97sl9g3xj1xh8dmhl68g0pfjin";
  };
}
