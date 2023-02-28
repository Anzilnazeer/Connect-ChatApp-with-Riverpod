import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../../constants/colors.dart';
import '../../utils/common/utils.dart';
import '../controller/auth_controller.dart';


class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
            context,
            name,
            image,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(
                            'https://static.toiimg.com/thumb/resizemode-4,msid-76729750,imgsize-249247,width-720/76729750.jpg'),
                      )
                    : CircleAvatar(
                        radius: 80, backgroundImage: FileImage(image!)),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                      onPressed: () {
                        selectImage();
                      },
                      icon: Icon(FontAwesomeIcons.cameraRetro,
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
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Container(
                width: size.width * 0.90,
                height: size.height / 15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: textfieldColor),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 143, 143, 143)),
                        filled: false),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            //   child: Container(
            //     width: size.width * 0.90,
            //     height: size.height / 15,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         color: textfieldColor),
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: TextFormField(
            //         controller: aboutController,
            //         style: const TextStyle(color: Colors.black),
            //         decoration: const InputDecoration(
            //             border: InputBorder.none,
            //             hintText: 'About',
            //             hintStyle: TextStyle(
            //                 color: Color.fromARGB(255, 143, 143, 143)),
            //             filled: false),
            //       ),
            //     ),
            //   ),
            // ),
            IconButton(
                onPressed: () {
                  storeUserData();
                },
                icon: const Icon(
                  FontAwesomeIcons.check,
                  color: textColor,
                ))
          ],
        ),
      )),
    );
  }
}
