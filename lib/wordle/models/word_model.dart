import 'package:thirdle/wordle/models/letter_model.dart';

class Word {
  Word({required this.letters, this.isActualWord = true});

  List<Letter> letters;
  final bool isActualWord;

  // use this method on guessed word with the actual word as param
  // changes the letter status
  void compareWithWord(Word actualWord) {
    List<bool> flags =
        List.generate(letters.length, (index) => false, growable: false);

    // we give preference to "correct letter and correct pos"
    // over just "corect pos"
    // Ex: Actual word = "apple" and Guess word = "apllp"
    // we want the status to be the following for the letters:
    // 1. correct letter with pos
    // 2. correct letter with pos
    // 3. none
    // 4. correct letter with pos
    // 5. correct letter
    // rather than:
    // 1. correct letter with pos
    // 2. correct letter with pos
    // 3. correct letter
    // 4. none
    // 5. correct letter

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
}
