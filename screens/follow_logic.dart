// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SellerProfilePage extends StatefulWidget {
  final String sellerId; // ID of the seller being viewed

  const SellerProfilePage({Key? key, required this.sellerId}) : super(key: key);

  @override
  _SellerProfilePageState createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    checkIfFollowing(); // Check if the user is already following this seller on page load
  }

  void checkIfFollowing() async {
    // Replace 'current_user_id' with the actual ID of the logged-in user
    final currentUserID = 'current_user_id';

    final response = await http.get(
      Uri.parse('http://your_flask_server_ip:your_flask_server_port/fetch_follow_status?id_user=$currentUserID&id_seller=${widget.sellerId}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        isFollowing = data['data']['is_following'];
      });
    }
  }

  void toggleFollow() async {
    // Replace 'current_user_id' with the actual ID of the logged-in user
    final currentUserID = 'current_user_id';

    final response = await http.post(
      Uri.parse('http://your_flask_server_ip:your_flask_server_port/toggle_follow'),
      body: json.encode({
        'follower_id': currentUserID,
        'followed_id': widget.sellerId,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        isFollowing = data['data']['is_following'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Seller Profile Page',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: toggleFollow,
              child: Text(isFollowing ? 'Unfollow' : 'Follow'),
            ),
          ],
        ),
      ),
    );
  }
}
