import 'package:connect_riverpod/constants/colors.dart';
import 'package:connect_riverpod/constants/size.dart';
import 'package:connect_riverpod/screens/chat/widgets/display_file.dart';
import 'package:connect_riverpod/utils/common/providers/message_reply_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../utils/common/enums/message_enum.dart';

class MyMessage extends StatelessWidget {
  final String message;
  final String date;
  final bool isSeen;
  final MessageEnum type;
  final VoidCallback onSwipeLeft;
  final String replyString;
  final String username;
  final MessageEnum repliedMessageType;
  const MyMessage(
      {super.key,
      required this.message,
      required this.date,
      required this.isSeen,
      required this.type,
      required this.onSwipeLeft,
      required this.replyString,
      required this.username,
      required this.repliedMessageType});

  @override
  Widget build(BuildContext context) {
    final isreplying = replyString.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: onSwipeLeft,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300.w, minWidth: 130.w),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.w),
              topRight: Radius.circular(10.w),
              bottomLeft: Radius.circular(10.w),
            )),
            color: const Color.fromARGB(255, 36, 109, 146),
            margin: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
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
                          color: const Color.fromARGB(255, 44, 81, 96),
                          borderRadius: BorderRadius.circular(10.w),
                          border: Border.all(
                              color: const Color.fromARGB(255, 98, 136, 163)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Replying to $username',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            DisplayFile(
                              message: replyString,
                              type: repliedMessageType,
                              color: Colors.white,
                              activeColor: scafoldcolor,
                            ),
                          ],
                        ),
                      ),
                    ],
                    DisplayFile(
                      message: message,
                      type: type,
                      color: Colors.white,
                      activeColor: scafoldcolor,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 1,
                right: 3,
                child: Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(color: Colors.white, fontSize: 10.sp),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Icon(
                      isSeen ? Icons.done_all_rounded : Icons.check,
                      color: isSeen
                          ? const Color.fromARGB(255, 106, 248, 255)
                          : const Color.fromARGB(163, 255, 255, 255),
                      size: 11,
                    )
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
