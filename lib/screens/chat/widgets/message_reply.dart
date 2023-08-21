import 'package:connect_riverpod/screens/chat/widgets/display_file.dart';
import 'package:connect_riverpod/utils/common/enums/message_enum.dart';
import 'package:connect_riverpod/utils/common/providers/message_reply_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});
  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 10.h),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 21, 21, 21),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                messageReply!.isMe ? 'You' : 'Opposite',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600),
              )),
              GestureDetector(
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onTap: () {
                  cancelReply(ref);
                },
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (messageReply.messageEnum == MessageEnum.image)
            SizedBox(
              height: 150.h,
              child: DisplayFile(
                message: messageReply.message,
                type: messageReply.messageEnum,
              ),
            )
          else
            DisplayFile(
              message: messageReply.message,
              type: messageReply.messageEnum,
            ),
        ],
      ),
    );
  }
}
