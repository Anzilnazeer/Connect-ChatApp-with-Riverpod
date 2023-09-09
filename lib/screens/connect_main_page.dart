import 'dart:io';

import 'package:connect_riverpod/screens/connect_profile.dart';
import 'package:connect_riverpod/screens/status/screens/confirm_status.dart';
import 'package:connect_riverpod/screens/status/screens/status_contact_screen.dart';
import 'package:connect_riverpod/utils/common/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:im_animations/im_animations.dart';
import '../constants/colors.dart';
import '../auth/controller/auth_controller.dart';
import '../model/chat_contact.dart';
import 'chat/controller/chat_controller.dart';
import 'contact_list.dart';
import 'landing_page.dart';
import 'select_contacts/screens/select_contacts_screen.dart';
import 'connect_calls.dart';

class ConnectMainPage extends ConsumerStatefulWidget {
  static const routeName = '/main-screen';
  const ConnectMainPage({super.key});

  @override
  ConsumerState<ConnectMainPage> createState() => _ConnectMainPageState();
}

class _ConnectMainPageState extends ConsumerState<ConnectMainPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    ref.read(authControllerProvider).getUserData();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
    }
  }

  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            backgroundColor: scafoldcolor,
            appBar: AppBar(
              backgroundColor: scafoldcolor,
              elevation: 0,
              toolbarHeight: 80.h,
              title: Text(
                'ChatEase',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 20.sp,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
              ),
              bottom: TabBar(
                  onTap: (value) {
                    value = tabIndex;
                  },
                  controller: tabBarController,
                  indicatorColor: Colors.transparent,
                  indicatorWeight: 0.1.w,
                  unselectedLabelColor:
                      const Color.fromARGB(168, 173, 225, 255),
                  labelColor: buttonColor,
                  labelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 20.sp),
                  tabs: const [
                    Tab(text: 'Chats'),
                    Tab(text: 'Stories'),
                    Tab(text: 'Calls'),
                  ]),
              actions: [
                Theme(
                  data: ThemeData(
                    popupMenuTheme: PopupMenuThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.w),
                      ),
                    ),
                  ),
                  child: PopupMenuButton(
                    color: buttonColor,
                    icon: const Icon(
                      Icons.more_vert,
                      color: buttonColor,
                    ),
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry>[
                        PopupMenuItem(
                            child: TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ConnectProfile(),
                            ));
                          },
                          icon: const Icon(
                            Icons.person,
                            color: scafoldcolor,
                          ),
                          label: Text(
                            'My Profile',
                            style: GoogleFonts.poppins(
                                color: scafoldcolor, fontSize: 16.sp),
                          ),
                        )),
                        PopupMenuItem(
                            child: TextButton.icon(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut().then((value) {
                              GoogleSignIn().signOut().then((value) {});

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LandingPage(),
                                  ));
                            });
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: scafoldcolor,
                          ),
                          label: Text(
                            'Logout',
                            style: GoogleFonts.poppins(
                                color: scafoldcolor, fontSize: 16.sp),
                          ),
                        )),
                      ];
                    },
                  ),
                )
              ],
            ),
            body: TabBarView(controller: tabBarController, children: const [
              ContactList(),
              StatusContactsScreen(),
              ConnectCalls(),
            ]),
            floatingActionButton: StreamBuilder<List<ChatContact>>(
                stream: ref.watch(chatControllerProvider).chatContacts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: EdgeInsets.all(24.w),
                    child: FloatingActionButton(
                      backgroundColor: floatingbuttonColor,
                      onPressed: () async {
                        if (tabBarController.index == 0) {
                          Navigator.pushNamed(
                              context, SelectContactScreen.routeName);
                        } else {
                          File? pickedImage =
                              await pickImageFromGallery(context);
                          if (pickedImage != null) {
                            Navigator.pushNamed(
                                context, ConfirmStatus.routeName,
                                arguments: pickedImage);
                          }
                        }
                      },
                      child: ColorSonar(
                        innerWaveColor:
                            const Color.fromARGB(239, 181, 210, 223),
                        middleWaveColor:
                            const Color.fromARGB(161, 128, 171, 204),
                        outerWaveColor: const Color.fromARGB(78, 164, 186, 209),
                        contentAreaRadius: 25,
                        waveFall: 7,
                        wavesDisabled: snapshot.data!.isEmpty ? false : true,
                        waveMotionEffect: Curves.linear,
                        waveMotion: WaveMotion.smooth,
                        duration: const Duration(seconds: 2),
                        child: Icon(
                          tabBarController.index == 0
                              ? FontAwesomeIcons.user
                              : FontAwesomeIcons.a,
                          color: floatingbuttonColor,
                        ),
                      ),
                    ),
                  );
                })),
      ),
    );
  }
}
