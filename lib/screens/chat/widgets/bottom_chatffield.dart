import 'dart:io';

import 'package:connect_riverpod/model/message_model.dart';
import 'package:connect_riverpod/utils/common/utils.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constants/colors.dart';
import '../../../utils/common/enums/message_enum.dart';
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
  bool isShowSendButton = false;
  bool isShowEmoji = false;
  bool isRecorderInit = false;
  bool isRecording = false;
  FocusNode focusnode = FocusNode();
  FlutterSoundRecorder? soundRecorder;
  bool isAudio = true;

  @override
  void initState() {
    super.initState();
    soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed');
    }
    await soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
          context, _messageController.text.trim(), widget.reciverUserId);

      setState(() {
        _messageController.text = '';
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await soundRecorder!.startRecorder(toFile: path);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, widget.reciverUserId, messageEnum);
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void hideEmoji() {
    setState(() {
      isShowEmoji = false;
    });
  }

  void showEmoji() {
    setState(() {
      isShowEmoji = true;
    });
  }

  void showKeyboard() {
    focusnode.requestFocus();
  }

  void hideKeyboard() {
    focusnode.unfocus();
  }

  void toggleEmojiContainer() {
    if (isShowEmoji) {
      showKeyboard();
      hideEmoji();
    } else {
      hideKeyboard();
      showEmoji();
    }
  }

  void audioButton() {
    if (_messageController.text.isEmpty) {
      setState(() {
        isAudio = false;
      });
    } else {
      setState(() {
        isAudio = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 65,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 22, 54, 83),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      selectImage();
                    },
                    icon: const Icon(
                      FontAwesomeIcons.camera,
                      color: buttonColor,
                      size: 20,
                    )),
                IconButton(
                    onPressed: () {
                      selectVideo();
                    },
                    icon: const Icon(
                      FontAwesomeIcons.paperclip,
                      color: buttonColor,
                      size: 20,
                    )),
                Expanded(
                    child: TextFormField(
                  enableInteractiveSelection: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  focusNode: focusnode,
                  controller: _messageController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    } else {
                      setState(() {
                        isShowSendButton = false;
                      });
                    }
                  },
                  style: const TextStyle(color: scafoldcolor),
                  decoration: InputDecoration(
                      prefixIcon: IconButton(
                          onPressed: () {
                            toggleEmojiContainer();
                          },
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
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 212, 212, 212)),
                      contentPadding: const EdgeInsets.only(left: 30),
                      filled: true),
                )),
                IconButton(
                    onPressed: sendTextMessage,
                    icon: Icon(
                      isShowSendButton
                          ? FontAwesomeIcons.paperPlane
                          : isRecording
                              ? FontAwesomeIcons.xmark
                              : FontAwesomeIcons.microphone,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ),
        Visibility(
          visible: isShowEmoji,
          child: SizedBox(
            height: 310,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                setState(() => _messageController.text += emoji.emoji);
              },
            ),
          ),
        ),
      ],
    );
  }
}
