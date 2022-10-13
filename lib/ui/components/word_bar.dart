import 'package:flutter/material.dart';
import 'package:thirdle/constants/colors.dart';
import 'package:thirdle/game_logic/models/letter_model.dart';
import 'package:thirdle/game_logic/models/word_model.dart';

class WordBar extends StatelessWidget {
  const WordBar({required this.word, super.key});

  final Word word;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: word.letters
            .map((letter) => LetterTile(
                  letter: letter,
                ))
            .toList(),
      ),
    );
  }
}

class LetterTile extends StatelessWidget {
  const LetterTile({required this.letter, super.key});

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
              color: Colors.grey.withOpacity(0.5),
              offset: const Offset(0, 5),
              blurRadius: 5,
              spreadRadius: -5)
        ],
        color: letter.value == ' '
            ? kLetterEmptyColor
            : (letter.status == LetterStatus.correctLetterWithPosition
                ? kLetterGreenColor
                : (letter.status == LetterStatus.correctLetter)
                    ? kLetterYellowColor
                    : kLetterGreyColor),
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
