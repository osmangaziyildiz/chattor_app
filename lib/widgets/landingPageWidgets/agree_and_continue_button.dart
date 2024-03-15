import 'package:chattor_app/constants/screen_size.dart';
import 'package:flutter/material.dart';

class AgreeAndContinueButton extends StatelessWidget {
  const AgreeAndContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenSize.getWidth(context) * 0.85,
      height: ScreenSize.getHeight(context) * 0.07,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          backgroundColor: Colors.amber,
          minimumSize: const Size(double.infinity, double.infinity),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed('/loginPage');
        },
        child: const Text(
          'AGREE AND CONTINUE',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
