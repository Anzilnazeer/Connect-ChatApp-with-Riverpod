
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';


import '../../utils/widgets/custom_button.dart';
import '../controller/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final phoneController = TextEditingController();
  Country? country;

  void googleSignIn() {
    ref.read(authControllerProvider).googleSignIn();
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .siginInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scafoldcolor,
      appBar: AppBar(
        backgroundColor: scafoldcolor,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          'Enter Phone Number To Connect',
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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Center(
                  child: Text(
                    'Verify your phone number to connect',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: textColor,
                    ),
                  ),
                ),
                TextButton(
                    onPressed: pickCountry,
                    child: country != null
                        ? Text(
                            'Pick Country(${country!.name})',
                            style: GoogleFonts.poppins(),
                          )
                        : Text(
                            'Pick Country',
                            style: GoogleFonts.poppins(),
                          )),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      country != null
                          ? Text(
                              '+ ${country!.phoneCode}',
                              style: GoogleFonts.aBeeZee(
                                fontSize: 16,
                                color: textColor,
                              ),
                            )
                          : Text(
                              '+91',
                              style: GoogleFonts.aBeeZee(
                                fontSize: 16,
                                color: const Color.fromARGB(43, 0, 0, 0),
                              ),
                            ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 3,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                                fillColor:
                                    const Color.fromARGB(81, 158, 158, 158),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide()),
                                hintText: 'phone number with countrycode.',
                                hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 143, 143, 143)),
                                contentPadding: const EdgeInsets.only(left: 30),
                                filled: true),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 30),
                //   child: GestureDetector(
                //     onTap: () {},
                //     child: Container(
                //         padding: const EdgeInsets.all(15),
                //         decoration: BoxDecoration(
                //             color: buttonColor,
                //             borderRadius: BorderRadius.circular(10)),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //           children: [
                //             const Icon(
                //               FontAwesomeIcons.google,
                //               color: scafoldcolor,
                //               size: 23,
                //             ),
                //             Text(
                //               'Sign in with Google',
                //               style: GoogleFonts.poppins(
                //                   fontSize: 23, color: scafoldcolor),
                //             )
                //           ],
                //         )),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: 'Next',
                    onPressed: sendPhoneNumber,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
