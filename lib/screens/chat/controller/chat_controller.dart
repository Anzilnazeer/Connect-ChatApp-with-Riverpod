import 'dart:io';

import 'package:connect_riverpod/utils/common/enums/message_enum.dart';
import 'package:connect_riverpod/utils/common/providers/message_reply_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/controller/auth_controller.dart';
import '../../../model/chat_contact.dart';
import '../../../model/message_model.dart';

import '../repository/chat_repository.dart';

final chatControllerProvider = Provider(
  (ref) {
    final chatRepository = ref.watch(chatRepositoryProvider);
    return ChatController(chatRepository: chatRepository, ref: ref);
  },
);

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String reciverUserId) {
    return chatRepository.getChatStream(reciverUserId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverId,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
              context: context,
              text: text,
              reciverUserId: recieverId,
              senderUser: value!,
              messageReply: messageReply),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendFileMessage(BuildContext context, File file, String recieverId,
      MessageEnum messageEnum) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
              context: context,
              file: file,
              recieverUserId: recieverId,
              senderUserData: value!,
              messageEnum: messageEnum,
              messageReply: messageReply,
              ref: ref),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void chatSeen(
    BuildContext context,
    String reciverUserId,
    String messageId,
  ) {
    chatRepository.chatSeen(
      context,
      reciverUserId,
      messageId,
    );
  }
}
