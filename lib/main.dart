import 'package:flutter/material.dart';
import 'package:thirdle/wordle/models/letter_model.dart';
import 'package:thirdle/wordle/models/word_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Word actualWord = const Word(
    letters: [
      Letter(value: 'a'),
      Letter(value: 'p'),
      Letter(value: 'p'),
      Letter(value: 'l'),
      Letter(value: 'e'),
    ],
    isActualWord: true,
  );
  Word guessWord = Word(
    letters: [
      Letter(value: ''),
      Letter(value: ''),
      Letter(value: ''),
      Letter(value: ''),
      Letter(value: ''),
    ],
    isActualWord: true,
  );
  final TextEditingController _controller = TextEditingController();

  void _check() {
    setState(() {
      guessWord = guessWord.copyWith(
        letters: [
          Letter(value: _controller.text.substring(0, 1)),
          Letter(value: _controller.text.substring(1, 2)),
          Letter(value: _controller.text.substring(2, 3)),
          Letter(value: _controller.text.substring(3, 4)),
          Letter(value: _controller.text.substring(4, 5)),
        ],
        isActualWord: true,
      );
      guessWord = guessWord.comparedWord(actualWord);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Enter your guess:',
            ),
            TextField(
              controller: _controller,
            ),
            ...guessWord.letters
                .map((letter) => Text(letter.status.toString()))
                .toList()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _check,
        tooltip: 'Increment',
        child: const Icon(Icons.arrow_right),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
