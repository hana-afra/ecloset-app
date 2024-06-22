// help_screen.dart

import 'package:ecloset/theme/theme.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text(
    'Help',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      // Add other text styles if needed
    ),
  ),
),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: HelpContent(),
      ),
    );
  }
}

class HelpContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Section(
          title: 'Introduction',
          content: '''
          Welcome to Ecloset – your go-to platform for buying and selling second-hand clothes. Whether you're looking to save on your budget or find unique items no longer available in stores, we've got you covered! This help document is designed to guide you through the app's features and functionalities.
          ''',
        ),
        Section(
          title: 'Modes',
          content: '''
          - Guest Mode: Explore the app and browse available items without signing in.
          - Signed-In Mode: Access full features, including detailed item information, selling items, and more. Sign in to make the most of your [Your App Name] experience.
          ''',
        ),
        Section(
          title: 'Home',
          content: '''The home screen displays a curated selection of items available for sale from different sellers. Here, you can find details such as owner information, price, location (wilaya), size, and item description. Use the call option to contact the seller directly.
          ''',
        ),
        Section(
          title: 'Filter Option',
          content: '''Enhance your search process by using the filter option. Choose the category, item type, size, and set a price range to narrow down your search results.
          ''',
        ),
        Section(
          title: 'Search Bar',
          content: '''Looking for something specific? Use the search bar to find items or sellers by entering keywords.
          ''',
        ),
        Section(
          title: 'Liked Items Page',
          content: '''Liked an item? It's saved for later on the Liked Items page. Remove items at any time to keep your list organized.
          ''',
        ),
        Section(
          title: 'Profile Page',
          content: '''Your profile page displays the number of followers and following. Additionally, view items you're selling. In guest mode, you can modify personal information, and in signed-in mode, unlock full access to features.
          ''',
        ),
        Section(
          title: 'Selling an Item',
          content: '''Ready to sell? Click on the plus sign to add a new item. Fill in the required information, and your item will be available for other users to discover.
          ''',
        ),
        Section(
          title: 'Chat Option (For Future Release)',
          content: '''Coming soon! Engage with other users through the chat option. Communicate seamlessly and facilitate transactions with ease.
          ''',
        ),
        Section(
          title: 'Feedback and Support',
          content: ''' We value your feedback! If you have any questions, encounter issues, or want to share your thoughts, please reach out to our support team at [ecloset.dz@gmail.com].
          Thank you for choosing [Your App Name]. Happy buying and selling!
          ''',
        ),
      ],
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final String content;

  Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor, // Use your primary color
            ),
          ),
          SizedBox(height: 8.0),
          Text(content),
        ],
      ),
    );
  }
}
