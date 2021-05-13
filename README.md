nix-darknet is a collection of Nix packages and NixOS modules for easily self-hosting darknet services on a home SBC.

Overview
---
This project tries to stick as closely as possible to its "mother" project, [nix-bitcoin](https://github.com/fort-nix/nix-bitcoin). Not strictly necessary functionality, like tests and releases, have been left out for now.

Thorough documentation will follow once development stabilizes. Highly opinionated for now until more configurability is added.

Note: This is still highly experimental, don't expect it to be easy to use or stable.

Features
---
NixOS modules
* Application services
  * [i2p router](https://geti2p.net/en/about/glossary): i2p network router using i2pd
  * [Tor bridge](https://support.torproject.org/censorship/censorship-7/): Tor bridge relay to help users with censored internet connections
  * [IRC bouncer](https://wiki.znc.in/ZNC): supports [freenode](https://freenode.net/), [irc2p](https://geti2p.net/en/docs/applications/irc), and [anarplex](https://anarplex.net/) darknet IRC networks

Notes
---
On pfSense make sure the [static port option](https://docs.netgate.com/pfsense/en/latest/nat/outbound.html#static-port) for the corresponding outbound NAT rule is checked. Rewriting the source port will break i2pd.
