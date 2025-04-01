import 'package:cardx/features/card/widgets/text_field_custom.dart';
import 'package:flutter/material.dart';

class EditDetailsPage extends StatefulWidget {
  final Map<String, String> extractedDetails;

  const EditDetailsPage({super.key, required this.extractedDetails});

  @override
  State<EditDetailsPage> createState() => _EditDetailsPageState();
}

class _EditDetailsPageState extends State<EditDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _jobTitleController;
  late TextEditingController _companyController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _websiteController;

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
    return Scaffold(
      appBar: AppBar(title: Text("Edit Details")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(radius: 40, backgroundColor: Colors.grey),
              SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                ],
              ),

              SizedBox(height: 30),
              ElevatedButton(onPressed: () {}, child: Text("Save")),
            ],
          ),
        ),
      ),
    );
  }
}
