import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/logic/game_logic/game_kit.dart';
import 'package:thirdle/logic/meet_logic/meet_kit.dart';
import 'package:thirdle/logic/meet_logic/models/peer_data_model.dart';

import '../../../utils/palette.dart';

// Ripped and modified from https://github.com/Zfinix/worddle

class GameKeyboard extends StatefulWidget {
  GameKeyboard({
    Key? key,
    required this.maxWordLimit,
    required this.keyHeight,
    required this.keyWidth,
  }) : super(key: key);

  final BorderRadius? borderRadius = BorderRadius.circular(8);
  final Color color = const Color(0xFF2E80FF);
  final int maxWordLimit;
  final TextStyle letterStyle =
      const TextStyle(fontSize: 2, color: Colors.white);
  final double keyHeight;
  final double keyWidth;

  @override
  GameKeyboardState createState() => GameKeyboardState();
}

class GameKeyboardState extends State<GameKeyboard> {
  @override
  Widget build(BuildContext context) {
    var keyboardLayout = layout();
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 5,
          children: keyboardLayout.sublist(0, 10),
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 5,
          children: keyboardLayout.sublist(10, 19),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            enter(),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 5,
              children: keyboardLayout.sublist(19),
            ),
            backSpace(),
          ],
        ),
        const Offstage(),
      ],
    );
  }

  // Letter button widget
  Widget buttonLetter(String letter) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Palette.keyboardLetterTileColor.withOpacity(0.5),
            offset: const Offset(4, 2),
          ),
        ],
      ),
      height: widget.keyHeight,
      width: widget.keyWidth,
      child: Material(
        type: MaterialType.button,
        color: Palette.keyboardLetterTileColor,
        child: InkWell(
          onTap: () {
            final gameKit = context.read<GameKit>();

            if (gameKit.currentGuessWordString.length == widget.maxWordLimit) {
              return;
            }
            gameKit.updateGuessWord(gameKit.currentGuessWordString + letter);
          },
          child: Center(
            child: Text(
              letter.toUpperCase(),
              style: const TextStyle(
                fontSize: 19,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Backspace button widget
  Widget backSpace() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Palette.keyboardLetterTileColor.withOpacity(0.5),
            offset: const Offset(4, 3),
          ),
        ],
      ),
      child: SizedBox(
        height: widget.keyHeight,
        width: widget.keyWidth + 25,
        child: Material(
          type: MaterialType.button,
          color: Palette.keyboardLetterTileColor,
          child: InkWell(
            onTap: () {
              final gameKit = context.read<GameKit>();

              if (gameKit.currentGuessWordString.isNotEmpty) {
                gameKit.updateGuessWord(gameKit.currentGuessWordString
                    .substring(0, gameKit.currentGuessWordString.length - 1));
              }
            },
            child: const Center(
              child: Icon(
                Icons.backspace,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Capslock button widget
  Widget enter() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Palette.keyboardLetterTileColor.withOpacity(0.5),
            offset: const Offset(4, 3),
          ),
        ],
      ),
      child: SizedBox(
        height: widget.keyHeight,
        width: widget.keyWidth + 25,
        child: Material(
          type: MaterialType.button,
          color: Palette.keyboardLetterTileColor,
          child: InkWell(
            onTap: () {
              final gameKit = context.read<GameKit>();
              final meetKit = context.read<MeetKit>();

              gameKit.makeGuess();

              if (gameKit.currentGuessStatus == GuessStatus.validGuess) {
                final localPeerData = PeerData(
                  wordList: gameKit.guessWords,
                  guessNo: gameKit.currentGuessNo,
                  isWin: gameKit.isWin,
                );
                meetKit.actions.updateMetadata(localPeerData: localPeerData);
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
            child: Center(
              child: Text(
                'ENTER',
                style: TextStyle(
                  fontSize: 11,
                  color: widget.letterStyle.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Keyboard layout list
  List<Widget> layout() {
    final letters = 'qwertyuiopasdfghjklzxcvbnm'.split('');
    final keyboard = <Widget>[];
    for (var letter in letters) {
      keyboard.add(
        buttonLetter(letter),
      );
    }
    return keyboard;
  }
}
