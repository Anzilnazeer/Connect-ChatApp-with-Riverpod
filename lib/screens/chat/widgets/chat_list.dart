// ignore_for_file: depend_on_referenced_packages

import 'package:connect_riverpod/screens/chat/widgets/sender_message.dart';
import 'package:connect_riverpod/utils/common/enums/message_enum.dart';
import 'package:connect_riverpod/utils/common/providers/message_reply_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../model/message_model.dart';
import '../controller/chat_controller.dart';
import 'my_message.dart';

class ChatList extends ConsumerStatefulWidget {
  final String reciverUserId;
  const ChatList({
    super.key,
    required this.reciverUserId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(String message, bool isMe, MessageEnum messageEnum) {
    ref.read(messageReplyProvider.notifier).update((state) =>
        MessageReply(message: message, isMe: isMe, messageEnum: messageEnum));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream:
            ref.read(chatControllerProvider).chatStream(widget.reciverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });
          return ListView.builder(
            controller: messageController,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.jm().format(messageData.timeSent);
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser != null) {
                if (!messageData.isSeen &&
                    messageData.recieverId == currentUser.uid) {
                  ref.read(chatControllerProvider).chatSeen(
                      context, widget.reciverUserId, messageData.messageId);
                }
                if (messageData.senderId == currentUser.uid) {
                  return MyMessage(
                    message: messageData.text,
                    date: timeSent,
                    isSeen: messageData.isSeen,
                    type: messageData.type,
                    replyString: messageData.repliedText,
                    username: messageData.repliedTo,
                    repliedMessageType: messageData.repliedMessageType,
                    onSwipeLeft: () {
                      onMessageSwipe(messageData.text, true, messageData.type);
                    },
                  );
                }
              }

              return SenderMessage(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                username: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                onRightLeft: () {
                  onMessageSwipe(messageData.text, false, messageData.type);
                },
                replyString: messageData.repliedText,
              );
            },
          );
        });
  }
}
