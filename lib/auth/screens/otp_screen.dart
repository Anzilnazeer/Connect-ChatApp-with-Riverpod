import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';



import '../../constants/colors.dart';
import '../controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  final String verificationId;
  const OTPScreen({
    super.key,
    required this.verificationId,
  });
  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref.read(authControllerProvider).verifyOTP(
          context,
          verificationId,
          userOTP,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: scafoldcolor,
          elevation: 0,
          toolbarHeight: 80,
          title: Text(
            'Enter Your OTP To Verify',
            style: GoogleFonts.poppins(
                fontSize: 15, color: textColor, fontWeight: FontWeight.bold),
          ),
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    FontAwesomeIcons.angleLeft,
                    color: buttonColor,
                    size: 20,
                  )),
            ],
          ),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            children: [
              Center(
                child: Text(
                  'We have sent an OTP to your phone number',
                  style: GoogleFonts.poppins(
                    fontSize: size.width * .032,
                    color: textColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  width: size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Color.fromARGB(255, 17, 152, 87),
                            ),
                          ),
                          hintText: '- - - - - -',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 143, 143, 143),
                              fontSize: 30),
                          filled: true),
                      onChanged: (value) {
                        if (value.length == 6) {
                          verifyOTP(ref, context, value.trim());
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ]));
  }
}
