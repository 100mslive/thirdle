import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/game_logic/game_kit.dart';
import 'package:thirdle/meet_logic/meet_kit.dart';
import 'package:thirdle/ui/components/guess_word_box.dart';
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
    context.read<GameKit>().startNewRound(9);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameKit>(
      builder: ((context, thirdleKit, child) {
        final ScrollController scrollController = ScrollController();

        void animateToCurrentWord() {
          scrollController.animateTo(
            thirdleKit.guessNo * 50.0,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          );
        }

        if (thirdleKit.guessStatus == GuessStatus.invalidGuess) {
          print("invalid word");
        }

        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: 220,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ListView(
              controller: scrollController,
              children: thirdleKit.guessWords
                  .map(
                    (guessWord) => WordBar(
                      word: guessWord,
                    ),
                  )
                  .toList(),
            ),
          ),
          GuessWordBox(),
          ThirdleKeyboard(
            maxWordLimit: thirdleKit.wordSize,
            onEnterTap: (guessWordString) async {
              thirdleKit.makeGuess(guessWordString);
              context
                  .read<MeetKit>()
                  .actions
                  .updateMetadata(words: context.read<GameKit>().guessWords);
              animateToCurrentWord();
            },
          ),
        ]);
      }),
    );
  }
}
