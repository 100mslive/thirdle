import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thirdle/logic/meet_logic/meet_kit.dart';
import 'package:thirdle/ui/components/meet_components/meet_peer_tile.dart';
import 'package:thirdle/utils/palette.dart';

class MeetSection extends StatelessWidget {
  MeetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 135,
      width: 380,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.share),
                color: Palette.secondaryColor,
                iconSize: 30,
                onPressed: (() {
                  final meetKit = context.read<MeetKit>();
                  Uri uri = Uri(
                      scheme: "http",
                      host: "app.thirdle.live",
                      queryParameters: <String, dynamic>{
                        "roomId": meetKit.actions.userRoomId,
                        "subdomain": meetKit.actions.userSubdomain,
                      });
                  Share.share(uri.toString());
                }),
              ),
            ),
          ),
          ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: context
                .watch<MeetKit>()
                .allPeers
                .map<Widget>(
                  (peer) => MeetPeerTile(peer: peer),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
