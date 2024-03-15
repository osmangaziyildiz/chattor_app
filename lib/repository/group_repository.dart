// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:chattor_app/repository/firebase_storage_repository.dart';
import 'package:chattor_app/utility/show_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:chattor_app/models/group_model.dart' as model;

final groupRepositoryProvider = Provider((ref) {
  return GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup({
    required BuildContext context,
    required String name,
    required File profilePic,
    required List<Contact> selectedContactList,
  }) async {
    try {
      List<String> uids = [];
      for (var i = 0; i < selectedContactList.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: selectedContactList[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();

        if (userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }
      var groupUid = const Uuid().v1();
      String photoUrl = await ref
          .read(firebaseStorageRepositoryProvider)
          .storeFileToFirebase('group/$groupUid', profilePic);
      model.Group group = model.Group(
        timeSent: DateTime.now(),
        senderId: auth.currentUser!.uid,
        name: name,
        groupUid: groupUid,
        lastMessage: '',
        groupPic: photoUrl,
        membersUid: [auth.currentUser!.uid, ...uids],
      );
      await firestore.collection('groups').doc(groupUid).set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
