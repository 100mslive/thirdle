import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<Timer> loadData() async {
    return Timer(const Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const App(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0F15),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Text(
            'Thirdle',
            style: GoogleFonts.pacifico(
              textStyle: TextStyle(
                  fontSize: 60, color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
