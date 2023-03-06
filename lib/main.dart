import 'package:connect_riverpod/constants/colors.dart';
import 'package:connect_riverpod/firebase_options.dart';
import 'package:connect_riverpod/router.dart';
import 'package:connect_riverpod/screens/connect_main_page.dart';
import 'package:connect_riverpod/utils/widgets/error.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'auth/controller/auth_controller.dart';
import 'screens/landing_page.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'connect',
      theme: ThemeData(primaryColor: textColor),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingPage();
              }
              return const ConnectMainPage();
            },
            error: (err, trace) {
              return ErrorScreen(error: err.toString());
            },
            loading: () => Container(
              color: scafoldcolor,
              child: Center(
                child: LoadingAnimationWidget.flickr(
                  leftDotColor: messageColor,
                  rightDotColor: sendersColor,
                  size: 80,
                ),
              ),
            ),
          ),
    );
  }
}
