import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/logic/meet_logic/meet_kit.dart';
import 'package:thirdle/ui/components/reusable_components/constrained_screen_wrapper.dart';
import 'package:thirdle/ui/components/reusable_components/the_button.dart';
import 'package:thirdle/ui/components/reusable_components/the_textfield.dart';
import 'package:thirdle/ui/screens/play_screen/play_screen.dart';
import 'package:thirdle/utils/constants.dart';
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
    void startGame(
        {required String name,
        required String roomId,
        required String subdomain}) {
      final meetKit = context.read<MeetKit>();

      meetKit.init().whenComplete(
            (() => meetKit.actions
                    .joinRoom(
                      name: name.isNotEmpty ? name : Constants.name,
                      roomId: roomId.isNotEmpty ? roomId : Constants.roomId,
                      subdomain: subdomain.isNotEmpty
                          ? subdomain
                          : Constants.subdomain,
                    )
                    .whenComplete(
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlayScreen(),
                        ),
                      ),
                    )
                    .catchError(
                  (e) {
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
                          ),
                        ),
                      ),
                      position: ToastPosition.bottom,
                    );
                  },
                )),
          );
    }

    return Scaffold(
      backgroundColor: Palette.primaryColor,
      body: ConstrainedScreenWrapper(
        onBackPress: () async {
          return true;
        },
        childWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TheTextField(
              key: const Key('name_field'),
              textEditingController: nameController,
              hintText: "Enter your name",
            ),
            TheTextField(
              key: const Key('roomid_field'),
              textEditingController: roomIdController,
              hintText: "<optional> Enter the room id",
            ),
            TheTextField(
              key: const Key('subdomain_field'),
              textEditingController: subdomainController,
              hintText: "<optional> Enter the subdomain",
            ),
            TheButton(
              width: 140,
              height: 45,
              onPressed: () => startGame(
                name: nameController.text,
                roomId: roomIdController.text,
                subdomain: subdomainController.text,
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
