import 'package:chattor_app/constants/color.dart';
import 'package:chattor_app/constants/screen_size.dart';
import 'package:chattor_app/constants/text_style.dart';
import 'package:chattor_app/widgets/landingPageWidgets/agree_and_continue_button.dart';
import 'package:chattor_app/widgets/landingPageWidgets/privacy_text_button.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.bgColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Text(
                'Welcome to Chattor',
                style: MyTextStyles.welcomeTextStyle,
              ),
            ),
            SizedBox(
              width: ScreenSize.getWidth(context) * 0.95,
              height: ScreenSize.getHeight(context) * 0.5,
              child: Image.asset('assets/images/landing_bg.png'),
            ),
            const PrivacyTextButton(),
            const AgreeAndContinueButton(),
          ],
        ),
      ),
    );
  }
}
