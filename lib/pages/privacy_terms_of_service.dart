import 'package:chattor_app/constants/color.dart';
import 'package:flutter/material.dart';

class PrivacyAndTermsOfService extends StatelessWidget {
  const PrivacyAndTermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.bgColor,
      appBar: AppBar(
        backgroundColor: MyColor.bgColor,
        centerTitle: true,
        title: const Text(
          'Privacy Policy and Terms of Service',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            Text(
              '1. INTRODUCTION\n'
              'This privacy and terms of service policy outlines your rights '
              'and responsibilities regarding the use of the Chattor mobile '
              'messaging application. Please read this policy carefully and '
              'ensure that you understand the terms before using the application.\n',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              '2. COLLECTION AND USE OF PERSONAL INFORMATION\n'
              'Chattor is committed to keeping personal information collected '
              'from users confidential. User information may be collected when '
              'user accounts are created, contact information is entered, or '
              'during interactions within the application. This information may '
              'be used for the provision of services, improvement of user experience, '
              'and ensuring security.\n',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              '3. SHARING OF PERSONAL INFORMATION\n'
              'Chattor pledges not to share user information with third parties, '
              'except as required by legal obligations or with the explicit '
              'consent of the user.\n',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              '4. SECURITY\n'
              'Chattor implements industry-standard security measures to protect '
              'user information. However, please note that complete security cannot '
              'be guaranteed for communication over the internet.\n',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              '5. COOKIES\n'
              'Chattor may use cookies to enhance user experience and provide services. '
              'Users have the option to reject cookies or adjust cookie notifications.\n',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              '6. TERMS OF SERVICE\n'
              'The terms of service for Chattor establish the rights and responsibilities '
              'related to the use of the application. Users are considered to have accepted '
              'these terms by using the application.\n',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              '7. CHANGES\n'
              'Chattor reserves the right to update the privacy and terms of service policy. '
              'Updates will be communicated to users through notifications or postings '
              'within the application.\n',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
