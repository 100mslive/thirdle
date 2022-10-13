import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/game_logic/game_kit.dart';
import 'package:thirdle/meet_logic/meet_kit.dart';
import 'package:thirdle/ui/components/peer_tile.dart';

class MeetBoard extends StatefulWidget {
  const MeetBoard({super.key});

  @override
  State<MeetBoard> createState() => _MeetBoardState();
}

class _MeetBoardState extends State<MeetBoard> {
  @override
  void initState() {
    final gameKit = context.read<GameKit>();
    final meetKit = context.read<MeetKit>();

    meetKit.init().whenComplete(
          () => meetKit.actions.joinRoom().whenComplete(
                () => meetKit.actions.updateMetadata(
                  words: gameKit.guessWords,
                  guessNo: gameKit.guessNo,
                ),
              ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 135,
      width: 380,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: context
            .watch<MeetKit>()
            .allPeers
            .map<Widget>(
              (peer) => PeerTile(peer: peer),
            )
            .toList(),
      ),
    );
  }
}
