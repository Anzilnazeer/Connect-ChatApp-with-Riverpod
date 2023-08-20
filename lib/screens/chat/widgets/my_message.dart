import 'package:connect_riverpod/constants/colors.dart';
import 'package:connect_riverpod/screens/chat/widgets/display_file.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../utils/common/enums/message_enum.dart';

class MyMessage extends StatelessWidget {
  final String message;
  final String date;
  final bool isSeen;
  final MessageEnum type;
  const MyMessage(
      {super.key,
      required this.message,
      required this.date,
      required this.isSeen,
      required this.type});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 330.w, maxHeight: 500.h),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.w),
          ),
          color: const Color.fromARGB(255, 221, 221, 221),
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
          child: Stack(children: [
            Padding(
                padding: type == MessageEnum.text
                    ? EdgeInsets.symmetric(vertical: 15.h, horizontal: 25.w)
                    : type == MessageEnum.image
                        ? EdgeInsets.only(bottom: 15.w, top: 15.w)
                        : type == MessageEnum.video
                            ? EdgeInsets.only(bottom: 15.w, top: 15.w)
                            : EdgeInsets.symmetric(
                                vertical: 15.h, horizontal: 15.w),
                child: DisplayFile(
                  message: message,
                  type: type,
                  color: messageColor,
                  activeColor: scafoldcolor,
                )),
            Positioned(
              bottom: 3,
              right: 3,
              child: Row(
                children: [
                  Text(
                    date,
                    style: TextStyle(color: messageColor, fontSize: 10.sp),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Icon(
                    isSeen ? Icons.done_all_rounded : Icons.check,
                    color: isSeen
                        ? Colors.blue
                        : const Color.fromARGB(164, 0, 0, 0),
                    size: 11,
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
