import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_riverpod/screens/connect_profile.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/colors.dart';
import '../auth/controller/auth_controller.dart';
import '../auth/repository/auth_repository.dart';

import 'contact_list.dart';
import 'landing_page.dart';
import 'select_contacts/screens/select_contacts_screen.dart';
import 'connect_calls.dart';
import 'connect_status.dart';

class ConnectMainPage extends ConsumerStatefulWidget {
  static const routeName = '/main-screen';
  const ConnectMainPage({super.key});

  @override
  ConsumerState<ConnectMainPage> createState() => _ConnectMainPageState();
}

class _ConnectMainPageState extends ConsumerState<ConnectMainPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
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
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 3,
        child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: scafoldcolor,
              appBar: AppBar(
                leading: const Icon(
                  FontAwesomeIcons.gg,
                  color: buttonColor,
                  size: 40,
                ),
                backgroundColor: scafoldcolor,
                elevation: 0,
                toolbarHeight: 80,
                title: Text(
                  'connect',
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 25,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
                bottom: TabBar(
                    onTap: (value) {
                      setState(() {
                        value = tabIndex;
                      });
                    },
                    indicatorColor: buttonColor,
                    indicatorWeight: 3,
                    unselectedLabelColor: Colors.grey,
                    labelColor: buttonColor,
                    labelStyle:
                        GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    tabs: const [
                      Tab(text: 'CHATS'),
                      Tab(text: 'STATUS'),
                      Tab(text: 'CALLS'),
                    ]),
                actions: [
                  Theme(
                    data: ThemeData(
                      popupMenuTheme: PopupMenuThemeData(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
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
                                  color: scafoldcolor, fontSize: 16),
                            ),
                          )),
                          PopupMenuItem(
                              child: TextButton.icon(
                            onPressed: () async {
                              await FirebaseAuth.instance
                                  .signOut()
                                  .then((value) {
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
                                  color: scafoldcolor, fontSize: 16),
                            ),
                          )),
                        ];
                      },
                    ),
                  )
                ],
              ),
              body: const TabBarView(children: [
                ContactList(),
                ConnectStatus(),
                ConnectCalls(),
              ]),
              floatingActionButton: FloatingActionButton(
                backgroundColor: floatingbuttonColor,
                onPressed: () {
                  Navigator.pushNamed(context, SelectContactScreen.routeName);
                },
                child: const Icon(
                  FontAwesomeIcons.user,
                  color: textColor,
                ),
              ),
            )));
  }
}
