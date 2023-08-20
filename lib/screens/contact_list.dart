import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_riverpod/constants/size.dart';
import 'package:connect_riverpod/utils/common/skeletons/contact_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:connect_riverpod/constants/colors.dart';

import '../auth/repository/auth_repository.dart';
import '../model/chat_contact.dart';
import 'chat/controller/chat_controller.dart';
import 'chat/screens/mobile_chat_screen.dart';

class ContactList extends ConsumerWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: 200.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.w),
              topRight: Radius.circular(30.w),
            ),
            color: textColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                size10,
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text('Stories'),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: 100.h, // Adjust the height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 5, // Adjust the item count as needed
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 32.w,
                              child: const Icon(Icons.person),
                            ),
                            const Text('Angel'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          top: 150.h,
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 215, 247, 253),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.w),
                  topRight: Radius.circular(30.w)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: StreamBuilder<List<ChatContact>>(
                    stream: ref.watch(chatControllerProvider).chatContacts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return const ContactSkeleton(
                                isCircularImage: true,
                                isBottomLinesActive: true);
                          },
                        );
                      }
                      if (snapshot.data!.isNotEmpty) {
                        return ListView.separated(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const Divider(
                              color: Colors.black,
                              thickness: 2,
                            );
                          },
                          itemBuilder: (context, index) {
                            var chatContactData = snapshot.data![index];

                            return Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Card(
                                  color:
                                      const Color.fromARGB(34, 255, 255, 255),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.01,
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
                                    leading: chatContactData.profilePic == ''
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                size.height * 0.1),
                                            child: CachedNetworkImage(
                                              width: size.height * .07,
                                              fit: BoxFit.cover,
                                              imageUrl: AuthRepository
                                                  .user!.profilePic,
                                              placeholder: (context, url) =>
                                                  LoadingAnimationWidget
                                                      .discreteCircle(
                                                          color: messageColor,
                                                          size: 90),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    'https://static.toiimg.com/thumb/resizemode-4,msid-76729750,imgsize-249247,width-720/76729750.jpg'),
                                                radius: 45,
                                              ),
                                            ),
                                          )
                                        : const CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                'https://static.toiimg.com/thumb/resizemode-4,msid-76729750,imgsize-249247,width-720/76729750.jpg'),
                                            radius: 25,
                                          ),
                                    title: Text(
                                      chatContactData.name,
                                      style:
                                          GoogleFonts.poppins(letterSpacing: 2),
                                    ),
                                    subtitle: Text(
                                      chatContactData.lastMessage,
                                      maxLines: 1,
                                    ),
                                    trailing: Text(DateFormat.jm()
                                        .format(chatContactData.timeSent)),
                                  )),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            'No connections yet',
                            style: GoogleFonts.poppins(
                                letterSpacing: 2, fontSize: 20),
                          ),
                        );
                      }
                    }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
