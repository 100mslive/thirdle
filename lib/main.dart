import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/game_logic/game_kit.dart';
import 'package:thirdle/meet_logic/meet_kit.dart';
import 'package:thirdle/ui/app.dart';
import 'package:thirdle/ui/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final GameKit thirdleKit = GameKit();
  await thirdleKit.init();
  final MeetKit meetKit = MeetKit();
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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: const Color(0xFF2E80FF)),
      home: SplashScreen(),
    );
  }
}
