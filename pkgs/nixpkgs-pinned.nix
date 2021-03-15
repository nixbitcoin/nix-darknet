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
    rev = "60b18a066e8ce5dd21ebff5324345d3586a67ad";
    sha256 = "1cr7r16vb4nxifykhak8awspdpr775kafrl7p6asgwicsng7giya";
  };
  nixpkgs-unstable = fetch {
    rev = "916ee862e87ac5ee2439f2fb7856386b4dc906ae";
    sha256 = "165byy4hgg44w4ks1l289yx98bifqwyk6amil9rq7z7978d5lsj9";
  };
}
