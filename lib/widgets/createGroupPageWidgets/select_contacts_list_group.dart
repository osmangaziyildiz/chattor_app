import 'package:chattor_app/controller/select_contacts_controller.dart';
import 'package:chattor_app/utility/error_screen.dart';
import 'package:chattor_app/utility/loader_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedGroupContactsProvider = StateProvider<List<Contact>>((ref) => []);

class SelectContactsListGroup extends ConsumerStatefulWidget {
  const SelectContactsListGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsListGroupState();
}

class _SelectContactsListGroupState
    extends ConsumerState<SelectContactsListGroup> {
  List<int> selectedContactsIndex = [];

  void selectContact(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.remove(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref
        .read(selectedGroupContactsProvider.notifier)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
      data: (data) {
        return Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final contact = data[index];
              return InkWell(
                onTap: () {
                  selectContact(index, contact);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      contact.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    leading: selectedContactsIndex.contains(index)
                        ? IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.done, color: Colors.green,),
                          )
                        : null,
                  ),
                ),
              );
            },
          ),
        );
      },
      error: (error, stackTrace) {
        return ErrorScreen(
          errorText: error.toString(),
        );
      },
      loading: () {
        return const Loader();
      },
    );
  }
}
