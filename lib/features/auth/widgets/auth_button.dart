import 'package:cardx/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;
  const AuthButton({
    super.key,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: onTap,

        style: ElevatedButton.styleFrom(
          fixedSize: Size(325, 60),
          backgroundColor: AppPalette.buttonBlue,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: AppPalette.textWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
