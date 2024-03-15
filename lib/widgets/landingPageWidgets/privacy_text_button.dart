import 'package:chattor_app/constants/text_style.dart';
import 'package:flutter/material.dart';

class PrivacyTextButton extends StatelessWidget {
  const PrivacyTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/privacyPage');
      },
      child: Text(
        'Read our Privacy Policy.'
        ' Tap "Agree and continue" to accept the Terms of Service.',
        style: MyTextStyles.privacyTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
