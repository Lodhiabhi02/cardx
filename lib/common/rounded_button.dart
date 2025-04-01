import 'package:cardx/theme/app_palette.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;
  const RoundedButton({
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
          fixedSize: Size(300, 60),
          backgroundColor: AppPalette.buttonBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
