import 'package:flutter/material.dart';

class GuessWordBox extends StatefulWidget {
  const GuessWordBox(
      {super.key, required this.controller, this.noOfLetters = 5});

  final TextEditingController controller;
  final int noOfLetters;

  @override
  State<GuessWordBox> createState() => _GuessWordBoxState();
}

class _GuessWordBoxState extends State<GuessWordBox> {
  String guessText = "";
  void updateGuessText() {
    setState(() {
      guessText = widget.controller.text;
    });
  }

  @override
  void initState() {
    widget.controller.addListener(updateGuessText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      ...guessText.split('').map(
            (letterText) => GuessLetterBox(letterText: letterText),
          ),
      ...List.generate(
        (widget.noOfLetters - guessText.length),
        (index) => const GuessLetterBox(letterText: ""),
      ),
    ]);
  }
}

class GuessLetterBox extends StatelessWidget {
  const GuessLetterBox({super.key, required this.letterText});

  final String letterText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Center(
        child: Text(
          letterText,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
