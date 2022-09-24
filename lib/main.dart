import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/game_logic/game_kit.dart';
import 'package:thirdle/ui/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final GameKit thirdleKit = GameKit();
  await thirdleKit.init();
  runApp(
    ChangeNotifierProvider.value(
      value: thirdleKit,
      child: App(),
    ),
  );
}
