import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_riverpod/utils/common/commonfirebase/common_firebase_storage_repository.dart';
import 'package:connect_riverpod/utils/common/providers/message_reply_provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../model/chat_contact.dart';
import '../../../model/message_model.dart';
import '../../../model/user_model.dart';

import '../../../utils/common/enums/message_enum.dart';
import '../../../utils/common/utils.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String reciverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(reciverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(
          Message.fromMap(
            document.data(),
          ),
        );
      }
      return messages;
    });
  }

  void _saveDataToContactsSubCollection(
    UserModel senderUserData,
    UserModel recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {
    //reciver

    var recieverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          recieverChatContact.toMap(),
        );

    //sender

    var senderChatContact = ChatContact(
      name: recieverUserData.name,
      profilePic: recieverUserData.profilePic,
      contactId: recieverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubCollection({
    required String reciverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required recieverUsername,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUsername,
  }) async {
    final message = Message(
        senderId: auth.currentUser!.uid,
        recieverId: reciverUserId,
        text: text,
        type: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false,
        repliedText: messageReply == null ? '' : messageReply.message,
        repliedTo: messageReply == null
            ? ''
            : messageReply.isMe
                ? senderUsername
                : recieverUsername,
        repliedMessageType:
            messageReply == null ? MessageEnum.text : messageReply.messageEnum);

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(reciverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection('users')
        .doc(reciverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String reciverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;

      var userDataMap =
          await firestore.collection('users').doc(reciverUserId).get();

      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactsSubCollection(
        senderUser,
        recieverUserData,
        text,
        timeSent,
        reciverUserId,
      );

      _saveMessageToMessageSubCollection(
        reciverUserId: reciverUserId,
        messageType: MessageEnum.text,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUser.name,
        recieverUsername: recieverUserData.name,
        messageReply: messageReply,
        senderUsername: senderUser.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required String recieverUserId,
      required UserModel senderUserData,
      required ProviderRef ref,
      required MessageEnum messageEnum,
      required MessageReply ?messageReply}) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      String fileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
              file);
      UserModel recieverUserData;
      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);
      String contactMsg;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '🎥 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🔉 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = '📺 Gif';
          break;
        default:
          contactMsg = '';
      }
      _saveDataToContactsSubCollection(senderUserData, recieverUserData,
          contactMsg, timeSent, recieverUserId);
      _saveMessageToMessageSubCollection(
          reciverUserId: recieverUserId,
          text: fileUrl,
          timeSent: timeSent,
          messageId: messageId,
          username: senderUserData.name,
          recieverUsername: recieverUserData.name,
          messageType: messageEnum,
          messageReply: messageReply,
          senderUsername: senderUserData.name);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void chatSeen(
    BuildContext context,
    String reciverUserId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(reciverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(reciverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
