import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thirdle/logic/meet_logic/meet_actions.dart';
import 'package:thirdle/logic/meet_logic/models/peer_data.dart';

class MeetKit extends ChangeNotifier implements HMSUpdateListener {
  List<HMSPeer> allPeers = [];
  late MeetActions actions;
  Map<String, PeerData?> peerData = {};

  Future<void> init() async {
    await _getPermissions();
    actions = MeetActions();
    actions.sdk = HMSSDK();
    await actions.sdk.build();
    actions.sdk.addUpdateListener(listener: this);
  }

  void clear() {
    allPeers.clear();
    peerData.clear();
  }

  Future<bool> _getPermissions() async {
    if (Platform.isIOS) return true;
    await Permission.camera.request();
    await Permission.microphone.request();

    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }
    return true;
  }

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {
    // Not a priority
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    // Not a priority
  }

  @override
  void onHMSError({required HMSException error}) {
    print(error);
  }

  @override
  void onJoin({required HMSRoom room}) {
    if (room.peers != null) {
      allPeers = room.peers!;
      room.peers!.map((peer) {
        peerData[peer.peerId] = actions.parseMetadata(peer.metadata);
      });
    }
    notifyListeners();
  }

  @override
  void onMessage({required HMSMessage message}) {
    // Not a priority
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        allPeers.add(peer);
        break;
      case HMSPeerUpdate.peerLeft:
        allPeers.remove(peer);
        break;
      case HMSPeerUpdate.metadataChanged:
        peerData[peer.peerId] = actions.parseMetadata(peer.metadata);
        break;
      case HMSPeerUpdate.roleUpdated:
      case HMSPeerUpdate.nameChanged:
      case HMSPeerUpdate.defaultUpdate:
      case HMSPeerUpdate.networkQualityUpdated:
        final peerIndex = allPeers
            .indexWhere((existingPeer) => existingPeer.peerId == peer.peerId);
        if (peerIndex != -1) {
          allPeers[peerIndex] = peer;
        }
    }
    notifyListeners();
  }

  @override
  void onReconnected() {
    // TODO: implement onReconnected
  }

  @override
  void onReconnecting() {
    // TODO: implement onReconnecting
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    // TODO: implement onRemovedFromRoom
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    // TODO: implement onRoleChangeRequest
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // TODO: implement onRoomUpdate
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    final peerIndex = allPeers
        .indexWhere((existingPeer) => existingPeer.peerId == peer.peerId);
    if (peerIndex != -1) {
      allPeers.removeAt(peerIndex);
      allPeers.insert(peerIndex, peer);
    }
    notifyListeners();
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // No need to implement
  }
}
