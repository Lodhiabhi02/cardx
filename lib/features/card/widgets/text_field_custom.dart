import 'package:cardx/theme/app_palette.dart';
import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const TextFieldCustom({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
          color: AppPalette.textWhite,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppPalette.boderColorGray,
            width: 2.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppPalette.buttonBlue,
            width: 2.5,
          ),
        ),
      ),
      validator: (value) {
        if (value!.trim().isEmpty) {
          return '$hintText is missing!';
        }
        return null;
      },
    );
  }
}
