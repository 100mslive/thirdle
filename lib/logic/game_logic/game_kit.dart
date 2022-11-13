import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:thirdle/logic/game_logic/models/word_model.dart';

enum GuessStatus { validGuess, invalidGuess }

class GameKit extends ChangeNotifier {
  GameKit({this.wordSize = 5, this.noOfGuesses = 5});

  final int wordSize, noOfGuesses;

  // scraped from https://gist.github.com/cfreshman/a03ef2cba789d8cf00c08f767e0fad7b
  // and https://gist.github.com/cfreshman/cdcdf777450c5b5301e439061d29694c
  late List<String> _additionalValidWordList, _answerWordList;

  late List<Word> guessWords = [];
  late Word _actualWord;

  late int currentGuessNo = 0;
  late String currentGuessWord = "";
  GuessStatus currentGuessStatus = GuessStatus.validGuess;

  Future<void> init() async {
    String loadedString =
        await rootBundle.loadString('assets/answer_words.txt');
    _answerWordList = loadedString.split('\n');

    loadedString = await rootBundle.loadString('assets/valid_words.txt');
    _additionalValidWordList = loadedString.split('\n');
  }

  void startNewRound(int wordNo) {
    _actualWord = Word.fromString(wordString: _answerWordList[wordNo]);

    guessWords = List.generate(
        noOfGuesses, (index) => Word.emptyWordFromSize(size: wordSize));
    currentGuessNo = 0;
    currentGuessWord = "";
    currentGuessStatus = GuessStatus.validGuess;
    notifyListeners();
  }

  void makeGuess(String newGuessWordString) {
    if (_answerWordList.contains(newGuessWordString) ||
        _additionalValidWordList.contains(newGuessWordString)) {
      final newGuessWord = Word.fromString(wordString: newGuessWordString);
      newGuessWord.compareWithWord(_actualWord);
      guessWords[currentGuessNo] = newGuessWord;
      currentGuessNo++;
      currentGuessStatus = GuessStatus.validGuess;
    } else {
      currentGuessStatus = GuessStatus.invalidGuess;
    }
    currentGuessWord = "";
    notifyListeners();
  }

  void updateGuessWord(String updatedGuessWord) {
    currentGuessWord = updatedGuessWord;
    notifyListeners();
  }
}
