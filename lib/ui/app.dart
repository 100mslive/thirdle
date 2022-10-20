import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/constants/colors.dart';
import 'package:thirdle/meet_logic/meet_kit.dart';
import 'package:thirdle/ui/screens/meet_board.dart';
import 'package:thirdle/ui/screens/thirdle_board.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await context
            .read<MeetKit>()
            .actions
            .leaveRoom(context.read<MeetKit>());
        return false;
      },
      child: Scaffold(
        backgroundColor: kPrimaryHMSColor,
        body: Center(
          child: Container(
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: ListView(
                shrinkWrap: true,
                children: const [
                  MeetBoard(),
                  ThirdleBoard(),
                ],
              )),
        ),
      ),
    );
  }
}
