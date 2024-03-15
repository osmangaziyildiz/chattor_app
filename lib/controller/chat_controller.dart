import 'dart:io';

import 'package:chattor_app/controller/auth_controller.dart';
import 'package:chattor_app/enums/message_enum.dart';
import 'package:chattor_app/models/chat_contact_model.dart';
import 'package:chattor_app/models/group_model.dart';
import 'package:chattor_app/models/message_model.dart';
import 'package:chattor_app/repository/chat_repository.dart';
import 'package:chattor_app/utility_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider = Provider((ref) {
  final ChatRepository chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required bool isGroupChat,
  }) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
      (value) {
        return chatRepository.sendTextMessage(
          context: context,
          text: text,
          receiverUserId: receiverUserId,
          senderUserData: value!,
          messageReply: messageReply,
          isGroupChat: isGroupChat,
        );
      },
    );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required MessageEnum messageEnum,
    required bool isGroupChat,
  }) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
      (value) {
        return chatRepository.sendFileMessage(
          context: context,
          file: file,
          receiverUserId: receiverUserId,
          senderUserData: value!,
          ref: ref,
          messageEnum: messageEnum,
          messageReply: messageReply,
          isGroupChat: isGroupChat,
        );
      },
    );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  Stream<List<ChatContact>> chatContactsStream() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatMessagesStream(String receiverUserId) {
    return chatRepository.getChatMessages(receiverUserId);
  }

  Stream<List<Group>> chatGroupsStream() {
    return chatRepository.getChatGroups();
  }

  Stream<List<Message>> groupMessagesStream(String groupId) {
    return chatRepository.getGroupMessages(groupId);
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      receiverUserId,
      messageId,
    );
  }
}
