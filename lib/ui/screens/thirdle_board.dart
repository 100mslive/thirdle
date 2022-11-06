import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/game_logic/game_kit.dart';
import 'package:thirdle/game_logic/models/letter_model.dart';
import 'package:thirdle/meet_logic/meet_kit.dart';
import 'package:thirdle/ui/components/guess_word_box.dart';
import 'package:thirdle/ui/components/thirdle_keyboard.dart';
import 'package:thirdle/ui/components/word_bar.dart';

import '../../utils/palette.dart';

class ThirdleBoard extends StatefulWidget {
  ThirdleBoard({super.key});

  @override
  State<ThirdleBoard> createState() => _ThirdleBoardState();
}

class _ThirdleBoardState extends State<ThirdleBoard> {
  bool isWin = false;

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

        final latestWord = thirdleKit.guessNo > 0
            ? thirdleKit.guessWords.elementAt(thirdleKit.guessNo - 1)
            : thirdleKit.guessWords.first;

        bool flag = true;
        for (var letter in latestWord.letters) {
          if (letter.status != LetterStatus.correctLetterWithPosition) {
            flag = false;
            break;
          }
        }
        if (flag) {
          isWin = true;
        }

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
                color: Palette.cardColor,
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
          isWin
              ? SizedBox(
                  width: 250,
                  child: Image.asset("assets/you_win.png"),
                )
              : thirdleKit.guessNo >= 5
                  ? SizedBox(
                      width: 250,
                      child: Image.asset("assets/game_over.png"),
                    )
                  : Column(
                      children: [
                        Container(
                          width: 380,
                          padding: const EdgeInsets.only(bottom: 10),
                          child: const GuessWordBox(),
                        ),
                        ThirdleKeyboard(
                          height: 38,
                          width: 24,
                          borderRadius: BorderRadius.circular(8),
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    child: Container(
                                        height: 40,
                                        width: 200,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                        ),
                                        child: const Center(
                                          child: Text("Invalid Word",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        )),
                                  ),
                                  position: ToastPosition.bottom);
                            }
                          },
                        ),
                      ],
                    )
        ]);
      }),
    );
  }
}
