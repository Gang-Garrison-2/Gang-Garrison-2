#!/usr/bin/env python3
"""Allow GG2's TCP listener to rebind after a previous local game exits."""

import sys
from pathlib import Path

source, output = map(Path, sys.argv[1:])
text = source.read_text()
for family in ("v4", "v6"):
    old = f"{family}acceptor->open(tcp::{family}());"
    new = old + f"\n\t\t{family}acceptor->set_option(boost::asio::socket_base::reuse_address(true));"
    if text.count(old) != 1:
        sys.exit(f"Faucet patch matched {text.count(old)} times: {old}")
    text = text.replace(old, new)
output.write_text(text)
