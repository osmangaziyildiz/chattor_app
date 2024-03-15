// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:chattor_app/constants/color.dart';
import 'package:chattor_app/constants/screen_size.dart';
import 'package:chattor_app/controller/chat_controller.dart';
import 'package:chattor_app/enums/message_enum.dart';
import 'package:chattor_app/utility/image_picker_from_gallery.dart';
import 'package:chattor_app/utility/show_snack_bar.dart';
import 'package:chattor_app/utility/video_picker_from_gallery.dart';
import 'package:chattor_app/utility_providers.dart';
import 'package:chattor_app/widgets/chatPageWidgets/message_reply_preview.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class MessageWritingField extends ConsumerStatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;

  const MessageWritingField({
    super.key,
    required this.receiverUserId,
    required this.isGroupChat,
  });

  @override
  ConsumerState<MessageWritingField> createState() =>
      _MessageWritingFieldState();
}

class _MessageWritingFieldState extends ConsumerState<MessageWritingField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  bool isShowEmojiWidget = false;
  FocusNode focusNode = FocusNode();
  AudioRecorder? _audioRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    openAudio();
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _audioRecorder!.dispose();
    isRecorderInit = false;
  }

  void openAudio() async {
    try {
      if (await _audioRecorder!.hasPermission()) {
        isRecorderInit = true;
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context: context,
            text: _messageController.text.trim(),
            receiverUserId: widget.receiverUserId,
            isGroupChat: widget.isGroupChat,
          );
      setState(() {
        _messageController.text = '';
      });
    } else {
      var temporaryDirec = await getTemporaryDirectory();
      var path = '${temporaryDirec.path}/Chattor_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _audioRecorder!.stop();
        sendFileMessage(file: File(path), messageEnum: MessageEnum.audio);
      } else {
        await _audioRecorder!.start(const RecordConfig(), path: path);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage({
    required File file,
    required MessageEnum messageEnum,
  }) {
    ref.read(chatControllerProvider).sendFileMessage(
          context: context,
          file: file,
          receiverUserId: widget.receiverUserId,
          messageEnum: messageEnum,
          isGroupChat: widget.isGroupChat,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(file: image, messageEnum: MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(file: video, messageEnum: MessageEnum.video);
    }
  }

  void hideEmojiWidget() {
    setState(() {
      isShowEmojiWidget = false;
    });
  }

  void showEmojiWidget() {
    setState(() {
      isShowEmojiWidget = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiWidget() {
    if (isShowEmojiWidget) {
      showKeyboard();
      hideEmojiWidget();
    } else {
      hideKeyboard();
      showEmojiWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                focusNode: focusNode,
                controller: _messageController,
                cursorColor: Colors.white,
                onChanged: (value) {
                  setState(
                    () {
                      if (value.isNotEmpty) {
                        isShowSendButton = true;
                      } else {
                        isShowSendButton = false;
                      }
                    },
                  );
                },
                decoration: InputDecoration(
                  prefixIconConstraints: const BoxConstraints(maxWidth: 48),
                  suffixIconConstraints: const BoxConstraints(maxWidth: 96),
                  filled: true,
                  fillColor: MyColor.chatBoxColor,
                  prefixIcon: Row(
                    children: [
                      IconButton(
                        onPressed: toggleEmojiWidget,
                        icon: const Icon(Icons.emoji_emotions),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.camera_alt),
                        color: Colors.grey,
                      ),
                      IconButton(
                        onPressed: selectVideo,
                        icon: const Icon(Icons.attach_file),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  hintText: 'Type a message!',
                  hintStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 4, top: 0, right: 4, bottom: 2),
              child: GestureDetector(
                onTap: () {
                  sendTextMessage();
                },
                child: CircleAvatar(
                  backgroundColor: MyColor.appBarColor,
                  child: Icon(
                    isShowSendButton
                        ? Icons.send
                        : isRecording
                            ? Icons.stop
                            : Icons.mic,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        isShowEmojiWidget
            ? SizedBox(
                height: ScreenSize.getHeight(context) * 0.35,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });
                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
