import 'package:chattor_app/constants/screen_size.dart';
import 'package:chattor_app/controller/auth_controller.dart';
import 'package:chattor_app/utility_providers.dart';
import 'package:chattor_app/utility/show_snack_bar.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:chattor_app/widgets/loginPageWidgets/country_code_and_text_field.dart';
import 'package:chattor_app/widgets/loginPageWidgets/next_button_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void pickCountry() {
      showCountryPicker(
        context: context,
        onSelect: (Country selectedCountry) {
          ref.read(countryProvider.notifier).setCountry(selectedCountry);
        },
      );
    }

    void sendPhoneNumber() {
      String phoneNumber =
          ref.watch(phoneControllerProvider.notifier).state.text.trim();
      Country? country = ref.watch(countryProvider);
      if (country != null && phoneNumber.isNotEmpty) {
        ref
            .read(authControllerProvider)
            .signInWithPhone(context, '+${country.phoneCode}$phoneNumber');
      } else {
        showSnackBar(context: context, content: 'Please fill in all fields.');
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Enter your phone number',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: ScreenSize.getHeight(context) * 0.10),
            const Text(
              'Chattor will need to verify your phone number',
              style: TextStyle(color: Colors.grey),
            ),
            TextButton(
              onPressed: pickCountry,
              child: const Text(
                'Pick Country',
                style: TextStyle(color: Colors.amber),
              ),
            ),
            const CountryCodeAndTextField(),
            SizedBox(height: ScreenSize.getHeight(context) * 0.50),
            SizedBox(
              width: ScreenSize.getWidth(context) * 0.30,
              height: ScreenSize.getHeight(context) * 0.07,
              child: NextButtonWidget(onPressed: sendPhoneNumber),
            ),
          ],
        ),
      ),
    );
  }
}
