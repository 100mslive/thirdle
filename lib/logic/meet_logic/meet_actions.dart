import 'dart:convert';

import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:thirdle/logic/meet_logic/meet_kit.dart';
import 'package:thirdle/logic/meet_logic/models/peer_data_model.dart';
import 'package:thirdle/utils/helper.dart';

class MeetActions extends HMSActionResultListener {
  late HMSConfig _config;
  final HMSSDK _sdk;

  late String userName, userRoomId, userSubdomain;

  MeetActions._(this._sdk);

  // A custom factory(static) method to create MeetActions
  static Future<MeetActions> create(HMSUpdateListener listener) async {
    final sdk = HMSSDK();
    await sdk.build();
    sdk.addUpdateListener(listener: listener);
    return MeetActions._(sdk);
  }

  Future<void> joinRoom(
      {required String name,
      required String roomId,
      required String subdomain}) async {
    http.Response response = await http.post(
      Uri.parse(
          "https://prod-in2.100ms.live/hmsapi/$subdomain.app.100ms.live/api/token"),
      body: {
        'room_id': roomId,
        'user_id': Helper.getRandomString(16),
        'role': 'host'
      },
    );
    var body = json.decode(response.body);
    final String token = body['token'];

    _config = HMSConfig(authToken: token, userName: name);
    _sdk.join(config: _config).then((value) {
      userName = name;
      userRoomId = roomId;
      userSubdomain = subdomain;
    });
  }

  Future<void> leaveRoom(MeetKit kit) async {
    _sdk.removeUpdateListener(listener: kit);
    await _sdk.leave(hmsActionResultListener: this);
    kit.clear();
  }

  Future<void> updateMetadata({required PeerData localPeerData}) async {
    await _sdk.changeMetadata(
        metadata: localPeerData.toJson(), hmsActionResultListener: this);
  }

  PeerData? parseMetadata(String? metadata) {
    if (metadata == null) return null;
    return PeerData.fromJson(metadata);
  }

  @override
  void onException(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments,
      required HMSException hmsException}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        // Error leaving the Room!
        // Check the HMSException object for details about error
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        // Error updating the Metadata!
        // Check the HMSException object for details about error
        break;
      default:
    }
  }

  @override
  void onSuccess(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        // Left Room successfully!
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        // Metadata updated successfully!
        break;
      default:
    }
  }
}
