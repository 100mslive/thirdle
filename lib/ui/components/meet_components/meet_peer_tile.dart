import 'dart:math';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/logic/game_logic/models/letter_model.dart';
import 'package:thirdle/logic/game_logic/models/word_model.dart';
import 'package:thirdle/logic/meet_logic/meet_kit.dart';
import 'package:thirdle/logic/meet_logic/models/peer_data_model.dart';
import 'package:thirdle/utils/palette.dart';

class MeetPeerTile extends StatefulWidget {
  const MeetPeerTile({required this.peer, super.key});
  final HMSPeer peer;

  @override
  State<MeetPeerTile> createState() => _MeetPeerTileState();
}

class _MeetPeerTileState extends State<MeetPeerTile> {
  bool isExpanded = false;
  final controller = ConfettiController();
  bool isPlaying = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meetKit = context.watch<MeetKit>();

    final PeerData? peerWordList = meetKit.peerData[widget.peer.peerId];

    if (peerWordList != null) {
      final latestWord = peerWordList.guessNo > 0
          ? peerWordList.wordList.elementAt(peerWordList.guessNo - 1)
          : peerWordList.wordList.first;

      bool flag = true;
      for (var letter in latestWord.letters) {
        if (letter.status != LetterStatus.correctLetterWithPosition) {
          flag = false;
          break;
        }
      }
      if (flag) {
        controller.play();
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: <BoxShadow>[
            const BoxShadow(
              color: Palette.secondaryColor,
              offset: Offset(0, 0.5),
            ),
            BoxShadow(
              color: Palette.secondaryColor.withOpacity(0.6),
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
                          color: Palette.primaryColor.withOpacity(0.5)),
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
                                    .map((word) =>
                                        MiniColoredWordBar(word: word))
                                    .toList()
                              else
                                MiniColoredWordBar(
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
            Positioned(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: controller,
                  shouldLoop: true,
                  blastDirection: -pi / 2,
                  emissionFrequency: 0.01,
                  numberOfParticles: 20,
                  maxBlastForce: 100,
                  minBlastForce: 80,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MiniColoredWordBar extends StatelessWidget {
  const MiniColoredWordBar({required this.word, super.key});
  final Word word;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: word.letters
            .map((letter) => MiniColoredLetterTile(
                  letter: letter,
                ))
            .toList(),
      ),
    );
  }
}

class MiniColoredLetterTile extends StatelessWidget {
  const MiniColoredLetterTile({required this.letter, super.key});

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
            ? Palette.wordleLetterTileEmptyColor
            : (letter.status == LetterStatus.correctLetterWithPosition
                ? Palette.wordleLetterTileGreenColor
                : (letter.status == LetterStatus.correctLetter)
                    ? Palette.wordleLetterTileYellowColor
                    : Colors.white),
      ),
      child: const SizedBox(),
    );
  }
}
