import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/game_logic/models/letter_model.dart';
import 'package:thirdle/game_logic/models/word_model.dart';
import 'package:thirdle/meet_logic/meet_kit.dart';
import 'package:thirdle/meet_logic/models/peer_data.dart';

class PeerTile extends StatelessWidget {
  const PeerTile({required this.peer, super.key});
  final HMSPeer peer;
  @override
  Widget build(BuildContext context) {
    final PeerData? peerWordList =
        context.watch<MeetKit>().peerData[peer.peerId];
    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 150,
          width: 100,
          child: (peer.videoTrack != null && !peer.videoTrack!.isMute)
              //context.read<MeetKit>().peerTracks[peer.peerId] != null
              ? HMSVideoView(track: peer.videoTrack!
                  // context.read<MeetKit>().peerTracks[peer.peerId]
                  //     as HMSVideoTrack,
                  )
              : const Center(
                  child: Text(
                    "No Video",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              SizedBox(
                height: 15,
                child: Text(
                  peer.name,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              peerWordList != null
                  ? MiniWordBar(
                      word: peerWordList.guessNo > 0
                          ? peerWordList.wordList
                              .elementAt(peerWordList.guessNo - 1)
                          : peerWordList.wordList.first,
                    )
                  : const SizedBox(),

              // TODO: This can be shown on onTap with GestureDetector/InkWell

              // peerWordList != null
              //     ? SizedBox(
              //         height: 100,
              //         child: Column(
              //           children: peerWordList.wordList
              //               .map((word) => MiniWordBar(
              //                     word: word,
              //                   ))
              //               .toList(),
              //         ),
              //       )
              //     : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}

class MiniWordBar extends StatelessWidget {
  const MiniWordBar({required this.word, super.key});
  final Word word;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: word.letters
            .map((letter) => MiniLetterTile(
                  letter: letter,
                ))
            .toList(),
      ),
    );
  }
}

class MiniLetterTile extends StatelessWidget {
  const MiniLetterTile({required this.letter, super.key});

  final Letter letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: letter.status == LetterStatus.correctLetterWithPosition
            ? Colors.green
            : (letter.status == LetterStatus.correctLetter)
                ? Colors.yellow
                : Colors.grey,
      ),
      child: const SizedBox(),
    );
  }
}
