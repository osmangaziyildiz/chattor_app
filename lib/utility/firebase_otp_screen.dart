// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chattor_app/constants/color.dart';
import 'package:chattor_app/constants/screen_size.dart';
import 'package:chattor_app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTPScreen extends ConsumerWidget {
  const OTPScreen({super.key, required this.verificationId});

  final String verificationId;

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref
        .read(authControllerProvider)
        .verifyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verifiying your number',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: MyColor.bgColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: ScreenSize.getHeight(context) * 0.05),
            const Text(
              'We have sent an SMS with code',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: ScreenSize.getWidth(context) * 0.50,
              child: TextField(
                maxLength: 6,
                style: const TextStyle(color: Colors.white, fontSize: 30),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                showCursor: false,
                onChanged: (value) {
                  if (value.length == 6) {
                    verifyOTP(ref, context, value.toString().trim());
                  }
                },
                decoration: InputDecoration(
                  counterStyle: const TextStyle(color: Colors.amber),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  hintText: '- - - - - -',
                  hintStyle: TextStyle(
                    fontSize: ScreenSize.getWidth(context) * 0.12,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
