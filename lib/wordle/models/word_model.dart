import 'package:equatable/equatable.dart';
import 'package:thirdle/wordle/models/letter_model.dart';

class Word extends Equatable {
  const Word({required this.letters, this.isActualWord = true});

  final List<Letter> letters;
  final bool isActualWord;

  // use this method on guessed word with the actual word as param
  // changes the letter status
  Word comparedWord(Word actualWord) {
    List<Letter> newLetters = letters;
    List<bool> flags = List.generate(5, (index) => false);

    for (int i = 0; i < newLetters.length; i++) {
      // check for correct letter and correct pos
      if (!flags[i] && newLetters[i] == actualWord.letters[i]) {
        newLetters[i] = newLetters[i].copyWith(
          status: LetterStatus.correctLetterWithPosition,
        );
        flags[i] = true;
        continue;
      }

      // check only for correct letter
      for (int j = 0; j < actualWord.letters.length; j++) {
        if (!flags[j] && newLetters[i] == actualWord.letters[j]) {
          newLetters[i] = newLetters[i].copyWith(
            status: LetterStatus.correctLetter,
          );
          flags[i] = true;
          break;
        }
      }
    }

    return Word(letters: newLetters, isActualWord: isActualWord);
  }

  Word copyWith({List<Letter>? letters, bool? isActualWord}) {
    return Word(
      letters: letters ?? this.letters,
      isActualWord: isActualWord ?? this.isActualWord,
    );
  }

  @override
  List<Object?> get props => [letters];
}
