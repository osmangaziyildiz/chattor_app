import 'package:chattor_app/enums/message_enum.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountryNotifier extends StateNotifier<Country?> {
  CountryNotifier() : super(null);

  void setCountry(Country newCountry) {
    state = newCountry;
  }
}

final countryProvider = StateNotifierProvider<CountryNotifier, Country?>((ref) {
  return CountryNotifier();
});

final phoneControllerProvider = StateProvider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply({
    required this.message,
    required this.isMe,
    required this.messageEnum,
  });
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) {
  return null;
});
