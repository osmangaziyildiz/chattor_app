import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chattor_app/repository/select_contacts_repository.dart';

final getContactsProvider = FutureProvider((ref) async {
  final selectContactsRepository = ref.watch(selectContactsRepositoryProvider);
  return selectContactsRepository.getContacts();
});

final selectContactsControllerProvider = Provider((ref) {
  final selectContactsRepository = ref.watch(selectContactsRepositoryProvider);
  return SelectContactsController(ref: ref, selectContactsRepository: selectContactsRepository);
});

class SelectContactsController {
  final ProviderRef ref;
  final SelectContactsRepository selectContactsRepository;

  SelectContactsController({
    required this.ref,
    required this.selectContactsRepository,
  });

  void selectContacts(Contact selectedContact, BuildContext context) {
    selectContactsRepository.selectContacts(selectedContact, context);
  }
}
