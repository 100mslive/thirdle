import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/constants/colors.dart';
import 'package:thirdle/game_logic/game_kit.dart';

class GuessWordBox extends StatefulWidget {
  const GuessWordBox({super.key, this.noOfLetters = 5});

  final int noOfLetters;

  @override
  State<GuessWordBox> createState() => _GuessWordBoxState();
}

class _GuessWordBoxState extends State<GuessWordBox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ...context.watch<GameKit>().currentGuessWord.split('').map(
              (letterText) => GuessLetterBox(letterText: letterText),
            ),
        ...List.generate(
          (widget.noOfLetters -
              context.watch<GameKit>().currentGuessWord.length),
          (index) => const GuessLetterBox(letterText: ""),
        ),
      ]),
    );
  }
}

class GuessLetterBox extends StatelessWidget {
  const GuessLetterBox({super.key, required this.letterText});

  final String letterText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            color: kLetterGreyColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kSecondaryHMSColor)),
        child: Center(
          child: Text(
            letterText.toUpperCase(),
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
