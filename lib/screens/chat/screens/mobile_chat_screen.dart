


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../auth/controller/auth_controller.dart';
import '../../../constants/colors.dart';
import '../../../model/user_model.dart';
import '../widgets/bottom_chatffield.dart';
import '../widgets/chat_list.dart';

class ConnectChatPage extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  const ConnectChatPage({
    super.key,
    required this.name,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: textColor,
          title: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDataById(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  snapshot.data!.isOnline
                      ? Text(
                          'online',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                          ),
                        )
                      : Text(
                          'offline',
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: const Color.fromARGB(110, 255, 255, 255)),
                        )
                ],
              );
            },
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.videocam_rounded),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ChatList(
                  reciverUserId: uid,
                ),
              ),
            ),
            BottomChatField(
              reciverUserId: uid,
            ),
          ],
        ),
      ),
    );
  }
}
