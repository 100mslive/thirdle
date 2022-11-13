import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/logic/game_logic/game_kit.dart';

import '../../../utils/palette.dart';

// Credits: https://github.com/Zfinix/worddle

class GameKeyboard extends StatefulWidget {
  const GameKeyboard({
    Key? key,
    required this.maxWordLimit,
    required this.height,
    required this.width,
    this.spacing = 8.0,
    this.borderRadius,
    this.color = const Color(0xFF2E80FF),
    this.letterStyle = const TextStyle(fontSize: 2, color: Colors.white),
    this.enableSpaceBar = false,
    this.enableBackSpace = true,
    this.enableCapsLock = false,
    this.highlightColor,
    this.splashColor,
    this.onEnterTap,
  }) : super(key: key);

  // The controller connected to the InputField
  final ValueChanged<String>? onEnterTap;

  // Vertical spacing between key rows
  final double spacing;

  // Border radius of the keys
  final BorderRadius? borderRadius;

  // Color of the keys
  final Color color;

  // max word size
  final int maxWordLimit;

  // TextStyle of the letters in the keys (fontsize, fontface)
  final TextStyle letterStyle;

  // the additional key that can be added to the keyboard
  final bool enableSpaceBar;
  final bool enableBackSpace;
  final bool enableCapsLock;

  // height and width of each key
  final double height;
  final double width;

  // The color displayed when the key is pressed
  final Color? highlightColor;
  final Color? splashColor;

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
        SizedBox(
          height: widget.spacing,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 5,
          children: keyboardLayout.sublist(10, 19),
        ),
        SizedBox(
          height: widget.spacing,
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
            widget.enableBackSpace
                ? backSpace()
                : SizedBox(
                    width: widget.width + 20,
                  ),
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
      height: widget.height,
      width: widget.width,
      child: Material(
        type: MaterialType.button,
        color: Palette.keyboardLetterTileColor,
        child: InkWell(
          highlightColor: widget.highlightColor,
          splashColor: widget.splashColor,
          onTap: () {
            HapticFeedback.heavyImpact();

            final gameKit = context.read<GameKit>();

            if (gameKit.currentGuessWord.length == widget.maxWordLimit) {
              return;
            }
            gameKit.updateGuessWord(gameKit.currentGuessWord + letter);
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
        height: widget.height,
        width: widget.width + 25,
        child: Material(
          type: MaterialType.button,
          color: Palette.keyboardLetterTileColor,
          child: InkWell(
            highlightColor: widget.highlightColor,
            splashColor: widget.splashColor,
            onTap: () {
              HapticFeedback.heavyImpact();

              final gameKit = context.read<GameKit>();

              if (gameKit.currentGuessWord.isNotEmpty) {
                gameKit.updateGuessWord(gameKit.currentGuessWord
                    .substring(0, gameKit.currentGuessWord.length - 1));
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
        height: widget.height,
        width: widget.width + 25,
        child: Material(
          type: MaterialType.button,
          color: Palette.keyboardLetterTileColor,
          child: InkWell(
            highlightColor: widget.highlightColor,
            splashColor: widget.splashColor,
            onTap: () {
              HapticFeedback.heavyImpact();

              if (widget.onEnterTap != null) {
                final gameKit = context.read<GameKit>();
                widget.onEnterTap!(gameKit.currentGuessWord);
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
