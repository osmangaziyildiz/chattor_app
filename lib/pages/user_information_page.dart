// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:chattor_app/constants/screen_size.dart';
import 'package:chattor_app/widgets/informationPageWidgets/avatar_and_textfield.dart';

class UserInformationPage extends StatelessWidget {
  const UserInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: ScreenSize.getHeight(context) * 0.10,
              ),
              const AvatarAndTextFieldWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
