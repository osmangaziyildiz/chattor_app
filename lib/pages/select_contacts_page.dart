import 'package:chattor_app/controller/select_contacts_controller.dart';
import 'package:chattor_app/utility/error_screen.dart';
import 'package:chattor_app/utility/loader_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactsPage extends ConsumerWidget {
  const SelectContactsPage({super.key});

  void selectContacts(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactsControllerProvider)
        .selectContacts(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.amber,
        title: const Text(
          'Select Contact',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ref.watch(getContactsProvider).when(
        data: (contactList) {
          return ListView.builder(
            itemCount: contactList.length,
            itemBuilder: (BuildContext context, int index) {
              final contact = contactList[index];
              return InkWell(
                onTap: () => selectContacts(ref, contact, context),
                child: ListTile(
                  title: Text(
                    contact.displayName,
                    style: const TextStyle(color: Colors.white),
                  ),
                  leading: contact.photo == null
                      ? null
                      : CircleAvatar(
                          backgroundImage: MemoryImage(contact.photo!),
                          radius: 30,
                        ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return ErrorScreen(errorText: error.toString());
        },
        loading: () {
          return const Loader();
        },
      ),
    );
  }
}
