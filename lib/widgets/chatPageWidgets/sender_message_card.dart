import 'package:chattor_app/constants/color.dart';
import 'package:chattor_app/constants/screen_size.dart';
import 'package:chattor_app/enums/message_enum.dart';
import 'package:chattor_app/widgets/chatPageWidgets/display_message_type.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;

  const SenderMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
  });

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    return SingleChildScrollView(
      child: SwipeTo(
        onRightSwipe: (details) => onRightSwipe(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ScreenSize.getWidth(context) - 45,
            ),
            child: Card(
              elevation: 1,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: MyColor.senderMessageColor,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Stack(
                children: [
                  Padding(
                    padding: type == MessageEnum.text
                        ? const EdgeInsets.only(
                            left: 10,
                            top: 5,
                            right: 30,
                            bottom: 20,
                          )
                        : const EdgeInsets.only(
                            left: 5,
                            top: 5,
                            right: 5,
                            bottom: 25,
                          ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isReplying) ...[
                          Text(
                            username,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Container(
                            width: double.maxFinite,
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: MyColor.bgColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DisplayMessageType(
                              message: repliedText,
                              type: repliedMessageType,
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                        DisplayMessageType(
                          message: message,
                          type: type,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 10,
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(255, 148, 148, 148),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
