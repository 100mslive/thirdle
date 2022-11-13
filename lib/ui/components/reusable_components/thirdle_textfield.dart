import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thirdle/utils/palette.dart';

class ThirdleTextField extends StatefulWidget {
  const ThirdleTextField(
      {super.key, required this.textEditingController, required this.hintText});

  final TextEditingController textEditingController;
  final String hintText;

  @override
  State<ThirdleTextField> createState() => _ThirdleTextFieldState();
}

class _ThirdleTextFieldState extends State<ThirdleTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: 320,
      child: TextField(
        key: widget.key,
        textInputAction: TextInputAction.done,
        style: GoogleFonts.inter(color: Palette.textWhiteColor),
        controller: widget.textEditingController,
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
            focusColor: Palette.secondaryColor,
            contentPadding: const EdgeInsets.only(left: 16),
            fillColor: Palette.cardColor,
            filled: true,
            hintText: widget.hintText,
            hintStyle: GoogleFonts.inter(
                color: Palette.textGreyColor,
                height: 1.5,
                fontSize: 16,
                fontWeight: FontWeight.w400),
            suffixIcon: widget.textEditingController.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      widget.textEditingController.text = "";
                      setState(() {});
                    },
                    icon: const Icon(Icons.clear),
                  ),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Palette.secondaryColor, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)))),
      ),
    );
  }
}
