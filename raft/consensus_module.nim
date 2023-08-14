# nim-raft
# Copyright (c) 2023 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE))
#  * MIT license ([LICENSE-MIT](LICENSE-MIT))
# at your option.
# This file may not be copied, modified, or distributed except according to
# those terms.

import protocol
import types

proc RaftConsensusProcessRequestVote*(consensus: RaftConsensusModule, msg: RaftMessageRequestVote): RaftMessageRequestVoteResponse =
  discard

proc RaftConsensusProcessAppendEntries*(consensus: RaftConsensusModule, msg: RaftMessageAppendEntries): RaftMessageAppendEntriesResponse =
  discard

proc RaftConsensusQuorumMin(consensus: RaftConsensusModule): bool =
  discard