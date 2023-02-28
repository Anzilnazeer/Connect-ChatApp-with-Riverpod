import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_riverpod/auth/repository/auth_repository.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/colors.dart';
import '../../constants/size.dart';

import '../utils/widgets/custom_button.dart';
import 'landing_page.dart';

class ConnectProfile extends StatefulWidget {
  const ConnectProfile({
    super.key,
  });

  @override
  State<ConnectProfile> createState() => _ConnectProfileState();
}

class _ConnectProfileState extends State<ConnectProfile> {
  final formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (() => FocusScope.of(context).unfocus()),
      child: Scaffold(
        backgroundColor: scafoldcolor,
        appBar: AppBar(
          title: Text(
            'Profile',
            style: GoogleFonts.poppins(color: textColor, fontSize: 25),
          ),
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                FontAwesomeIcons.angleLeft,
                color: buttonColor,
                size: 20,
              )),
          backgroundColor: scafoldcolor,
        ),
        body: Form(
          key: formKey,
          child: SafeArea(
              child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            backgroundImage: FileImage(File(_image!)),
                            radius: 80,
                          )
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(size.height * 0.3),
                            child: CachedNetworkImage(
                              width: size.height * .2,
                              height: size.height * .2,
                              fit: BoxFit.cover,
                              imageUrl: AuthRepository.user!.profilePic,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://static.toiimg.com/thumb/resizemode-4,msid-76729750,imgsize-249247,width-720/76729750.jpg'),
                                radius: 45,
                              ),
                            ),
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(FontAwesomeIcons.pen,
                              size: 30,
                              color: textfieldColor,
                              shadows: const <Shadow>[
                                Shadow(
                                    color: Color.fromARGB(183, 0, 0, 0),
                                    blurRadius: 30.0)
                              ])),
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Container(
                    width: size.width * 0.90,
                    height: size.height / 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: textfieldColor),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: AuthRepository.user!.name,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                              FontAwesomeIcons.user,
                              color: buttonColor,
                            ),
                            border: InputBorder.none,
                            hintText: 'Enter name',
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 143, 143, 143)),
                            filled: false),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  child: Container(
                    width: size.width * 0.90,
                    height: size.height / 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: textfieldColor),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: AuthRepository.user!.phoneNumber,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                              FontAwesomeIcons.circleInfo,
                            ),
                            border: InputBorder.none,
                            hintText: 'About',
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 143, 143, 143)),
                            filled: false),
                      ),
                    ),
                  ),
                ),
                size50,
                // CustomButton(
                //     text: 'UPDATE',
                //     ontap: () {
                //       formKey.currentState!.save();
                //       AuthRepo.updateUserInfo();
                //       CommonFunctions.showSnackBar(
                //           context: context, content: 'user updated');
                //     }),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
