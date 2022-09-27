import 'dart:convert';

import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:thirdle/game_logic/models/word_model.dart';
import 'package:thirdle/meet_logic/meet_kit.dart';

class MeetActions {
  late HMSConfig config;
  late HMSSDK sdk;

  Future<void> joinRoom(
      {String user = "test_user",
      String room = "62dad79fb1e780e78c39d2cd"}) async {
    http.Response response = await http.post(
      Uri.parse(
          "https://prod-in2.100ms.live/hmsapi/karthikeyan.app.100ms.live/api/token"),
      body: {'room_id': room, 'user_id': user, 'role': 'host'},
    );
    var body = json.decode(response.body);
    final String token = body['token'];

    config = HMSConfig(authToken: token);
    sdk.join(config: config);
  }

  Future<void> leaveRoom(MeetKit kit) async {
    sdk.removeUpdateListener(listener: kit);
    await sdk.leave();
  }

  Future<void> updateMetadata({required List<Word> words}) async {
    final String wordsJson =
        jsonEncode(words.map((word) => word.toMap()).toList());
    await sdk.changeMetadata(metadata: wordsJson);
  }

  List<Word> parseMetadata(String metadata) {
    List<Word> wordList = jsonDecode(metadata)
        .map<Word>(
          (element) => Word.fromMap(element),
        )
        .toList();
    return wordList;
  }
}
