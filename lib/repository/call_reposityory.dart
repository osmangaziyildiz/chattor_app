// ignore_for_file: use_build_context_synchronously

import 'package:chattor_app/models/call_model.dart';
import 'package:chattor_app/models/group_model.dart';
import 'package:chattor_app/pages/current_call_page.dart';
import 'package:chattor_app/utility/show_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final callRepositoryProvider = Provider((ref) {
  return CallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CallRepository({
    required this.firestore,
    required this.auth,
  });

  void makeCall({
    required BuildContext context,
    required CallModel senderCallData,
    required CallModel receiverCallData,
  }) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('call')
          .doc(receiverCallData.receiverId)
          .set(receiverCallData.toMap());

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return CurrentCallPage(
            channelId: senderCallData.callId,
            call: senderCallData,
            isGroupChat: false,
          );
        },
      ));
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void makeGroupCall({
    required BuildContext context,
    required CallModel senderCallData,
    required CallModel receiverCallData,
  }) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());

      var groupSnapshot = await firestore
          .collection('groups')
          .doc(senderCallData.receiverId)
          .get();
      Group group = Group.fromMap(groupSnapshot.data()!);
      for (var element in group.membersUid) {
        await firestore
            .collection('call')
            .doc(element)
            .set(receiverCallData.toMap());
      }

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return CurrentCallPage(
            channelId: senderCallData.callId,
            call: senderCallData,
            isGroupChat: true,
          );
        },
      ));
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endCall({
    required BuildContext context,
    required String callerId,
    required String receiverId,
  }) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      await firestore.collection('call').doc(receiverId).delete();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endGroupCall({
    required BuildContext context,
    required String callerId,
    required String receiverId,
  }) async {
    try {
      var groupSnapshot =
          await firestore.collection('groups').doc(receiverId).get();
      Group group = Group.fromMap(groupSnapshot.data()!);
      for (var element in group.membersUid) {
        await firestore.collection('call').doc(element).delete();
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> callStream() {
    return firestore.collection('call').doc(auth.currentUser!.uid).snapshots();
  }
}
