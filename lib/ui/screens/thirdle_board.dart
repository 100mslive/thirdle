import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/game_logic/game_kit.dart';
import 'package:thirdle/meet_logic/meet_kit.dart';
import 'package:thirdle/ui/components/guess_word_box.dart';
import 'package:thirdle/ui/components/thirdle_keyboard.dart';
import 'package:thirdle/ui/components/word_bar.dart';

import '../../constants/colors.dart';

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
        // final ScrollController scrollController = ScrollController();

        // void animateToCurrentWord() {
        //   scrollController.animateTo(
        //     thirdleKit.guessNo * 35.0,
        //     duration: const Duration(milliseconds: 600),
        //     curve: Curves.bounceInOut,
        //   );
        // }

        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: 325,
            width: 350,
            margin: const EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 15,
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
                color: kGuessBoxColor,
                border: Border.all(
                  color: const Color.fromARGB(255, 122, 142, 156),
                ),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              // ListView(
              // controller: scrollController,
              children: thirdleKit.guessWords
                  .map(
                    (guessWord) => WordBar(
                      word: guessWord,
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            width: 380,
            padding: const EdgeInsets.only(bottom: 5),
            child: const GuessWordBox(),
          ),
          ThirdleKeyboard(
            height: 34,
            width: 22,
            borderRadius: BorderRadius.circular(4),
            maxWordLimit: thirdleKit.wordSize,
            onEnterTap: (guessWordString) async {
              final gameKit = context.read<GameKit>();
              final meetKit = context.read<MeetKit>();

              thirdleKit.makeGuess(guessWordString);

              if (gameKit.guessStatus == GuessStatus.validGuess) {
                meetKit.actions.updateMetadata(
                  words: gameKit.guessWords,
                  guessNo: gameKit.guessNo,
                );
                // animateToCurrentWord();
              } else {
                showToastWidget(
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: Container(
                          height: 40,
                          width: 200,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                          ),
                          child: const Center(
                            child: Text("Invalid Word",
                                style: TextStyle(color: Colors.white)),
                          )),
                    ),
                    position: ToastPosition.bottom);
              }
            },
          ),
        ]);
      }),
    );
  }
}
