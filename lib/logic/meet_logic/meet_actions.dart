import 'dart:convert';

import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:thirdle/logic/game_logic/models/word_model.dart';
import 'package:thirdle/logic/meet_logic/meet_kit.dart';
import 'package:thirdle/logic/meet_logic/models/peer_data.dart';
import 'package:thirdle/utils/helper.dart';

class MeetActions {
  late HMSConfig config;
  late HMSSDK sdk;

  late String userName, userRoomId, userSubdomain;

  Future<void> joinRoom(
      {required String name,
      required String room,
      required String subdomain}) async {
    http.Response response = await http.post(
      Uri.parse(
          "https://prod-in2.100ms.live/hmsapi/$subdomain.app.100ms.live/api/token"),
      body: {
        'room_id': room,
        'user_id': Helper.getRandomString(16),
        'role': 'host'
      },
    );
    var body = json.decode(response.body);
    final String token = body['token'];

    config = HMSConfig(authToken: token, userName: name);
    sdk.join(config: config).then((value) {
      userName = name;
      userRoomId = room;
      userSubdomain = subdomain;
    });
  }

  Future<void> leaveRoom(MeetKit kit) async {
    sdk.removeUpdateListener(listener: kit);
    await sdk.leave();
    kit.clear();
  }

  Future<void> updateMetadata(
      {required List<Word> words, required int guessNo}) async {
    final wordMapList = words.map((word) => word.toMap()).toList();
    final String newMetadata = jsonEncode(
      {
        "guessNo": guessNo,
        "wordMapList": wordMapList,
      },
    );
    await sdk.changeMetadata(metadata: newMetadata);
  }

  PeerData? parseMetadata(String? metadata) {
    if (metadata == null) return null;
    final Map<String, dynamic> parsedMetadata = jsonDecode(metadata);
    final int guessNo = parsedMetadata["guessNo"];
    final List<Word> wordList = parsedMetadata["wordMapList"]
        .map<Word>(
          (element) => Word.fromMap(element),
        )
        .toList();
    return PeerData(wordList: wordList, guessNo: guessNo);
  }
}
