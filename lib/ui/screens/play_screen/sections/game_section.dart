import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/logic/game_logic/game_kit.dart';
import 'package:thirdle/logic/meet_logic/meet_kit.dart';
import 'package:thirdle/logic/meet_logic/models/peer_data_model.dart';
import 'package:thirdle/ui/components/game_components/current_guess_word_bar.dart';
import 'package:thirdle/ui/components/game_components/game_keyboard.dart';
import 'package:thirdle/ui/components/game_components/guess_word_bar.dart';
import 'package:thirdle/ui/components/reusable_components/the_button.dart';
import 'package:thirdle/utils/palette.dart';

class GameSection extends StatelessWidget {
  GameSection({super.key});

  @override
  Widget build(BuildContext context) {
    final gameKit = context.watch<GameKit>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GuessWordsBox(),
        gameKit.isWin
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
                      ),
                    ],
                  ),
      ],
    );
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

        gameKit.resetRound();
        final localPeerData = PeerData(
            wordList: gameKit.guessWords, guessNo: gameKit.currentGuessNo);
        meetKit.actions.updateMetadata(localPeerData: localPeerData);
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
