// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously

import 'dart:io';
import 'package:chattor_app/controller/auth_controller.dart';
import 'package:chattor_app/constants/screen_size.dart';
import 'package:chattor_app/utility/image_picker_from_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AvatarAndTextFieldWidget extends ConsumerStatefulWidget {
  const AvatarAndTextFieldWidget({super.key});

  @override
  ConsumerState<AvatarAndTextFieldWidget> createState() =>
      _AvatarAndTextFieldWidgetState();
}

class _AvatarAndTextFieldWidgetState
    extends ConsumerState<AvatarAndTextFieldWidget> {
  final textEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  File? image;
  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = textEditingController.text.trim();

    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        avatarWidget(),
        textFieldWidget(context),
      ],
    );
  }

  Stack avatarWidget() {
    return Stack(
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
    );
  }

  Row textFieldWidget(BuildContext context) {
    return Row(
      children: [
        Container(
          width: ScreenSize.getWidth(context) * 0.85,
          padding: const EdgeInsets.all(30),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            controller: textEditingController,
            decoration: const InputDecoration(
              hintText: 'Enter your name',
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: storeUserData,
          icon: const Icon(
            Icons.done,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
