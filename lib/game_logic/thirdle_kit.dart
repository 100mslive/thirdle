import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:thirdle/game_logic/models/word_model.dart';

enum GuessStatus { validGuess, invalidGuess }

class ThirdleKit extends ChangeNotifier {
  ThirdleKit({this.wordSize = 5, this.noOfGuesses = 6});

  final int wordSize, noOfGuesses;
  final List<Word> guessWords = [];
  late Word _actualWord;
  late List<String> _validWordList, _answerWordList;
  GuessStatus guessStatus = GuessStatus.validGuess;

  Future<void> init() async {
    String loadedString =
        await rootBundle.loadString('assets/answer_words.txt');
    _answerWordList = loadedString.split('\n');
    loadedString = await rootBundle.loadString('assets/valid_words.txt');
    _validWordList = loadedString.split('\n');
  }

  void startNewRound(int wordNo) {
    guessWords.clear();
    guessStatus = GuessStatus.validGuess;
    _actualWord = Word.fromString(wordString: _answerWordList[wordNo]);
  }

  void makeGuess(String newGuessWordString) {
    if (_validWordList.contains(newGuessWordString)) {
      final newGuessWord = Word.fromString(wordString: newGuessWordString);
      newGuessWord.compareWithWord(_actualWord);
      guessWords.add(newGuessWord);
      guessStatus = GuessStatus.validGuess;
    } else {
      guessStatus = GuessStatus.invalidGuess;
    }
    notifyListeners();
  }
}
