import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/meet_logic/meet_kit.dart';

class MeetTiles extends StatefulWidget {
  const MeetTiles({super.key});

  @override
  State<MeetTiles> createState() => _MeetTilesState();
}

class _MeetTilesState extends State<MeetTiles> {
  @override
  void initState() {
    context.read<MeetKit>().actions.joinRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: Text(
          "Leave",
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () =>
            context.read<MeetKit>().actions.leaveRoom(context.read<MeetKit>()),
      ),
    );
  }
}
