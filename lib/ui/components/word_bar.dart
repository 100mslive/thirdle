import 'package:flutter/material.dart';
import 'package:thirdle/game_logic/models/letter_model.dart';
import 'package:thirdle/game_logic/models/word_model.dart';

class WordBar extends StatelessWidget {
  const WordBar(
      {required this.word,
      this.letterBoxSize = 50.0,
      this.obfuscateLetters = false,
      super.key});

  final Word word;
  final double letterBoxSize;
  final bool obfuscateLetters;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: letterBoxSize + 20.0,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: word.letters
            .map((letter) => LetterTile(
                  letter: letter,
                  letterBoxSize: letterBoxSize,
                  obfuscateLetter: obfuscateLetters,
                ))
            .toList(),
      ),
    );
  }
}

class LetterTile extends StatelessWidget {
  const LetterTile(
      {required this.letter,
      required this.letterBoxSize,
      required this.obfuscateLetter,
      super.key});

  final Letter letter;
  final double letterBoxSize;
  final bool obfuscateLetter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: letterBoxSize,
      width: letterBoxSize,
      decoration: BoxDecoration(
        color: letter.status == LetterStatus.correctLetterWithPosition
            ? Colors.green
            : (letter.status == LetterStatus.correctLetter)
                ? Colors.yellow
                : Colors.grey,
      ),
      child: obfuscateLetter
          ? const SizedBox()
          : Center(
              child: Text(
                letter.value,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
            ),
    );
  }
}
