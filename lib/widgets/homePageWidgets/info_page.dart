import 'package:chattor_app/constants/text_style.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Bu uygulama şu an geliştirilme aşamasındadır.\n"
        "Uygulamanın güncel halinin nihai durumunu yansıtmadığını hatırlatmak isteriz.\n"
        "Test aşamasına katıldığınız için teşekkür ederiz.\n\n\n"
        "This application is currently under development.\n"
        "Please remember that the current version of the application may not reflect its final state.\n"
        "Thank you for participating in the testing phase.",
        style: MyTextStyles.infoTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
