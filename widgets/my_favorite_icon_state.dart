import 'package:ecloset/constants/endpoints.dart';
import 'package:ecloset/models/product.dart';
import 'package:ecloset/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFavouriteIconState extends StatefulWidget {
  final Product product;
  final VoidCallback? onToggleFavorite;

  const MyFavouriteIconState({
    Key? key,
    required this.product,
    this.onToggleFavorite,
  }) : super(key: key);

  @override
  State<MyFavouriteIconState> createState() => _MyFavouriteIconStateState();
}

class _MyFavouriteIconStateState extends State<MyFavouriteIconState> {
  late SharedPreferences _prefs;
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
  _prefs = await SharedPreferences.getInstance();
  setState(() {
    _userId = _prefs.getString('user_id') ?? '';
  });
}

  Future<void> toggleFavorite() async {
    try {
      if (widget.product.isFavorite) {
        await removeFromFavoriteItems(_userId);
      } else {
        await addToFavoriteItems(_userId);
      }
      setState(() {
        widget.product.isFavorite = !widget.product.isFavorite;
      });
    } catch (error) {
      print('Error during favorite toggle: $error');
      // Handle the error, show a snackbar, etc.
    }
  }

  Future<void> addToFavoriteItems(String userID) async {
    try {
      final response = await dio.get(
        '$api_endpoint_add_favorite_item?id_user=$_userId&id_item=${widget.product.Id}',
      );
      // Handle the response if needed
    } catch (error) {
      print('Error during item insertion: $error');
    }
  }

  Future<void> removeFromFavoriteItems(String userID) async {
    try {
      final response = await dio.get(
        '$api_endpoint_remove_favorite_item?id_user=$_userId&id_item=${widget.product.Id}',
      );
      // Handle the response if needed
    } catch (error) {
      print('Error during item removal: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: toggleFavorite,
      icon: Icon(
        Icons.favorite,
        color: widget.product.isFavorite ? Colors.red : Colors.grey,
      ),
    );
  }
}