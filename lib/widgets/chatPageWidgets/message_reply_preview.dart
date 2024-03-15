import 'package:chattor_app/constants/screen_size.dart';
import 'package:chattor_app/enums/message_enum.dart';
import 'package:chattor_app/utility_providers.dart';
import 'package:chattor_app/widgets/chatPageWidgets/display_message_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Container(
      width: ScreenSize.getWidth(context) * 0.95,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReply!.isMe ? 'Me' : 'Opposite',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
                onTap: () => cancelReply(ref),
              ),
            ],
          ),
          if (messageReply.messageEnum == MessageEnum.image)
            SizedBox(
              height: ScreenSize.getHeight(context) * 0.20,
              child: DisplayMessageType(
                message: messageReply.message,
                type: messageReply.messageEnum,
                textColor: Colors.white,
              ),
            ),
          if (messageReply.messageEnum != MessageEnum.image)
            DisplayMessageType(
              message: messageReply.message,
              type: messageReply.messageEnum,
              textColor: Colors.white,
            ),
        ],
      ),
    );
  }
}
