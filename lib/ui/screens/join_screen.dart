import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/logic/game_logic/game_kit.dart';
import 'package:thirdle/logic/meet_logic/meet_kit.dart';
import 'package:thirdle/ui/components/reusable_components/constrained_screen.dart';
import 'package:thirdle/ui/components/reusable_components/thirdle_button.dart';
import 'package:thirdle/ui/components/reusable_components/thirdle_textfield.dart';
import 'package:thirdle/ui/screens/game_screen/game_screen.dart';
import 'package:thirdle/utils/palette.dart';

class JoinScreen extends StatelessWidget {
  JoinScreen({super.key, String? roomId, String? subdomain})
      : nameController = TextEditingController(),
        roomIdController = TextEditingController(text: roomId),
        subdomainController = TextEditingController(text: subdomain);

  final TextEditingController nameController;
  final TextEditingController roomIdController;
  final TextEditingController subdomainController;

  @override
  Widget build(BuildContext context) {
    void startGame({String? name, String? roomId, String? subdomain}) {
      final gameKit = context.read<GameKit>();
      final meetKit = context.read<MeetKit>();

      meetKit.init().whenComplete(
            (() => meetKit.actions
                    .joinRoom(
                      name: name ?? "test_user",
                      room: roomId ?? "62dad79fb1e780e78c39d2cd",
                      subdomain: subdomain ?? "karthikeyan",
                    )
                    .whenComplete(
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider.value(
                                value: gameKit,
                              ),
                              ChangeNotifierProvider.value(
                                value: meetKit,
                              ),
                            ],
                            child: GameScreen(),
                          ),
                        ),
                      ),
                    )
                    .catchError((e) {
                  showToastWidget(
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: Container(
                            height: 40,
                            width: 200,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                            ),
                            child: const Center(
                              child: Text("Some error occurred!",
                                  style: TextStyle(color: Colors.white)),
                            )),
                      ),
                      position: ToastPosition.bottom);
                })),
          );
    }

    return Scaffold(
      backgroundColor: Palette.primaryColor,
      body: ConstrainedScreen(
        onBackPress: () async {
          return true;
        },
        childWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ThirdleTextField(
              key: const Key('name_field'),
              textEditingController: nameController,
              hintText: "Enter your name",
            ),
            ThirdleTextField(
              key: const Key('roomid_field'),
              textEditingController: roomIdController,
              hintText: "<optional> Enter the room id",
            ),
            ThirdleTextField(
              key: const Key('subdomain_field'),
              textEditingController: subdomainController,
              hintText: "<optional> Enter the subdomain",
            ),
            ThirdleButton(
              width: 140,
              height: 45,
              onPressed: () => startGame(
                name: nameController.text.isEmpty ? null : nameController.text,
                roomId: roomIdController.text.isEmpty
                    ? null
                    : roomIdController.text,
                subdomain: subdomainController.text.isEmpty
                    ? null
                    : subdomainController.text,
              ),
              childWidget: Text(
                "Play!",
                style: GoogleFonts.nunito(
                  color: Palette.textWhiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
