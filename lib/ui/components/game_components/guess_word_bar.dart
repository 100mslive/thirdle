import 'package:flutter/material.dart';
import 'package:thirdle/logic/game_logic/models/letter_model.dart';
import 'package:thirdle/logic/game_logic/models/word_model.dart';
import 'package:thirdle/utils/palette.dart';

class GuessWordBar extends StatelessWidget {
  const GuessWordBar({required this.word, super.key});

  final Word word;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: word.letters
            .map((letter) => GuessLetterTile(
                  letter: letter,
                ))
            .toList(),
      ),
    );
  }
}

class GuessLetterTile extends StatelessWidget {
  const GuessLetterTile({required this.letter, super.key});

  final Letter letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Palette.secondaryColor.withOpacity(0.5),
            offset: const Offset(2, 2),
            blurRadius: 2,
          )
        ],
        color: letter.value == ' '
            ? Palette.wordleLetterTileEmptyColor
            : (letter.status == LetterStatus.correctLetterWithPosition
                ? Palette.wordleLetterTileGreenColor
                : (letter.status == LetterStatus.correctLetter)
                    ? Palette.wordleLetterTileYellowColor
                    : Palette.wordleLetterTileGreyColor),
      ),
      child: Center(
        child: Text(
          letter.value.toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
