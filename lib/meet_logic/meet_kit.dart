import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thirdle/game_logic/models/word_model.dart';
import 'package:thirdle/meet_logic/meet_actions.dart';

class MeetKit extends ChangeNotifier implements HMSUpdateListener {
  late List<HMSPeer> remotePeers;
  late HMSPeer localPeer;
  late MeetActions actions;
  late Map<String, List<Word>> peerWords;

  Future<void> init() async {
    await _getPermissions();
    actions = MeetActions();
    actions.sdk = HMSSDK();
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
      localPeer = room.peers!.firstWhere((peer) => peer.isLocal);
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
        remotePeers.add(peer);
        break;
      case HMSPeerUpdate.peerLeft:
        remotePeers.remove(peer);
        break;
      case HMSPeerUpdate.metadataChanged:
        peerWords[peer.peerId] = actions.parseMetadata(peer.metadata!);
        break;
      case HMSPeerUpdate.roleUpdated:
      case HMSPeerUpdate.nameChanged:
      case HMSPeerUpdate.defaultUpdate:
      case HMSPeerUpdate.networkQualityUpdated:
        final peerIndex = remotePeers
            .indexWhere((existingPeer) => existingPeer.peerId == peer.peerId);
        remotePeers[peerIndex] = peer;
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
    final peerIndex = remotePeers
        .indexWhere((existingPeer) => existingPeer.peerId == peer.peerId);
    remotePeers[peerIndex] = peer;
    notifyListeners();
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // No need to implement
  }
}
