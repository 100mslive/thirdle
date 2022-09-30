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
    context.read<MeetKit>().init().whenComplete(
          () => context.read<MeetKit>().actions.joinRoom().whenComplete(
                () => context
                    .read<MeetKit>()
                    .actions
                    .updateMetadata(words: context.read<GameKit>().guessWords),
              ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 220,
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
      ),
    );
  }
}
