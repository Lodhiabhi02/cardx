import 'package:cardx/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String text;
  final bool isPass;
  final TextInputType keyboardType;
  final TextEditingController controller;
  const AuthField({
    super.key,
    required this.text,
    required this.controller,
    this.isPass = false,
    this.keyboardType = TextInputType.name,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      obscureText: isPass,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppPalette.cardBackground,
        focusColor: AppPalette.buttonBlue,
        hintText: text,

        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppPalette.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppPalette.boderColorBlue,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppPalette.transparent),

          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
        ),
      ),
    );
  }
}
