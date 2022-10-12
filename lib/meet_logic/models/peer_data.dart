import 'package:thirdle/game_logic/models/word_model.dart';

class PeerData {
  PeerData({required this.wordList, required this.guessNo});

  List<Word> wordList;
  int guessNo;
}
