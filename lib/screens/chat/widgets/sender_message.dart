import 'package:connect_riverpod/constants/colors.dart';
import 'package:connect_riverpod/utils/common/enums/message_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:swipe_to/swipe_to.dart';

import 'display_file.dart';

class SenderMessage extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightLeft;
  final String replyString;
  final String username;
  final MessageEnum repliedMessageType;
  const SenderMessage(
      {super.key,
      required this.message,
      required this.date,
      required this.type,
      required this.onRightLeft,
      required this.replyString,
      required this.username,
      required this.repliedMessageType});

  @override
  Widget build(BuildContext context) {
    final isreplying = replyString.isNotEmpty;
    return SwipeTo(
      onRightSwipe: () {
        onRightLeft();
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300.w, minWidth: 130.w),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.w),
              topRight: Radius.circular(10.w),
              bottomRight: Radius.circular(10.w),
            )),
            color: const Color.fromARGB(255, 238, 238, 238),
            margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            child: Stack(children: [
              Padding(
                padding: type == MessageEnum.text
                    ? EdgeInsets.symmetric(vertical: 13.h, horizontal: 25.w)
                    : type == MessageEnum.image
                        ? EdgeInsets.only(bottom: 15.w, top: 15.w)
                        : type == MessageEnum.video
                            ? EdgeInsets.only(bottom: 15.w, top: 15.w)
                            : EdgeInsets.symmetric(
                                vertical: 15.h, horizontal: 15.w),
                child: Column(
                  children: [
                    if (isreplying) ...[
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10.w),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Replying to $username',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            DisplayFile(
                              message: replyString,
                              type: repliedMessageType,
                              color: messageColor,
                              activeColor: scafoldcolor,
                            ),
                          ],
                        ),
                      ),
                    ],
                    DisplayFile(
                      message: message,
                      type: type,
                      color: messageColor,
                      activeColor: scafoldcolor,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 1,
                right: 1,
                child: Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(color: messageColor, fontSize: 10.sp),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
