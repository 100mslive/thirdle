import 'package:flutter/material.dart';
import 'package:thirdle/utils/palette.dart';

class ThirdleButton extends StatelessWidget {
  const ThirdleButton({
    super.key,
    required this.width,
    required this.height,
    required this.onPressed,
    required this.childWidget,
  });

  final double width, height;
  final Function() onPressed;
  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: width,
        height: height,
        child: ElevatedButton(
          style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Palette.cardColor),
              backgroundColor:
                  MaterialStateProperty.all(Palette.secondaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ))),
          onPressed: onPressed,
          child: childWidget,
        ));
  }
}
