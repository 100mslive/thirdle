import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/game_logic/game_kit.dart';

import '../../constants/colors.dart';

// Credits: https://github.com/Zfinix/worddle

class ThirdleKeyboard extends StatefulWidget {
  const ThirdleKeyboard({
    Key? key,
    required this.maxWordLimit,
    this.height,
    this.width,
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
  final double? height;
  final double? width;

  // The color displayed when the key is pressed
  final Color? highlightColor;
  final Color? splashColor;

  @override
  ThirdleKeyboardState createState() => ThirdleKeyboardState();
}

class ThirdleKeyboardState extends State<ThirdleKeyboard> {
  double height = 0;
  double width = 0;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    height = screenHeight > 800 ? screenHeight * 0.059 : screenHeight * 0.07;
    width = screenWidth > 350 ? screenWidth * 0.082 : screenWidth * 0.083;
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
                    width: (widget.width ?? width) + 20,
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
      decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: kThirdleBoardLetterColor.withOpacity(0.5),
              offset: Offset(1, 1),
            )
          ]),
      height: widget.height ?? height,
      width: widget.width ?? width,
      child: Material(
        type: MaterialType.button,
        color: kThirdleBoardLetterColor,
        child: InkWell(
          highlightColor: widget.highlightColor,
          splashColor: widget.splashColor,
          onTap: () {
            HapticFeedback.heavyImpact();

            if (context.read<GameKit>().currentGuessWord.length ==
                widget.maxWordLimit) {
              return;
            }
            context.read<GameKit>().updateGuessWord(
                context.read<GameKit>().currentGuessWord + letter);
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
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
      child: SizedBox(
        height: widget.height ?? height,
        width: (widget.width ?? width) + 20,
        child: Material(
          type: MaterialType.button,
          color: kPrimaryHMSColor,
          child: InkWell(
            highlightColor: widget.highlightColor,
            splashColor: widget.splashColor,
            onTap: () {
              HapticFeedback.heavyImpact();
              if (context.read<GameKit>().currentGuessWord.isNotEmpty) {
                context.read<GameKit>().updateGuessWord(context
                    .read<GameKit>()
                    .currentGuessWord
                    .substring(0,
                        context.read<GameKit>().currentGuessWord.length - 1));
              }
            },
            child: Center(
              child: Icon(
                Icons.backspace,
                size: widget.letterStyle.fontSize,
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
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
      child: SizedBox(
        height: widget.height ?? height,
        width: (widget.width ?? width) + 20,
        child: Material(
          type: MaterialType.button,
          color: kPrimaryHMSColor,
          child: InkWell(
            highlightColor: widget.highlightColor,
            splashColor: widget.splashColor,
            onTap: () {
              HapticFeedback.heavyImpact();

              if (widget.onEnterTap != null) {
                widget.onEnterTap!(context.read<GameKit>().currentGuessWord);
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
