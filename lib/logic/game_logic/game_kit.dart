import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:thirdle/logic/game_logic/models/word_model.dart';
import 'package:thirdle/utils/helper.dart';

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
  late String currentGuessWordString = "";
  GuessStatus currentGuessStatus = GuessStatus.validGuess;
  bool isWin = false;

  Future<void> init() async {
    String loadedString =
        await rootBundle.loadString('assets/answer_words.txt');
    _answerWordList = loadedString.split('\n');

    loadedString = await rootBundle.loadString('assets/valid_words.txt');
    _additionalValidWordList = loadedString.split('\n');
  }

  void startNewRound() {
    _actualWord = Word.fromString(
        wordString: _answerWordList[Helper.getRandomNumber(2316)]);

    guessWords = List.generate(
        noOfGuesses, (index) => Word.emptyWordFromSize(size: wordSize));
    currentGuessNo = 0;
    currentGuessWordString = "";
    currentGuessStatus = GuessStatus.validGuess;
    isWin = false;
  }

  void resetRound() {
    startNewRound();
    notifyListeners();
  }

  void makeGuess() {
    if (_answerWordList.contains(currentGuessWordString) ||
        _additionalValidWordList.contains(currentGuessWordString)) {
      final newGuessWord = Word.fromString(wordString: currentGuessWordString);
      newGuessWord.compareWithWord(_actualWord);
      guessWords[currentGuessNo] = newGuessWord;
      currentGuessNo++;
      currentGuessStatus = GuessStatus.validGuess;
      isWin = newGuessWord.isCorrect();
    } else {
      currentGuessStatus = GuessStatus.invalidGuess;
    }
    currentGuessWordString = "";
    notifyListeners();
  }

  void updateGuessWord(String updatedGuessWordString) {
    currentGuessWordString = updatedGuessWordString;
    notifyListeners();
  }
}
