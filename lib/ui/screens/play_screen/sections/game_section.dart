import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/logic/game_logic/game_kit.dart';
import 'package:thirdle/logic/game_logic/models/letter_model.dart';
import 'package:thirdle/logic/meet_logic/meet_kit.dart';
import 'package:thirdle/ui/components/game_components/current_guess_word_bar.dart';
import 'package:thirdle/ui/components/game_components/game_keyboard.dart';
import 'package:thirdle/ui/components/game_components/guess_word_bar.dart';
import 'package:thirdle/utils/palette.dart';

class GameSection extends StatefulWidget {
  GameSection({super.key});

  @override
  State<GameSection> createState() => _GameSectionState();
}

class _GameSectionState extends State<GameSection> {
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
                    (guessWord) => GuessWordBar(
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
                          child: const CurrentGuessWordBar(),
                        ),
                        GameKeyboard(
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
