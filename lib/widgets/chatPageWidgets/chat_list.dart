import 'package:chattor_app/controller/chat_controller.dart';
import 'package:chattor_app/enums/message_enum.dart';
import 'package:chattor_app/models/message_model.dart';
import 'package:chattor_app/utility/loader_indicator.dart';
import 'package:chattor_app/utility_providers.dart';
import 'package:chattor_app/widgets/chatPageWidgets/my_message_card.dart';
import 'package:chattor_app/widgets/chatPageWidgets/sender_message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;
  const ChatList({
    super.key,
    required this.receiverUserId,
    required this.isGroupChat,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final scrollControlller = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollControlller.dispose();
  }

  void onMessageSwipe({
    required String message,
    required bool isMe,
    required MessageEnum messageEnum,
  }) {
    ref.read(messageReplyProvider.notifier).update((state) => MessageReply(
          message: message,
          isMe: isMe,
          messageEnum: messageEnum,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: widget.isGroupChat
          ? ref
              .watch(chatControllerProvider)
              .groupMessagesStream(widget.receiverUserId)
          : ref
              .watch(chatControllerProvider)
              .chatMessagesStream(widget.receiverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          scrollControlller.jumpTo(scrollControlller.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: scrollControlller,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final Message messageData = snapshot.data![index];
            String timeSent = DateFormat.Hm().format(messageData.timeSent);
            if (!messageData.isSeen &&
                messageData.receiverId ==
                    FirebaseAuth.instance.currentUser!.uid) {
              ref.read(chatControllerProvider).setChatMessageSeen(
                    context,
                    widget.receiverUserId,
                    messageData.messageId,
                  );
            }
            if (messageData.senderId ==
                FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                repliedText: messageData.repliedMessage,
                username: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                onLeftSwipe: () => onMessageSwipe(
                  message: messageData.text,
                  messageEnum: messageData.type,
                  isMe: true,
                ),
                isSeen: messageData.isSeen,
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: timeSent,
              type: messageData.type,
              repliedText: messageData.repliedMessage,
              username: messageData.repliedTo,
              repliedMessageType: messageData.repliedMessageType,
              onRightSwipe: () => onMessageSwipe(
                message: messageData.text,
                messageEnum: messageData.type,
                isMe: false,
              ),
            );
          },
        );
      },
    );
  }
}
