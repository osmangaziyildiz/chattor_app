import 'package:chattor_app/pages/chat_page.dart';
import 'package:chattor_app/pages/create_group_page.dart';
import 'package:chattor_app/pages/home_page.dart';
import 'package:chattor_app/pages/login_page.dart';
import 'package:chattor_app/pages/privacy_terms_of_service.dart';
import 'package:chattor_app/pages/select_contacts_page.dart';
import 'package:chattor_app/pages/user_information_page.dart';
import 'package:chattor_app/utility/error_screen.dart';
import 'package:chattor_app/utility/firebase_otp_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/privacyPage':
      return MaterialPageRoute(
        builder: (context) => const PrivacyAndTermsOfService(),
      );

    case '/loginPage':
      return MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );

    case '/otpScreen':
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(verificationId: verificationId),
      );

    case '/userInformationPage':
      return MaterialPageRoute(
        builder: (context) => const UserInformationPage(),
      );

    case '/homePage':
      return MaterialPageRoute(
        builder: (context) => const HomePage(),
      );

    case '/chatPage':
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'] ?? false;
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
        builder: (context) => ChatPage(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          profilePic: profilePic,
        ),
      );

    case '/selectContactsPage':
      return MaterialPageRoute(
        builder: (context) => const SelectContactsPage(),
      );

    case '/createGroupPage':
      return MaterialPageRoute(
        builder: (context) => const CreateGroupPage(),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(
            errorText: 'Opps! Somethings went wrong!',
          ),
        ),
      );
  }
}
