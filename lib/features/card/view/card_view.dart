import 'package:cardx/models/card_model.dart';
import 'package:cardx/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CardView extends StatelessWidget {
  static route(CardModel cardModel) => MaterialPageRoute(
    builder: (context) => CardView(cardModel: cardModel),
  );
  final CardModel cardModel;

  const CardView({super.key, required this.cardModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cardModel.name),
        backgroundColor: AppPalette.background,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: _buildCardDetails(context),
      ),
    );
  }

  Widget _buildCardDetails(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(cardModel.avatarUrl),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                cardModel.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _infoRow('Job Title', cardModel.jobTitle),
            const SizedBox(height: 8),
            _infoRow('Company', cardModel.company),
            const SizedBox(height: 8),
            _infoRow('Phone', cardModel.phone),
            const SizedBox(height: 8),
            _infoRow('Email', cardModel.email),
            const SizedBox(height: 8),
            _infoRow('Website', cardModel.website),
            const SizedBox(height: 8),
            _infoRow('Address', cardModel.address),
            const SizedBox(height: 8),
            _infoRow(
              'Created At',
              '${cardModel.createdAt.toLocal()}'.split(' ')[0],
            ),
            const SizedBox(height: 8),
            _infoRow('Favorite', cardModel.isFavorite ? 'Yes' : 'No'),
            const SizedBox(height: 8),
            _infoRow(
              'Notes',
              cardModel.notes.isNotEmpty
                  ? cardModel.notes
                  : 'No notes',
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _contactButton(Icons.phone, () async {
                  print('Phone button pressed');
                  final String sanitizedPhone = cardModel.phone
                      .replaceAll(
                        RegExp(r'[^\d+]'),
                        '',
                      ); // Remove non-numeric characters except '+'
                  final Uri phoneUri = Uri(
                    scheme: 'tel',
                    path: sanitizedPhone,
                  );
                  if (await canLaunchUrl(phoneUri)) {
                    await launchUrl(phoneUri);
                  } else {
                    print('Could not launch phone URL: $phoneUri');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Unable to make a call. Please check your device settings.',
                        ),
                      ),
                    );
                  }
                }),
                _contactButton(Icons.email, () async {
                  print('Email button pressed');
                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: cardModel.email,
                    query:
                        'subject=Hello&body=Hi', // Optional: Add subject and body
                  );
                  if (await canLaunchUrl(emailUri)) {
                    await launchUrl(emailUri);
                  } else {
                    print('Could not launch email URL: $emailUri');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Unable to send email. Please check your email app.',
                        ),
                      ),
                    );
                  }
                }),
                _contactButton(Icons.web, () async {
                  print('Website button pressed');
                  final String sanitizedWebsite =
                      cardModel.website.startsWith('http')
                          ? cardModel.website
                          : 'https://${cardModel.website}'; // Ensure URL starts with http/https
                  final Uri webUri = Uri.parse(sanitizedWebsite);
                  if (await canLaunchUrl(webUri)) {
                    await launchUrl(webUri);
                  } else {
                    print('Could not launch website URL: $webUri');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Unable to open website. Please check the URL.',
                        ),
                      ),
                    );
                  }
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _contactButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    );
  }
}
