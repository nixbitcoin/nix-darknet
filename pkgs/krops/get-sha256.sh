#! /usr/bin/env nix-shell
#! nix-shell -i bash -p git
set -euo pipefail

archive_hash () {
    repo=$1
    rev=$2
    nix-prefetch-url --unpack "https://github.com/${repo}/archive/${rev}.tar.gz" 2> /dev/null | tail -n 1
}

echo "Fetching latest krops commit"
latest=$(git ls-remote https://github.com/krebs/krops master | cut -f 1)
echo "rev: ${latest}"
echo "sha256: $(archive_hash krebs/krops $latest)"
