// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:connect_riverpod/auth/controller/auth_controller.dart';
import 'package:connect_riverpod/model/status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:connect_riverpod/screens/status/repository/status_repository.dart';

final statusControllerProvider = Provider((ref) {
  final statusRepository = ref.read(statusRepositoryProvider);
  return StatusController(statusRepostory: statusRepository, ref: ref);
});

class StatusController {
  final StatusRepostory statusRepostory;
  final ProviderRef ref;
  StatusController({
    required this.statusRepostory,
    required this.ref,
  });
  void addStatus(File file, BuildContext context) {
    ref.watch(userDataAuthProvider).whenData((value) {
      statusRepostory.uploadStory(
          userName: value!.name,
          phoneNumber: value.phoneNumber,
          profilePic: value.profilePic,
          statusImage: file,
          context: context);
    });
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statuses = await statusRepostory.getStatus(context);
    return statuses;
  }
}
