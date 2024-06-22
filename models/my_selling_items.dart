import 'dart:convert';
import 'package:ecloset/constants/endpoints.dart';
import 'package:ecloset/main.dart';
import 'package:ecloset/models/product.dart';
import 'package:ecloset/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MySellingItems extends ChangeNotifier {
  final List<Product> _mysellingItems = [];
  

  List<Product> get mysellingItems => _mysellingItems;


  Future<void> fetchMySellingItems(BuildContext context, String userId) async {
    try {
      // Fetch liked items using the _userId
      final shop = Provider.of<Shop>(context, listen: false);
      await shop.fetchLikedItems();

      // Access favorite items from the Shop instance
      final favoriteItems = shop.favoriteItems;
      var response = await dio.get('$api_endpoint_fetch_my_selling_items?id_user=$userId');
      
      List<dynamic> dataLines = jsonDecode(response.data);
   

      // Clear the existing list before adding new liked items
      _mysellingItems.clear();

      for (var row_d in dataLines) {
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

        _mysellingItems.add(product);
        
      }

      // Notify listeners after adding liked items
      notifyListeners();
    } catch (error) {
      print('Supabase error: ${error}');
      throw Exception('Failed to fetch SELLING items');
    }
  }

}