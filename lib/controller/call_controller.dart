import 'package:chattor_app/controller/auth_controller.dart';
import 'package:chattor_app/models/call_model.dart';
import 'package:chattor_app/repository/call_reposityory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(
    callRepository: callRepository,
    ref: ref,
    auth: FirebaseAuth.instance,
  );
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;

  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });

  void makeCall({
    required BuildContext context,
    required String receiverName,
    required String receiverId,
    required String receiverPic,
    required bool isGroupChat,
  }) {
    ref.read(userDataAuthProvider).whenData(
      (value) {
        String callId = const Uuid().v1();
        CallModel senderCallData = CallModel(
          callerId: auth.currentUser!.uid,
          callerName: value!.name,
          callerPic: value.profilePic,
          receiverId: receiverId,
          receiverName: receiverName,
          receiverPic: receiverPic,
          callId: callId,
          hasDialled: true,
        );
        CallModel receiverCallData = CallModel(
          callerId: auth.currentUser!.uid,
          callerName: value.name,
          callerPic: value.profilePic,
          receiverId: receiverId,
          receiverName: receiverName,
          receiverPic: receiverPic,
          callId: callId,
          hasDialled: false,
        );
        if (isGroupChat) {
          callRepository.makeGroupCall(
            context: context,
            senderCallData: senderCallData,
            receiverCallData: receiverCallData,
          );
        } else {
          callRepository.makeCall(
            context: context,
            senderCallData: senderCallData,
            receiverCallData: receiverCallData,
          );
        }
      },
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> callStream() {
    return callRepository.callStream();
  }

  void endCall({
    required BuildContext context,
    required String callerId,
    required String receiverId,
  }) {
    callRepository.endCall(
      context: context,
      callerId: callerId,
      receiverId: receiverId,
    );
  }

  void endGroupCall({
    required BuildContext context,
    required String callerId,
    required String receiverId,
  }) {
    callRepository.endGroupCall(
      context: context,
      callerId: callerId,
      receiverId: receiverId,
    );
  }
}
