# nim-raft
# Copyright (c) 2023 Status Research & Development GmbH
# Licensed under either of
#  * Apache License, version 2.0, ([LICENSE-APACHE](LICENSE-APACHE))
#  * MIT license ([LICENSE-MIT](LICENSE-MIT))
# at your option.
# This file may not be copied, modified, or distributed except according to
# those terms.

import chronicles
import asyncdispatch

import types
import protocol
import consensus_module

export types, protocol, consensus_module

proc RaftNodeSmInit[SmCommandType, SmStateType](stateMachine: var RaftNodeStateMachine[SmCommandType, SmStateType])

# Raft Node Public API procedures / functions
proc new*[SmCommandType, SmStateType](T: type RaftNode[SmCommandType, SmStateType];   # Create New Raft Node
                  id: RaftNodeId; peersIds: seq[RaftNodeId];
                  # persistentStorage: RaftNodePersistentStorage,
                  msgSendCallback: RaftMessageSendCallback): T =
  var
    sm: RaftNodeStateMachine[SmCommandType, SmStateType]
    peers: RaftNodePeers

  for peerId in peersIds:
    peers.add(RaftNodePeer(id: peerId, nextIndex: 0, matchIndex: 0, hasVoted: false, canVote: true))

  result = T(
    id: id, state: rnsFollower, currentTerm: 0, peers: peers, commitIndex: 0, lastApplied: 0,
    stateMachine: sm, msgSendCallback: msgSendCallback, votedFor: DefaultUUID, currentLeaderId: DefaultUUID
  )

  RaftNodeSmInit[SmCommandType, SmStateType](result.stateMachine)
  initLock(result.raftStateMutex)

proc RaftNodeLoad*[SmCommandType, SmStateType](
                  persistentStorage: RaftNodePersistentStorage,            # Load Raft Node From Storage
                  msgSendCallback: RaftMessageSendCallback): Result[RaftNode[SmCommandType, SmStateType], string] =
  discard

proc RaftNodeStop*[SmCommandType, SmStateType](node: RaftNode[SmCommandType, SmStateType]) =
  discard

proc RaftNodeStart*[SmCommandType, SmStateType](node: RaftNode[SmCommandType, SmStateType]) =
  debugEcho "StartNode: ", node.id

func RaftNodeIdGet*[SmCommandType, SmStateType](node: RaftNode[SmCommandType, SmStateType]): RaftNodeId {.gcsafe.} =        # Get Raft Node ID
  result = node.id

func RaftNodeStateGet*[SmCommandType, SmStateType](node: RaftNode[SmCommandType, SmStateType]): RaftNodeState =             # Get Raft Node State
  node.state

func RaftNodeTermGet*[SmCommandType, SmStateType](node: RaftNode[SmCommandType, SmStateType]): RaftNodeTerm =               # Get Raft Node Term
  node.currentTerm

func RaftNodePeersGet*[SmCommandType, SmStateType](node: RaftNode[SmCommandType, SmStateType]): RaftNodePeers =             # Get Raft Node Peers
  node.peers

func RaftNodeIsLeader*[SmCommandType, SmStateType](node: RaftNode[SmCommandType, SmStateType]): bool =                      # Check if Raft Node is Leader
  node.state == rnsLeader

# Deliver Raft Message to the Raft Node and dispatch it
proc RaftNodeMessageDeliver*[SmCommandType, SmStateType](node: RaftNode[SmCommandType, SmStateType], raftMessage: RaftMessageBase): Future[RaftMessageResponseBase] {.async, gcsafe.} =
  discard

# Process RaftNodeClientRequests
proc RaftNodeClientRequest*[SmCommandType, SmStateType](node: RaftNode[SmCommandType, SmStateType], req: RaftNodeClientRequest[SmCommandType]): Future[RaftNodeClientResponse[SmStateType]] {.async, gcsafe.} =
  discard

# Abstract State Machine Ops
func RaftNodeSmStateGet*[SmCommandType, SmStateType](node: RaftNode[SmCommandType, SmStateType]): SmStateType =
  node.stateMachine.state

proc RaftNodeSmInit[SmCommandType, SmStateType](stateMachine: var RaftNodeStateMachine[SmCommandType, SmStateType]) =
  mixin RaftSmInit
  RaftSmInit(stateMachine)

proc RaftNodeSmApply[SmCommandType, SmStateType](stateMachine: RaftNodeStateMachine[SmCommandType, SmStateType], command: SmCommandType) =
  mixin RaftSmApply
  RaftSmApply(stateMachine, command)

# Private Abstract Timer manipulation Ops
template RaftTimerCreate(timerInterval: int, oneshot: bool, timerCallback: RaftTimerCallback): RaftTimer =
  mixin RaftTimerCreateCustomImpl
  RaftTimerCreateCustomImpl(timerInterval, oneshot, timerCallback)

template RaftTimerCancel(timer: RaftTimer) =
  mixin RaftTimerCancelCustomImpl
  RaftTimerCancelCustomImpl(timer)

template RaftTimerStart() =
  mixin RaftTimerStartCustomImpl
  RaftTimerStartCustomImpl()

template RaftTimerStop() =
  mixin RaftTimerStopCustomImpl
  RaftTimerStopCustomImpl()

# Private Log Ops
proc RaftNodeLogAppend[SmCommandType, SmStateType](node: RaftNode[SmCommandType, SmStateType], logEntry: RaftNodeLogEntry[SmCommandType]) =
  discard

proc RaftNodeLogTruncate[SmCommandType, SmStateType](node: RaftNode[SmCommandType, SmStateType], truncateIndex: uint64) =
  discard

proc RaftNodeLogIndexGet[SmCommandType, SmStateType](node: RaftNode[SmCommandType, SmStateType]): RaftLogIndex =
  discard

proc RaftNodeLogEntryGet[SmCommandType, SmStateType](node: RaftNode[SmCommandType, SmStateType], logIndex: RaftLogIndex): Result[RaftNodeLogEntry[SmCommandType], string] =
  discard