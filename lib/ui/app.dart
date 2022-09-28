import 'package:flutter/material.dart';
import 'package:thirdle/ui/screens/meet_board.dart';
import 'package:thirdle/ui/screens/thirdle_board.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0C0F15),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: ListView(
            shrinkWrap: true,
            children: const [
              MeetBoard(),
              ThirdleBoard(),
            ],
          )),
    );
  }
}
