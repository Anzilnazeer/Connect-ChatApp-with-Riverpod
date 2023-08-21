// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:connect_riverpod/utils/common/enums/message_enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReply {
  final String message;
  bool isMe;
  final MessageEnum messageEnum;
  MessageReply({
    required this.message,
    required this.isMe,
    required this.messageEnum,
  });
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);
