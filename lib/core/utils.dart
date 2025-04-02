import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(content)));
}

// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     SvgPicture.asset(
//       AssetsConstants.cardxLogo,
//       // fit: BoxFit.,
//     ),
//     SizedBox(width: 20),
//     Text(
//       "Crad X",
//       style: TextStyle(
//         fontSize: 30,
//         fontWeight: FontWeight.w500,
//       ),
//     ),
//   ],
// ),

// pick Image
Future<File?> pickimage() async {
  final ImagePicker imagePicker = ImagePicker();
  final imageFile = await imagePicker.pickImage(
    source: ImageSource.camera,
    imageQuality: 50,
  );
  if (imageFile != null) {
    return File(imageFile.path);
  }
  return null;
}

// // extract image
// Future<String>? extractText(File file) async {
//   final textRecognizer = TextRecognizer(
//     script: TextRecognitionScript.latin,
//   );

//   final InputImage inputImage = InputImage.fromFile(file);
//   final RecognizedText recognizedText = await textRecognizer
//       .processImage(inputImage);
//   String text = recognizedText.text;
//   textRecognizer.close();
//   return text;
// }

String formatTime(DateTime date) {
  final formatedDated = DateFormat("d MMMM yyyy").format(date);
  return formatedDated;
}
