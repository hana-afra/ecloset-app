import 'dart:convert';
import 'package:ecloset/constants/endpoints.dart';
import 'package:ecloset/main.dart';
import 'package:ecloset/models/product.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final supabase = Supabase.instance.client;

class Shop extends ChangeNotifier {
  final List<Product> _shop = [];
  final List<Product> _favoriteItems = [];
  late SharedPreferences _prefs;
  List<Product> get shop => _shop;
  List<Product> get favoriteItems => _favoriteItems;
  String? lastImage = "https://jzredydxgjflzlgkamhn.supabase.co/storage/v1/object/sign/item/item/2024-01-26T21:31:17.285704.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpdGVtL2l0ZW0vMjAyNC0wMS0yNlQyMTozMToxNy4yODU3MDQucG5nIiwiaWF0IjoxNzA2MzAxMDgyLCJleHAiOjIwMjE2NjEwODJ9.Hqjnc2K1p73rVlYD1kqUr39t65g4c5fk9sGp5AzHAek";
  String? defaultProfilePic ="https://jzredydxgjflzlgkamhn.supabase.co/storage/v1/object/sign/item/item/2024-01-26T21:30:55.587640.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpdGVtL2l0ZW0vMjAyNC0wMS0yNlQyMTozMDo1NS41ODc2NDAuanBnIiwiaWF0IjoxNzA2MzAxMDU5LCJleHAiOjIwMjE2NjEwNTl9.EQ8qCe_8uC6EGsNxzptM88Cy8xCKtzg6d0VIeO-aEj4";

  Future<void> fetchLikedItems() async {
    try {
      final isLoggedIn = await checkIfLoggedIn();
      if (isLoggedIn) {
        _prefs = await SharedPreferences.getInstance();
        String userId = _prefs.getString('user_id') ?? '';

        var response =
            await dio.get('$api_endpoint_fetch_liked_items?id_user=$userId');

        List<dynamic> dataLines = jsonDecode(response.data);

        // Clear the existing list before adding new liked items
        _favoriteItems.clear();

        for (var row_d in dataLines) {
          Map row = Map.of(row_d);

          _favoriteItems.add(Product(
            Id: row['item']['id_item'] as String,
            name: row['item']['name'] as String,
            price: row['item']['price'] as double,
            imagePath: row['item']['image_path'] as String,
            ownerId: row['item']['id_user'],
            ownerName: row['item']['user']['name'] as String,
            ownerPhone: row['item']['user']['phone'] as String,
            ownerProfilePicture:
                row['item']['user']['profile_picture'] as String,
            wilaya: row['item']['wilaya']['name'] as String,
            size: row['item']['size'] as String,
            description: row['item']['description'] as String,
            commune: " ",
            category: row['item']['category']['name'] as String,
            type: row['item']['type']['name'] as String,
            isFavorite: true,
          ));
        }

        // Notify listeners after adding liked items
        notifyListeners();
      } else {
        _favoriteItems.clear();
      }
    } catch (error) {
      print('Supabase error: ${error}');
      throw Exception('Failed to fetch liked items');
    }
  }

  Future<void> removeFromFavoriteItems(Product item, String userId) async {
    try {
      var response = await dio.get(
          '$api_endpoint_remove_favorite_item?id_user=$userId&id_item=${item.Id}');
      Map retData = jsonDecode(response.toString());

      if (retData['status'] == 200) {
        // Remove the item from the liked list in the local state
        item.isFavorite = false;
        _favoriteItems.remove(item);
        // Notify listeners after removing the item
        notifyListeners();
      } else {
        print('Server returned an error: ${response.data}');
      }
    } catch (error) {
      print('Error during item removal from liked list: $error');
      throw Exception('Failed to remove item from liked list');
    }
  }

  Future<bool> checkIfLoggedIn() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.containsKey('user_id');
  }

  void addToFavoriteItems(Product item) {
    item.isFavorite = true;
    _favoriteItems.add(item);
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    try {
      final isLoggedIn = await checkIfLoggedIn();
      if (isLoggedIn) {
        await fetchProductsForUser();
      } else {
        await fetchProductsForGuest();
      }
    } catch (error) {
      print('Error fetching products: $error');
      throw Exception('Failed to fetch products');
    }
  }

  Future<void> fetchProductsForGuest() async {
    try {
      // Fetch products for the guest version
      var response = await dio.get(api_endpoint_item_get);
      List<dynamic> data_lines = jsonDecode(response.data);

      _shop.clear();

      for (var row_d in data_lines) {
        Map row = Map.of(row_d);
        if (row['image_path'] == null) {
          lastImage = "https://jzredydxgjflzlgkamhn.supabase.co/storage/v1/object/sign/item/item/2024-01-26T21:31:17.285704.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpdGVtL2l0ZW0vMjAyNC0wMS0yNlQyMTozMToxNy4yODU3MDQucG5nIiwiaWF0IjoxNzA2MzAxMDgyLCJleHAiOjIwMjE2NjEwODJ9.Hqjnc2K1p73rVlYD1kqUr39t65g4c5fk9sGp5AzHAek";
              
        } else {
          lastImage = row['image_path'];
        }

        if (row['user']['profile_picture'] == null) {
          defaultProfilePic = "https://jzredydxgjflzlgkamhn.supabase.co/storage/v1/object/sign/item/item/2024-01-26T21:30:55.587640.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpdGVtL2l0ZW0vMjAyNC0wMS0yNlQyMTozMDo1NS41ODc2NDAuanBnIiwiaWF0IjoxNzA2MzAxMDU5LCJleHAiOjIwMjE2NjEwNTl9.EQ8qCe_8uC6EGsNxzptM88Cy8xCKtzg6d0VIeO-aEj4";
              
        } else {
          defaultProfilePic = row['user']['profile_picture'];
        }

        Product product = Product(
          Id: row['id_item'] as String,
          name: row['name'] as String,
          price: row['price'] as double,
          imagePath: lastImage as String,
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

        _shop.add(product);
      }

      // Move notifyListeners() outside the loop
      notifyListeners();
    } catch (error) {
      print('Supabase error: ${error}');
      throw Exception('Failed to fetch products for guest');
    }
  }

  Future<void> fetchProductsForUser() async {
    try {
      // Fetch liked items first
      await fetchLikedItems();

      var response = await dio.get(api_endpoint_item_get);
      List<dynamic> data_lines = jsonDecode(response.data);

      _shop.clear();

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
        if (_favoriteItems.any((item) => item.Id == product.Id)) {
          product.isFavorite = true;
        }

        _shop.add(product);
      }

      // Move notifyListeners() outside the loop
      notifyListeners();
    } catch (error) {
      print('Supabase error: ${error}');
      throw Exception('Failed to fetch products');
    }
  }
}
