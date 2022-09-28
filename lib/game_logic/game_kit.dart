import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:thirdle/game_logic/models/word_model.dart';

enum GuessStatus { validGuess, invalidGuess }

class GameKit extends ChangeNotifier {
  GameKit({this.wordSize = 5, this.noOfGuesses = 6});

  final int wordSize, noOfGuesses;
  List<Word> guessWords = [];
  late Word _actualWord;
  String currentGuessWord = "";

  // scraped from https://gist.github.com/cfreshman/a03ef2cba789d8cf00c08f767e0fad7b
  // and https://gist.github.com/cfreshman/cdcdf777450c5b5301e439061d29694c
  late List<String> _additionalValidWordList, _answerWordList;
  int guessNo = 0;
  GuessStatus guessStatus = GuessStatus.validGuess;

  Future<void> init() async {
    String loadedString =
        await rootBundle.loadString('assets/answer_words.txt');
    _answerWordList = loadedString.split('\n');
    loadedString = await rootBundle.loadString('assets/valid_words.txt');
    _additionalValidWordList = loadedString.split('\n');
  }

  void startNewRound(int wordNo) {
    guessNo = 0;
    guessWords = List.generate(
        noOfGuesses, (index) => Word.emptyWordFromSize(size: wordSize));
    guessStatus = GuessStatus.validGuess;
    _actualWord = Word.fromString(wordString: _answerWordList[wordNo]);
  }

  void makeGuess(String newGuessWordString) {
    if (_answerWordList.contains(newGuessWordString) ||
        _additionalValidWordList.contains(newGuessWordString)) {
      final newGuessWord = Word.fromString(wordString: newGuessWordString);
      newGuessWord.compareWithWord(_actualWord);
      guessWords[guessNo] = newGuessWord;
      guessNo++;
      guessStatus = GuessStatus.validGuess;
    } else {
      guessStatus = GuessStatus.invalidGuess;
    }
    currentGuessWord = "";
    notifyListeners();
  }

  void updateGuessWord(String updatedGuessWord) {
    currentGuessWord = updatedGuessWord;
    notifyListeners();
  }
}
