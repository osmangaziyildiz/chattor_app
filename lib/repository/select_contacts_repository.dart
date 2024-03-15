// ignore_for_file: use_build_context_synchronously

import 'package:chattor_app/models/user_model.dart';
import 'package:chattor_app/utility/show_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactsRepositoryProvider = Provider((ref) {
  return SelectContactsRepository(
    firestore: FirebaseFirestore.instance,
  );
});

class SelectContactsRepository {
  final FirebaseFirestore firestore;

  SelectContactsRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContacts(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;
      for (var element in userCollection.docs) {
        UserModel userData = UserModel.fromMap(element.data());
        String selectedPhoneNumber =
            selectedContact.phones[0].number.replaceAll(' ', '');
        if (selectedPhoneNumber == userData.phoneNumber) {
          isFound = true;
          Navigator.of(context).pushNamed(
            '/chatPage',
            arguments: {
              'name': userData.name,
              'uid': userData.uid,
              'profilePic': userData.profilePic,
            },
          );
        }
      }
      if (!isFound) {
        showSnackBar(
            context: context,
            content: 'This number does not exist on this app');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
