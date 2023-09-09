import 'dart:io';

import 'package:connect_riverpod/constants/colors.dart';
import 'package:connect_riverpod/screens/status/controller/status_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmStatus extends ConsumerWidget {
  static const routeName = '/ConfirmStatus';
  final File file;
  const ConfirmStatus(this.file, {super.key});
  void addStory(WidgetRef ref, BuildContext context) {
    ref.read(statusControllerProvider).addStatus(file, context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: scafoldcolor,
      body: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 9 / 16,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ClipRRect(
                  child: Image.file(
                    file,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            CircleAvatar(
              radius: 25.w,
              child: IconButton(
                onPressed: () {
                  addStory(ref, context);
                },
                icon: const Icon(Icons.check, color: scafoldcolor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
