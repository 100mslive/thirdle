import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thirdle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SizedBox(),
    );
  }
}
