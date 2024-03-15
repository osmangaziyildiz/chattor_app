import 'package:chattor_app/constants/color.dart';
import 'package:chattor_app/controller/auth_controller.dart';
import 'package:chattor_app/models/user_model.dart';
import 'package:chattor_app/utility/loader_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NameAndStatusWidget extends ConsumerWidget {
  final String uid;
  final String name;
  final bool isGroupChat;

  const NameAndStatusWidget({
    super.key,
    required this.isGroupChat,
    required this.uid,
    required this.name,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isGroupChat == true) {
      return Text(
        name,
        style: const TextStyle(color: Colors.black),
      );
    }
    return StreamBuilder<UserModel>(
      stream: ref.read(authControllerProvider).userDataById(uid),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(color: MyColor.iconColor),
            ),
            Text(
              snapshot.data!.isOnline ? 'Online' : '',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ],
        );
      },
    );
  }
}
