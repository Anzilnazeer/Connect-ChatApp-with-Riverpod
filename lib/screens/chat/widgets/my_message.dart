import 'package:connect_riverpod/constants/colors.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class MyMessage extends StatelessWidget {
  final String message;
  final String date;
  final bool isSeen;
  // final MessageEnum type;
  const MyMessage(
      {super.key,
      required this.message,
      required this.date,
      required this.isSeen
      // required this.type
      });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
        child: Card(
          elevation: 5,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15))),
          color: messageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(children: [
            Padding(
                padding: EdgeInsets.symmetric(
                    vertical: size.height / 55, horizontal: size.width / 20),
                child: Text(
                  message,
                  style: GoogleFonts.poppins(color: sendersColor, fontSize: 15),
                )),
            Positioned(
              bottom: 3,
              right: 3,
              child: Row(
                children: [
                  Text(
                    date,
                    style: TextStyle(color: textfieldColor, fontSize: 10),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Icon(
                    isSeen
                        ? FontAwesomeIcons.checkDouble
                        : FontAwesomeIcons.check,
                    color: isSeen ? sendersColor : textfieldColor,
                    size: 10,
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
