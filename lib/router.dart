import 'package:connect_riverpod/screens/connect_main_page.dart';
import 'package:connect_riverpod/utils/widgets/error.dart';
import 'package:flutter/material.dart';

import 'auth/screens/login_screen.dart';
import 'auth/screens/otp_screen.dart';
import 'auth/screens/user_information.dart';
import 'screens/chat/screens/mobile_chat_screen.dart';
import 'screens/select_contacts/screens/select_contacts_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginPage.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
    case OTPScreen.routeName:
      final verificationIdn = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationIdn,
        ),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactScreen(),
      );
    case ConnectMainPage.routeName:
      return MaterialPageRoute(
        builder: (context) => const ConnectMainPage(),
      );
    case ConnectChatPage.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
        builder: (context) => ConnectChatPage(
          name: name,
          uid: uid,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: ''),
        ),
      );
  }
}
