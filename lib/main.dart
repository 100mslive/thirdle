import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/game_logic/game_kit.dart';
import 'package:thirdle/meet_logic/meet_kit.dart';
import 'package:thirdle/ui/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final GameKit thirdleKit = GameKit();
  await thirdleKit.init();
  final MeetKit meetKit = MeetKit();
  await meetKit.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: thirdleKit,
        ),
        ChangeNotifierProvider.value(
          value: meetKit,
        ),
      ],
      child: App(),
    ),
  );
}
