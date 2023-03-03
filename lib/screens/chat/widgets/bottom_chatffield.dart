import 'dart:io';

import 'package:connect_riverpod/model/message_model.dart';
import 'package:connect_riverpod/utils/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/colors.dart';
import '../controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String reciverUserId;

  const BottomChatField({
    Key? key,
    required this.reciverUserId,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage() async {
    ref.read(chatControllerProvider).sendTextMessage(
        context, _messageController.text.trim(), widget.reciverUserId);

    setState(() {
      _messageController.text = '';
    });
  }

  // void selectFile(
  //   File file,
  //   MessageEnum messageEnum,
  // ) {
  //   ref
  //       .read(chatControllerProvider)
  //       .sendFileMessage(context, file, widget.reciverUserId, messageEnum);
  // }

  // void selectImage() async {
  //   File? image = await pickImageFromGallery(context);
  //   if (image != null) {
  //     selectFile(image, MessageEnum.image);
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: buttonColor,
      ),
      child: Row(
        children: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                FontAwesomeIcons.camera,
                color: scafoldcolor,
                size: 20,
              )),
          IconButton(
              onPressed: (){},
              icon: const Icon(
                FontAwesomeIcons.paperclip,
                color: scafoldcolor,
                size: 20,
              )),
          Expanded(
              child: TextFormField(
            controller: _messageController,
            style: const TextStyle(color: scafoldcolor),
            decoration: InputDecoration(
                prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      FontAwesomeIcons.faceSmile,
                      color: Color.fromARGB(255, 228, 228, 228),
                      size: 20,
                    )),
                fillColor: const Color.fromARGB(81, 158, 158, 158),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none),
                hintText: 'Type your message..',
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 212, 212, 212)),
                contentPadding: const EdgeInsets.only(left: 30),
                filled: true),
          )),
          IconButton(
              onPressed: sendTextMessage,
              icon: const Icon(
                FontAwesomeIcons.paperPlane,
                color: scafoldcolor,
              ))
        ],
      ),
    );
  }
}
