import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/game_logic/models/letter_model.dart';
import 'package:thirdle/game_logic/models/word_model.dart';
import 'package:thirdle/meet_logic/meet_kit.dart';

class PeerTile extends StatelessWidget {
  const PeerTile({required this.peer, super.key});
  final HMSPeer peer;
  @override
  Widget build(BuildContext context) {
    final List<Word>? peerWordList =
        context.watch<MeetKit>().peerWords[peer.peerId];
    return SizedBox(
      width: 150,
      child: Column(
        children: [
          Expanded(
            child: context.read<MeetKit>().peerTracks[peer.peerId] != null
                ? HMSVideoView(
                    track: context.read<MeetKit>().peerTracks[peer.peerId]
                        as HMSVideoTrack)
                : const Center(
                    child: Text("No Video"),
                  ),
          ),
          Text(
            peer.peerId,
            style: const TextStyle(fontSize: 10),
          ),
          peerWordList != null
              ? Column(
                  children: peerWordList
                      .map((word) => MiniWordBar(
                            word: word,
                          ))
                      .toList(),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class MiniWordBar extends StatelessWidget {
  const MiniWordBar({required this.word, super.key});
  final Word word;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      height: 5,
      width: 5,
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
