# nim-raft-consensus
# Copyright (c) 2023 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE))
#  * MIT license ([LICENSE-MIT](LICENSE-MIT))
# at your option.
# This file may not be copied, modified, or distributed except according to
# those terms.

mode = ScriptMode.Verbose

packageName   = "raft_consensus"
version       = "0.0.1"
author        = "Status Research & Development GmbH"
description   = "raft consensus in nim"
license       = "Apache License 2.0"

requires "nim >= 1.2.0"
requires "stew >= 0.1.0"

# Helper functions
