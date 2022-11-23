import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/logic/game_logic/game_kit.dart';
import 'package:thirdle/logic/game_logic/models/letter_model.dart';
import 'package:thirdle/logic/meet_logic/meet_kit.dart';
import 'package:thirdle/ui/components/game_components/current_guess_word_bar.dart';
import 'package:thirdle/ui/components/game_components/game_keyboard.dart';
import 'package:thirdle/ui/components/game_components/guess_word_bar.dart';
import 'package:thirdle/ui/components/reusable_components/the_button.dart';
import 'package:thirdle/utils/helper.dart';
import 'package:thirdle/utils/palette.dart';

class GameSection extends StatelessWidget {
  GameSection({super.key});

  @override
  Widget build(BuildContext context) {
    final gameKit = context.watch<GameKit>();

    bool isWin = false;

    final latestWord = gameKit.currentGuessNo > 0
        ? gameKit.guessWords.elementAt(gameKit.currentGuessNo - 1)
        : gameKit.guessWords.first;

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
          children: gameKit.guessWords
              .map(
                (guessWord) => GuessWordBar(
                  word: guessWord,
                ),
              )
              .toList(),
        ),
      ),
      isWin
          ? Column(
              children: [
                SizedBox(
                  width: 180,
                  child: Image.asset("assets/you_win.png"),
                ),
                const PlayAgainButton(),
              ],
            )
          : gameKit.currentGuessNo >= 5
              ? Column(
                  children: [
                    SizedBox(
                      width: 180,
                      child: Image.asset("assets/game_over.png"),
                    ),
                    const PlayAgainButton(),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      width: 380,
                      padding: const EdgeInsets.only(bottom: 10),
                      child: const CurrentGuessWordBar(),
                    ),
                    GameKeyboard(
                      keyHeight: 38,
                      keyWidth: 24,
                      maxWordLimit: gameKit.wordSize,
                      onEnterTap: (guessWordString) async {
                        final gameKit = context.read<GameKit>();
                        final meetKit = context.read<MeetKit>();

                        gameKit.makeGuess(guessWordString);

                        if (gameKit.currentGuessStatus ==
                            GuessStatus.validGuess) {
                          meetKit.actions.updateMetadata(
                            words: gameKit.guessWords,
                            guessNo: gameKit.currentGuessNo,
                          );
                          // animateToCurrentWord();
                        } else {
                          showToastWidget(
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                child: Container(
                                    height: 40,
                                    width: 200,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                    ),
                                    child: const Center(
                                      child: Text("Invalid Word",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    )),
                              ),
                              position: ToastPosition.bottom);
                        }
                      },
                    ),
                  ],
                )
    ]);
  }
}

class PlayAgainButton extends StatelessWidget {
  const PlayAgainButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TheButton(
      width: 140,
      height: 45,
      onPressed: () {
        final gameKit = context.read<GameKit>();
        final meetKit = context.read<MeetKit>();

        gameKit.resetRound(Helper.getRandomNumber(2316));
        meetKit.actions.updateMetadata(
          words: gameKit.guessWords,
          guessNo: gameKit.currentGuessNo,
        );
      },
      childWidget: Text(
        "Play Again!",
        style: GoogleFonts.nunito(
          color: Palette.textWhiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
