import 'package:flutter/widgets.dart';
import 'package:thirdle/game_logic/models/word_model.dart';
import 'package:thirdle/ui/components/letter_tile.dart';

class WordBar extends StatelessWidget {
  const WordBar({required this.word, super.key});

  final Word word;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            word.letters.map((letter) => LetterTile(letter: letter)).toList(),
      ),
    );
  }
}
