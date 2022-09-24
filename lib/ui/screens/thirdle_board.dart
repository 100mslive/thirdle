import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/game_logic/models/word_model.dart';
import 'package:thirdle/game_logic/game_kit.dart';
import 'package:thirdle/ui/components/thirdle_keyboard.dart';
import 'package:thirdle/ui/components/word_bar.dart';

class ThirdleBoard extends StatefulWidget {
  const ThirdleBoard({super.key});

  @override
  State<ThirdleBoard> createState() => _ThirdleBoardState();
}

class _ThirdleBoardState extends State<ThirdleBoard> {
  @override
  void initState() {
    Provider.of<GameKit>(context, listen: false).startNewRound(9);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameKit>(
      builder: ((context, thirdleKit, child) {
        final TextEditingController textEditingController =
            TextEditingController();
        final ScrollController scrollController = ScrollController();

        void _animateToCurrentWord() {
          scrollController.animateTo(
            thirdleKit.guessNo * 50.0,
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          );
        }

        if (thirdleKit.guessStatus == GuessStatus.invalidGuess) {
          print("invalid word");
        }

        return Column(children: [
          Container(
            height: 220,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: ListView(
              children: thirdleKit.guessWords
                  .map(
                    (guessWord) => WordBar(
                      word: guessWord,
                    ),
                  )
                  .toList(),
              controller: scrollController,
            ),
          ),
          ThirdleKeyboard(
            controller: textEditingController,
            maxWordLimit: thirdleKit.wordSize,
            onEnterTap: (guessWordString) {
              thirdleKit.makeGuess(guessWordString);
              _animateToCurrentWord();
            },
          ),
        ]);
      }),
    );
  }
}
