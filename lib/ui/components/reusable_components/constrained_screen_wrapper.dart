import 'package:flutter/material.dart';
import 'package:thirdle/utils/palette.dart';

class ConstrainedScreenWrapper extends StatelessWidget {
  const ConstrainedScreenWrapper(
      {super.key, required this.childWidget, required this.onBackPress});

  final Widget childWidget;
  final Future<bool> Function() onBackPress;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        backgroundColor: Palette.primaryColor,
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 380),
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: childWidget,
          ),
        ),
      ),
    );
  }
}
