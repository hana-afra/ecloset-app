import 'dart:convert';
import 'package:ecloset/constants/endpoints.dart';
import 'package:ecloset/main.dart';
import 'package:ecloset/models/product.dart';
import 'package:ecloset/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopShoes extends ChangeNotifier {
  final List<Product> _shopshoes = [];
  final List<Product> _favoriteItems = [];

  List<Product> get shopshoes => _shopshoes;
  List<Product> get favoriteItems => _favoriteItems;

  late SharedPreferences _prefs;

  void addToFavoriteItems(Product item) {
    _favoriteItems.add(item);
    notifyListeners();
  }

  void removeFromFavoriteItems(Product item) {
    _favoriteItems.remove(item);
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favoriteItems.contains(product);
  }
  Future<bool> checkIfLoggedIn() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.containsKey('user_id');
  }

  Future<void> fetchShoes(BuildContext context) async {
    try {
      final isLoggedIn = await checkIfLoggedIn();
      print(isLoggedIn);
      if (isLoggedIn) {
        await fetchShoesForUser(context);
      } else {
        
        await fetchShoesForGuest();
      }
    } catch (error) {
      print('Error fetching products: $error');
      throw Exception('Failed to fetch products');
    }
  }
  Future<void> fetchShoesForGuest() async {
    try {
      // Fetch products for the guest version
      var response = await dio.get(api_endpoint_shoes_get);
      List<dynamic> data_lines = jsonDecode(response.data);

      _shopshoes.clear();

      for (var row_d in data_lines) {
        Map row = Map.of(row_d);

        Product product = Product(
          Id: row['id_item'] as String,
          name: row['name'] as String,
          price: row['price'] as double,
          imagePath: row['image_path'] as String,
          ownerId: row['id_user'],
          ownerName: row['user']['name'] as String,
          ownerPhone: row['user']['phone'] as String,
          ownerProfilePicture: row['user']['profile_picture'] as String,
          wilaya: row['wilaya']['name'] as String,
          size: row['size'] as String,
          description: row['description'] as String,
          commune: " ",
          category: row['category']['name'] as String,
          type: row['type']['name'] as String,
          isFavorite: false,
        );

        _shopshoes.add(product);
      }

      // Move notifyListeners() outside the loop
      notifyListeners();
    } catch (error) {
      print('Supabase error: ${error}');
      throw Exception('Failed to fetch products for guest');
    }
  }

  Future<void> fetchShoesForUser(BuildContext context) async {
    try {
      // Fetch liked items using the _userId
      final shop = Provider.of<Shop>(context, listen: false);
      await shop.fetchLikedItems();

      // Access favorite items from the Shop instance
      final favoriteItems = shop.favoriteItems;

      var response = await dio.get(api_endpoint_shoes_get);
      List<dynamic> data_lines = jsonDecode(response.data);

      _shopshoes.clear();

      for (var row_d in data_lines) {
        Map row = Map.of(row_d);

        Product product = Product(
          Id: row['id_item'] as String,
          name: row['name'] as String,
          price: row['price'] as double,
          imagePath: row['image_path'] as String,
          ownerId: row['id_user'],
          ownerName: row['user']['name'] as String,
          ownerPhone: row['user']['phone'] as String,
          ownerProfilePicture: row['user']['profile_picture'] as String,
          wilaya: row['wilaya']['name'] as String,
          size: row['size'] as String,
          description: row['description'] as String,
          commune: " ",
          category: row['category']['name'] as String,
          type: row['type']['name'] as String,
          isFavorite: false,
        );

        // Set isFavorite based on liked items
        if (favoriteItems.any((item) => item.Id == product.Id)) {
          product.isFavorite = true;
        }

        _shopshoes.add(product);
      }

      notifyListeners();
    } catch (error) {
      print('Supabase error: ${error}');
      throw Exception('Failed to fetch products');
    }
  }
}
