{ pkgs, buildGoModule, fetchurl, lib, perl }:

buildGoModule rec {
  pname = "XD";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/majestrate/XD/archive/v${version}.tar.gz";
    # Use ./get-sha256.sh to fetch latest (verified) sha256
    sha256 = "18faab1bae26721feb60487c190dda07c7297a9d35d69531074fbd683a3bbc02";
  };

  vendorSha256 = "1wg3cym2rwrhjsqlgd38l8mdq5alccz808465117n3vyga9m35lq";

  nativeBuildInputs = [ perl ];

  postInstall = ''
    ln -s $out/bin/XD $out/bin/XD-CLI
  '';

  meta = with lib; {
    description = ''
      i2p bittorrent client
    '';
    homepage = "https://xd-torrent.github.io";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ nixbitcoin ];
  };
}
