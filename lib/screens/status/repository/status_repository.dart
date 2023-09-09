// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_riverpod/model/status_model.dart';
import 'package:connect_riverpod/model/user_model.dart';
import 'package:connect_riverpod/utils/common/commonfirebase/common_firebase_storage_repository.dart';
import 'package:connect_riverpod/utils/common/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider((ref) => StatusRepostory(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref));

class StatusRepostory {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  StatusRepostory({
    required this.firestore,
    required this.auth,
    required this.ref,
  });
  void uploadStory(
      {required String userName,
      required String phoneNumber,
      required String profilePic,
      required File statusImage,
      required BuildContext context}) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase('/status/$statusId$uid', statusImage);
      List<Contact> contacts = [];
      try {
        if (await FlutterContacts.requestPermission()) {
          contacts = await FlutterContacts.getContacts(withProperties: true);
        }
        List<String> uidWhoCanSee = [];
        for (int i = 0; i < contacts.length; i++) {
          var userdataFirebase = await firestore
              .collection('users')
              .where(
                'phoneNumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''),
              )
              .get();
          if (userdataFirebase.docs.isNotEmpty) {
            var userdata = UserModel.fromMap(
              userdataFirebase.docs[0].data(),
            );
            uidWhoCanSee.add(userdata.uid);
          }
        }
        List<String> statusImageUrls = [];
        var statusesSnapshot = await firestore
            .collection('status')
            .where('uid', isEqualTo: auth.currentUser!.uid)
            // .where(
            //   'createdAt',
            //   isLessThan: DateTime.now().subtract(
            //     Duration(hours: 24),
            //   ),
            // )
            .get();
        if (statusesSnapshot.docs.isNotEmpty) {
          Status status = Status.fromMap(statusesSnapshot.docs[0].data());
          statusImageUrls = status.photoUrl;
          statusImageUrls.add(imageUrl);
          await firestore
              .collection('status')
              .doc(statusesSnapshot.docs[0].id)
              .update({'photoUrl': statusImageUrls});
          return;
        } else {
          statusImageUrls = [imageUrl];
        }
        Status status = Status(
            uid: uid,
            userName: userName,
            phoneNumber: phoneNumber,
            profilePic: profilePic,
            statusId: statusId,
            photoUrl: statusImageUrls,
            whoCanSee: uidWhoCanSee,
            createdAt: DateTime.now());
        await firestore.collection('status').doc(statusId).set(status.toMap());
      } catch (e) {
        debugPrint(e.toString());
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (int i = 0; i < contacts.length; i++) {
        var statusesSnapshot = await firestore
            .collection('status')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''),
            )
            .where(
              'createdAt',
              isGreaterThan: DateTime.now()
                  .subtract(
                    const Duration(hours: 24),
                  )
                  .millisecondsSinceEpoch,
            )
            .get();
        for (var tempData in statusesSnapshot.docs) {
          Status tempStatus = Status.fromMap(tempData.data());
          if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
            statusData.add(tempStatus);
          }
        }
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return statusData;
  }
}
