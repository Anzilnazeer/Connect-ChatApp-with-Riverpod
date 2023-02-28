import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/colors.dart';
import '../constants/size.dart';
import '../utils/widgets/custom_button.dart';
import '../auth/screens/login_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scafoldcolor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              size50,
              Center(
                child: Text(
                  'Hello There!',
                  style: GoogleFonts.oswald(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
              ),
              size10,
              Center(
                child: Text(
                  'Welcome back to connect , you\'ve been missed',
                  style: TextStyle(
                    fontSize: size.width * 0.0354,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Stack(
                children: [
                  Column(
                    children: [
                      const Icon(
                        FontAwesomeIcons.gg,
                        color: buttonColor,
                        size: 200,
                      ),
                      Text(
                        'connect',
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 50,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
              ),
              const Text(
                'Read our Privacy Policy.Tap "Agree and connect" to accept the "Terms of Services."',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
              size10,
              CustomButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginPage.routeName);
                },
                text: 'AGREE AND CONNECT',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
