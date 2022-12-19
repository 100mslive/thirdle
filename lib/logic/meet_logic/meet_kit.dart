import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thirdle/logic/meet_logic/meet_actions.dart';
import 'package:thirdle/logic/meet_logic/models/peer_data_model.dart';

class MeetKit extends ChangeNotifier implements HMSUpdateListener {
  List<HMSPeer> allPeers = [];
  late MeetActions actions;
  Map<String, PeerData?> peerDataMap = {};

  Future<void> init() async {
    await _getPermissions();
    actions = MeetActions();
    await actions.sdk.build();
    actions.sdk.addUpdateListener(listener: this);
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

  void clear() {
    allPeers.clear();
    peerDataMap.clear();
  }

  void _updatePeer({required HMSPeer peer}) {
    final peerIndex = allPeers
        .indexWhere((existingPeer) => existingPeer.peerId == peer.peerId);
    if (peerIndex != -1) {
      allPeers.removeAt(peerIndex);
      allPeers.insert(peerIndex, peer);
    }
  }

  @override
  void onJoin({required HMSRoom room}) {
    if (room.peers != null) {
      allPeers = room.peers!;
      room.peers!.map((peer) {
        peerDataMap[peer.peerId] = actions.parseMetadata(peer.metadata);
      });
    }
    notifyListeners();
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
        peerDataMap[peer.peerId] = actions.parseMetadata(peer.metadata);
        break;
      case HMSPeerUpdate.roleUpdated:
      case HMSPeerUpdate.nameChanged:
      case HMSPeerUpdate.defaultUpdate:
      case HMSPeerUpdate.networkQualityUpdated:
        _updatePeer(peer: peer);
    }
    notifyListeners();
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    _updatePeer(peer: peer);
    notifyListeners();
  }

  @override
  void onHMSError({required HMSException error}) {
    print(error);
  }

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {
    // TODO: implement onAudioDeviceChanged
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    // TODO: implement onChangeTrackStateRequest
  }

  @override
  void onMessage({required HMSMessage message}) {
    // TODO: implement onMessage
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
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // TODO: implement onUpdateSpeakers
  }
}
