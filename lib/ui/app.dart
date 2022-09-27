import 'package:flutter/material.dart';
import 'package:thirdle/ui/screens/meet_board.dart';
import 'package:thirdle/ui/screens/thirdle_board.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thirdle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: ListView(
            shrinkWrap: true,
            children: [
              MeetBoard(),
              ThirdleBoard(),
            ],
          )),
    );
  }
}
