import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../model/chat_contact.dart';

import 'chat/controller/chat_controller.dart';
import 'chat/screens/mobile_chat_screen.dart';

class ContactList extends ConsumerWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: StreamBuilder<List<ChatContact>>(
            stream: ref.watch(chatControllerProvider).chatContacts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var chatContactData = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Card(
                        color: const Color.fromARGB(35, 48, 136, 244),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02,
                        ),
                        child: ListTile(
                          onLongPress: () {},
                          onTap: () {
                            Navigator.pushNamed(
                                context, ConnectChatPage.routeName,
                                arguments: {
                                  'name': chatContactData.name,
                                  'uid': chatContactData.contactId,
                                });
                          },
                          leading: chatContactData.profilePic.isEmpty
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(chatContactData.profilePic),
                                  radius: 25,
                                )
                              : const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://static.toiimg.com/thumb/resizemode-4,msid-76729750,imgsize-249247,width-720/76729750.jpg'),
                                  radius: 25,
                                ),
                          title: Text(
                            chatContactData.name,
                            style: GoogleFonts.poppins(letterSpacing: 2),
                          ),
                          subtitle: Text(chatContactData.lastMessage),
                          trailing: Text(
                              DateFormat.Hm().format(chatContactData.timeSent)),
                        )),
                  );
                },
              );
            }),
      ),
    );
  }
}
