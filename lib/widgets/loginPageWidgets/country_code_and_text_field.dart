import 'package:chattor_app/constants/screen_size.dart';
import 'package:chattor_app/utility_providers.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountryCodeAndTextField extends ConsumerWidget {
  const CountryCodeAndTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneController = ref.watch(phoneControllerProvider.notifier).state;
    final Country? country = ref.watch(countryProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          '+${country?.phoneCode ?? '00'}',
          style: const TextStyle(color: Colors.white),
        ),
        SizedBox(
          width: ScreenSize.getWidth(context) * 0.6,
          child: TextField(
            keyboardType: TextInputType.number,
            cursorColor: Colors.white,
            style: const TextStyle(
              color: Colors.white,
            ),
            controller: phoneController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(5),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.amber),
              ),
              border: UnderlineInputBorder(),
              labelText: 'Enter your phone number',
              labelStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
