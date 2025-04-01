import 'dart:convert';
import 'dart:io';
import 'package:cardx/common/rounded_button.dart';
import 'package:cardx/constants/gemini_constants.dart';
import 'package:cardx/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'edit_details_page.dart';

class ScanCardPage extends StatefulWidget {
  final File file;

  static route(File file) => MaterialPageRoute(
    builder: (context) => ScanCardPage(file: file),
  );

  const ScanCardPage({super.key, required this.file});

  @override
  State<StatefulWidget> createState() {
    return _ScanCardPageState();
  }
}

class _ScanCardPageState extends State<ScanCardPage> {
  bool isLoading = true; // Track if the image is loading
  bool isProcessing = false; // Track if the image is loading

  // Extract text from the image
  Future<String> extractText(File file) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText = await textRecognizer
        .processImage(inputImage);
    // String text = recognizedText.text;
    String text = recognizedText.text.replaceAll('\n', ' ');
    textRecognizer.close();

    return text;
  }

  Future<Map<String, String>> sendToGemini(String text) async {
    final Uri url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=$geminiAPIKey",
    );

    // Constructing the prompt
    String prompt = '''
  Extract the following details from the given text and return them as a JSON object:
  
  - name
  - company
  - job title
  - phone
  - address
  - email
  - website

  If any field is missing, return an empty string for that field.

  Example Output:
  {
    "name": "John Doe",
    "company": "TechCorp",
    "jobTitle": "Software Engineer",
    "phone": "+1 234 567 890",
    "address": "123 Main Street, NY, USA",
    "email": "johndoe@example.com",
    "website": "www.techcorp.com"
  }

  Here is the text: "$text"
  ''';

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(
          response.body,
        );

        // Extract the response text
        String? responseText =
            responseBody['candidates']?[0]?['content']?['parts']?[0]?['text'];

        if (responseText == null || responseText.isEmpty) {
          print("❌ Empty response from Gemini");
          return _emptyResponse();
        }

        // Remove ```json and ``` from the response
        responseText =
            responseText
                .replaceAll('```json', '')
                .replaceAll('```', '')
                .trim();

        // Parse JSON string
        Map<String, dynamic> data = json.decode(responseText);

        return {
          'name': data['name'] ?? '',
          'company': data['company'] ?? '',
          'jobTitle': data['jobTitle'] ?? '',
          'phone': data['phone'] ?? '',
          'address': data['address'] ?? '',
          'email': data['email'] ?? '',
          'website': data['website'] ?? '',
        };
      } else {
        print("❌ Gemini API Error: ${response.body}");
        return _emptyResponse();
      }
    } catch (e) {
      print("❌ JSON Parsing Error: $e");
      return _emptyResponse();
    }
  }

  // Function to return empty values if parsing fails
  Map<String, String> _emptyResponse() {
    return {
      'name': '',
      'company': '',
      'jobTitle': '',
      'phone': '',
      'address': '',
      'email': '',
      'website': '',
    };
  }

  @override
  void initState() {
    super.initState();

    // Use ImageStream to track when the image finishes loading
    final Image image = Image.file(widget.file);
    image.image
        .resolve(ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool synchronousCall) {
            setState(() {
              isLoading = false; // Image finished loading
            });
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan Card")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Image with placeholder logic
            Container(
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:
                    isLoading
                        ? Center(
                          child: CircularProgressIndicator(),
                        ) // Show loading indicator
                        : Image.file(widget.file, fit: BoxFit.cover),
              ),
            ),
            Column(
              children: [
                RoundedButton(buttonText: "Re scan", onTap: () {}),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 60),
                    backgroundColor: AppPalette.buttonBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  onPressed: () async {
                    setState(() {
                      isProcessing = true;
                    });
                    String extractedText = await extractText(
                      widget.file,
                    );
                    Map<String, String> map = await sendToGemini(
                      extractedText,
                    );
                    print(map);
                    print(extractedText);
                    setState(() {
                      isProcessing = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EditDetailsPage(
                              extractedDetails: map,
                            ),
                      ),
                    );
                  },
                  child:
                      isProcessing
                          ? CircularProgressIndicator(
                            color: AppPalette.white,
                          )
                          : Text(
                            "Process",
                            style: TextStyle(
                              color: AppPalette.textWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
