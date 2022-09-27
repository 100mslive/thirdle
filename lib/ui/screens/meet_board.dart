import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    context
        .read<MeetKit>()
        .init()
        .then((value) => context.read<MeetKit>().actions.joinRoom());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(context.watch<MeetKit>().allPeers.length.toString()),
          SizedBox(
            height: 200,
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
          TextButton(
            child: const Text(
              "Leave",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () => context
                .read<MeetKit>()
                .actions
                .leaveRoom(context.read<MeetKit>()),
          ),
        ],
      ),
    );
  }
}
