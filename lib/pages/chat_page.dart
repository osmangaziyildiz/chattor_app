import 'package:chattor_app/constants/color.dart';
import 'package:chattor_app/controller/call_controller.dart';
import 'package:chattor_app/pages/call_pickup_page.dart';
import 'package:chattor_app/widgets/chatPageWidgets/message_writing_field.dart';
import 'package:chattor_app/widgets/chatPageWidgets/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chattor_app/widgets/chatPageWidgets/name_and_status_bar.dart';

class ChatPage extends ConsumerWidget {
  final String name;
  final String uid;
  final String profilePic;
  final bool isGroupChat;

  const ChatPage({
    super.key,
    required this.isGroupChat,
    required this.name,
    required this.uid,
    required this.profilePic,
  });

  void makeCall({
    required WidgetRef ref,
    required BuildContext context,
  }) {
    ref.read(callControllerProvider).makeCall(
          context: context,
          receiverName: name,
          receiverId: uid,
          receiverPic: profilePic,
          isGroupChat: isGroupChat,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallPickupPage(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.appBarColor,
          title: NameAndStatusWidget(
              uid: uid, name: name, isGroupChat: isGroupChat),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => makeCall(ref: ref, context: context),
              padding: const EdgeInsets.only(right: 10),
              icon: const Icon(
                Icons.video_call,
                color: MyColor.iconColor,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(
                receiverUserId: uid,
                isGroupChat: isGroupChat,
              ),
            ),
            MessageWritingField(
              receiverUserId: uid,
              isGroupChat: isGroupChat,
            ),
          ],
        ),
      ),
    );
  }
}
