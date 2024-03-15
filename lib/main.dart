import 'package:chattor_app/controller/auth_controller.dart';
import 'package:chattor_app/constants/color.dart';
import 'package:chattor_app/firebase_options.dart';
import 'package:chattor_app/pages/home_page.dart';
import 'package:chattor_app/pages/landing_page.dart';
import 'package:chattor_app/router.dart';
import 'package:chattor_app/utility/error_screen.dart';
import 'package:chattor_app/utility/loader_indicator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: MyColor.bgColor,
        appBarTheme: const AppBarTheme(color: MyColor.appBarColor),
        iconTheme: const IconThemeData(color: Colors.black),
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
            iconColor: MaterialStatePropertyAll(Colors.black),
          ),
        ),
      ),
      title: 'Chattor',
      home: ref.watch(userDataAuthProvider).when(
        data: (user) {
          if (user == null) {
            return const LandingPage();
          }
          return const HomePage();
        },
        error: (error, stackTrace) {
          return ErrorScreen(errorText: error.toString());
        },
        loading: () {
          return const Loader();
        },
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
