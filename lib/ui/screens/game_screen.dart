import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/meet_logic/meet_kit.dart';
import 'package:thirdle/ui/components/constrained_screen.dart';
import 'package:thirdle/ui/screens/meet_board.dart';
import 'package:thirdle/ui/screens/thirdle_board.dart';

class GameScreen extends StatelessWidget {
  GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedScreen(
      onBackPress: () async {
        await context
            .read<MeetKit>()
            .actions
            .leaveRoom(context.read<MeetKit>());
        return true;
      },
      childWidget: ListView(
        shrinkWrap: true,
        children: [
          MeetBoard(),
          ThirdleBoard(),
        ],
      ),
    );
  }
}
