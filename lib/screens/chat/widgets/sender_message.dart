import 'package:connect_riverpod/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SenderMessage extends StatelessWidget {
  final String message;
  final String date;
  const SenderMessage({super.key, required this.message, required this.date});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
        child: Card(
          elevation: 5,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )),
          color: sendersColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.height / 55, horizontal: size.width / 20),
              child: Text(
                message,
                style: GoogleFonts.poppins(color: messageColor, fontSize: 15),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 2,
              child: Row(
                children: [
                  Text(
                    date,
                    style: const TextStyle(color: messageColor, fontSize: 10),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
