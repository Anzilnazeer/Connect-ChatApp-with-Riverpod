import 'package:connect_riverpod/constants/colors.dart';
import 'package:connect_riverpod/utils/common/enums/message_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'display_file.dart';

class SenderMessage extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  const SenderMessage(
      {super.key,
      required this.message,
      required this.date,
      required this.type});

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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: const Color.fromARGB(255, 101, 103, 104),
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
          child: Stack(children: [
            Padding(
                padding: type == MessageEnum.text
                    ? EdgeInsets.symmetric(vertical: 15.h, horizontal: 25.w)
                    : EdgeInsets.symmetric(
                        vertical: size.height / 55,
                        horizontal: size.width / 50),
                child: DisplayFile(
                  message: message,
                  type: type,
                  color: Colors.white,
                )),
            Positioned(
              bottom: 3,
              right: 2,
              child: Row(
                children: [
                  Text(
                    date,
                    style: TextStyle(color: Colors.white, fontSize: 10.sp),
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
