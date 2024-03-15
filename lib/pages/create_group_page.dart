import 'dart:io';

import 'package:chattor_app/constants/color.dart';
import 'package:chattor_app/controller/group_controller.dart';
import 'package:chattor_app/utility/image_picker_from_gallery.dart';
import 'package:chattor_app/utility/show_snack_bar.dart';
import 'package:chattor_app/widgets/createGroupPageWidgets/select_contacts_list_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  const CreateGroupPage({super.key});

  @override
  ConsumerState<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends ConsumerState<CreateGroupPage> {
  File? image;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup() {
    if (textEditingController.text.trim().isNotEmpty && image != null) {
      ref.read(groupControllerProvider).createGroup(
            context: context,
            name: textEditingController.text.trim(),
            profilePic: image!,
            selectedContactList: ref.read(selectedGroupContactsProvider),
          );
      ref.read(selectedGroupContactsProvider.notifier).update((state) => []);
      Navigator.of(context).pop();
    } else {
      showSnackBar(context: context, content: "Group name and group image must be provided!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.amber),
        title: const Text('Create a Group'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        radius: 64,
                        backgroundImage: AssetImage('assets/icons/avatar.png'),
                      )
                    : CircleAvatar(
                        backgroundImage: FileImage(image!),
                        radius: 64,
                      ),
                Positioned(
                  bottom: -10,
                  right: -10,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                cursorColor: Colors.white,
                controller: textEditingController,
                decoration: const InputDecoration(
                  hintText: 'Enter Group Name',
                  hintStyle: TextStyle(color: Colors.white),
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.only(left: 25),
              alignment: Alignment.topLeft,
              child: const Text(
                'Select Contacts',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            const SelectContactsListGroup()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: MyColor.appBarColor,
        child: const Icon(
          Icons.done,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }
}
