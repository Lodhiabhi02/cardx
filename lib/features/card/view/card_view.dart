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
                  final Uri phoneUri = Uri(
                    scheme: 'tel',
                    path: cardModel.phone,
                  );
                  if (await canLaunchUrl(phoneUri)) {
                    await launchUrl(phoneUri);
                  }
                }),
                _contactButton(Icons.email, () async {
                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: cardModel.email,
                  );
                  if (await canLaunchUrl(emailUri)) {
                    await launchUrl(emailUri);
                  }
                }),
                _contactButton(Icons.web, () async {
                  final Uri webUri = Uri.parse(cardModel.website);
                  if (await canLaunchUrl(webUri)) {
                    await launchUrl(webUri);
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
