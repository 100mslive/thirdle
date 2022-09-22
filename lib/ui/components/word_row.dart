import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:thirdle/game_logic/models/word_model.dart';
import 'package:thirdle/ui/components/letter_tile.dart';

class WordRow extends StatelessWidget {
  const WordRow({required this.word, super.key});

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
