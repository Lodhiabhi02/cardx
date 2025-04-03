import 'dart:io';
import 'package:cardx/common/loading_page.dart';
import 'package:cardx/common/rounded_button.dart';
import 'package:cardx/core/utils.dart';
import 'package:cardx/features/card/controller/card_controller.dart';
import 'package:cardx/features/card/widgets/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditDetailsPage extends ConsumerStatefulWidget {
  final Map<String, String> extractedDetails;

  const EditDetailsPage({super.key, required this.extractedDetails});

  @override
  ConsumerState<EditDetailsPage> createState() =>
      _EditDetailsPageState();
}

class _EditDetailsPageState extends ConsumerState<EditDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _jobTitleController;
  late TextEditingController _companyController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _websiteController;
  final _notesController = TextEditingController();

  File? image;
  @override
  void dispose() {
    super.dispose();
    _notesController.dispose();
  }

  Future<void> onPickImage() async {
    final pickedImage = await pickimage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void saveCard() {
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an image.")),
      );
      return;
    }

    ref
        .watch(cardControllerProvider.notifier)
        .saveCard(
          image: image,
          name: _nameController.text.trim(),
          jobtitle: _jobTitleController.text.trim(),
          company: _companyController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          website: _websiteController.text.trim(),
          address: _addressController.text.trim(),
          isFavorite: false,
          notes: _notesController.text.trim(),
          context: context,
        );
  }

  @override
  void initState() {
    super.initState();

    // Initialize the controllers with extracted values
    _nameController = TextEditingController(
      text: widget.extractedDetails['name'] ?? '',
    );
    _jobTitleController = TextEditingController(
      text: widget.extractedDetails['jobTitle'] ?? '',
    );
    _companyController = TextEditingController(
      text: widget.extractedDetails['company'] ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.extractedDetails['phone'] ?? '',
    );
    _emailController = TextEditingController(
      text: widget.extractedDetails['email'] ?? '',
    );
    _addressController = TextEditingController(
      text: widget.extractedDetails['address'] ?? '',
    );
    _websiteController = TextEditingController(
      text: widget.extractedDetails['website'] ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(cardControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Edit Details")),
      body:
          isLoading
              ? Loader()
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: onPickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.amber,
                          backgroundImage:
                              image != null
                                  ? FileImage(image!)
                                  : null,
                          child:
                              image == null
                                  ? Icon(Icons.camera_alt, size: 40)
                                  : null,
                        ),
                      ),
                      SizedBox(height: 30),
                      Column(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                        children: [
                          TextFieldCustom(
                            controller: _nameController,
                            hintText: "Name",
                          ),
                          SizedBox(height: 20),
                          TextFieldCustom(
                            controller: _jobTitleController,
                            hintText: "job title",
                          ),
                          SizedBox(height: 20),
                          TextFieldCustom(
                            controller: _companyController,
                            hintText: "Company",
                          ),
                          SizedBox(height: 20),
                          TextFieldCustom(
                            controller: _phoneController,
                            hintText: "Phone",
                          ),
                          SizedBox(height: 20),
                          TextFieldCustom(
                            controller: _emailController,
                            hintText: "Email",
                          ),
                          SizedBox(height: 20),
                          TextFieldCustom(
                            controller: _websiteController,
                            hintText: "Website",
                          ),
                          SizedBox(height: 20),
                          TextFieldCustom(
                            controller: _addressController,
                            hintText: "Address",
                          ),
                          SizedBox(height: 20),
                          TextFieldCustom(
                            controller: _notesController,
                            hintText: "Notes",
                          ),
                        ],
                      ),

                      SizedBox(height: 30),
                      RoundedButton(
                        onTap: isLoading ? () {} : saveCard,
                        buttonText: isLoading ? "Saving..." : "Save",
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
