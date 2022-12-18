import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/logic/game_logic/game_kit.dart';
import 'package:thirdle/logic/meet_logic/meet_kit.dart';
import 'package:thirdle/logic/meet_logic/models/peer_data_model.dart';
import 'package:thirdle/ui/components/reusable_components/constrained_screen_wrapper.dart';
import 'package:thirdle/ui/screens/play_screen/sections/game_section.dart';
import 'package:thirdle/ui/screens/play_screen/sections/meet_section.dart';

class PlayScreen extends StatefulWidget {
  PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  void initState() {
    final gameKit = context.read<GameKit>();
    final meetKit = context.read<MeetKit>();

    gameKit.startNewRound();
    final localPeerData =
        PeerData(wordList: gameKit.guessWords, guessNo: gameKit.currentGuessNo);
    meetKit.actions.updateMetadata(localPeerData: localPeerData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScreenWrapper(
      onBackPress: () async {
        final meetKit = context.read<MeetKit>();
        await meetKit.actions.leaveRoom(meetKit);
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
