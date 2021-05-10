#! /usr/bin/env nix-shell
#! nix-shell -i bash -p git gnupg
set -euo pipefail

TMPDIR="$(mktemp -d -p /tmp)"
trap "rm -rf $TMPDIR" EXIT
cd $TMPDIR

echo "Fetching latest release"
git clone https://github.com/majestrate/xd 2> /dev/null
cd xd
latest=$(git describe --tags `git rev-list --tags --max-count=1`)
echo "Latest release is ${latest}"

# GPG verification
export GNUPGHOME=$TMPDIR
echo "Fetching Jeff Becker's key"
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 67EF6BA68E7B0B0D6EB4F7D4F357B3B42F6F9B05 2> /dev/null

echo "Verifying latest release"
git verify-tag ${latest}

echo "tag: ${latest}"
# The prefix option is necessary because GitHub prefixes the archive contents in this format
echo "sha256: $(git archive --format tar.gz --prefix=XD-${latest//v}/ ${latest} | sha256sum | cut -d\  -f1)"
