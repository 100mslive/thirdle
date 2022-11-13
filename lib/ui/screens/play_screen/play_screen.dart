import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/logic/meet_logic/meet_kit.dart';
import 'package:thirdle/ui/components/reusable_components/constrained_screen_wrapper.dart';
import 'package:thirdle/ui/screens/play_screen/sections/game_section.dart';
import 'package:thirdle/ui/screens/play_screen/sections/meet_section.dart';

class PlayScreen extends StatelessWidget {
  PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedScreenWrapper(
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
          MeetSection(),
          GameSection(),
        ],
      ),
    );
  }
}
