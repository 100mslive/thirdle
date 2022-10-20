import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/constants/colors.dart';
import 'package:thirdle/game_logic/models/letter_model.dart';
import 'package:thirdle/game_logic/models/word_model.dart';
import 'package:thirdle/meet_logic/meet_kit.dart';
import 'package:thirdle/meet_logic/models/peer_data.dart';

class PeerTile extends StatefulWidget {
  const PeerTile({required this.peer, super.key});
  final HMSPeer peer;

  @override
  State<PeerTile> createState() => _PeerTileState();
}

class _PeerTileState extends State<PeerTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final PeerData? peerWordList =
        context.watch<MeetKit>().peerData[widget.peer.peerId];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: kSecondaryHMSColor,
              offset: const Offset(0, 0.5),
            ),
            BoxShadow(
              color: kSecondaryHMSColor.withOpacity(0.6),
              blurRadius: 10.0,
              blurStyle: BlurStyle.normal,
              offset: const Offset(4, 2),
            ),
          ]),
      clipBehavior: Clip.antiAlias,
      height: 135,
      child: InkWell(
        onTap: (() {
          setState(() {
            isExpanded = !isExpanded;
          });
        }),
        child: Stack(
          fit: StackFit.passthrough,
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: 135,
              width: 100,
              child: (widget.peer.videoTrack != null &&
                      !widget.peer.videoTrack!.isMute)
                  ? HMSVideoView(track: widget.peer.videoTrack!)
                  : const Center(
                      child: Text(
                        "No Video",
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                    child: Container(
                      height: isExpanded ? 110 : 42,
                      width: 100,
                      decoration: BoxDecoration(
                          color: kPrimaryHMSColor.withOpacity(0.5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                              child: Text(
                                widget.peer.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (peerWordList != null)
                              if (isExpanded)
                                ...peerWordList.wordList
                                    .map((word) => MiniWordBar(word: word))
                                    .toList()
                              else
                                MiniWordBar(
                                  word: peerWordList.guessNo > 0
                                      ? peerWordList.wordList
                                          .elementAt(peerWordList.guessNo - 1)
                                      : peerWordList.wordList.first,
                                )
                            else
                              const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
        borderRadius: BorderRadius.circular(8),
        color: letter.value == ''
            ? kLetterEmptyColor
            : (letter.status == LetterStatus.correctLetterWithPosition
                ? kLetterGreenColor
                : (letter.status == LetterStatus.correctLetter)
                    ? kLetterYellowColor
                    : kLetterGreyColor),
      ),
      child: const SizedBox(),
    );
  }
}
