import 'package:flutter/material.dart';
import 'package:thirdle/game_logic/models/letter_model.dart';

class LetterTile extends StatelessWidget {
  const LetterTile({required this.letter, super.key});

  final Letter letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: letter.status == LetterStatus.correctLetterWithPosition
            ? Colors.green
            : (letter.status == LetterStatus.correctLetter)
                ? Colors.yellow
                : Colors.grey,
      ),
      child: Center(
        child: Text(letter.value, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
