import 'package:thirdle/logic/game_logic/models/letter_model.dart';

class Word {
  Word._({required this.letters});

  factory Word.fromString(
      {required String wordString, bool isActualWord = false}) {
    return Word._(
      letters: wordString
          .split('')
          .map((letterString) => Letter(value: letterString))
          .toList(),
    );
  }

  factory Word.emptyWordFromSize({required int size}) {
    return Word._(
      letters: List.filled(size, ' ')
          .map((letterValue) => Letter(value: letterValue))
          .toList(),
    );
  }

  List<Letter> letters;

  /// Use this method on the guessed word with the actual word as param.
  /// It changes the letter status for all the letters of this object.
  void compareWithWord(Word actualWord) {
    List<bool> flags =
        List.generate(letters.length, (index) => false, growable: false);

    // check for correct letter and correct pos
    for (int i = 0; i < letters.length; i++) {
      if (!flags[i] && letters[i].value == actualWord.letters[i].value) {
        letters[i].status = LetterStatus.correctLetterWithPosition;
        flags[i] = true;
        continue;
      }
    }

    // check only for correct letter
    for (int i = 0; i < letters.length; i++) {
      if (letters[i].status != LetterStatus.none) continue;
      for (int j = 0; j < actualWord.letters.length; j++) {
        if (!flags[j] && letters[i].value == actualWord.letters[j].value) {
          letters[i].status = LetterStatus.correctLetter;
          flags[j] = true;
          break;
        }
      }
    }
  }

  /// Check if the status of all the letters in this object are
  /// `LetterStatus.correctLetterWithPosition`
  bool isCorrect() {
    for (var letter in letters) {
      if (letter.status != LetterStatus.correctLetterWithPosition) {
        return false;
      }
    }
    return true;
  }

  Map<String, dynamic> toMap() {
    return {
      "letters": letters.map((letter) => letter.toMap()).toList(),
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word._(
      letters: map["letters"]
          .map<Letter>(
            (letterMap) => Letter.fromMap(letterMap),
          )
          .toList(),
    );
  }
}
