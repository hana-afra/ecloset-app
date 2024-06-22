import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ecloset/constants/endpoints.dart';
import 'package:ecloset/main.dart';
import 'package:ecloset/models/product.dart';
import 'package:ecloset/models/shop.dart';
import 'package:ecloset/screens/itemPage.dart';
import 'package:ecloset/tabs/shoes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchProduct extends StatefulWidget {
  final String searchQuery;

  const SearchProduct({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void didUpdateWidget(SearchProduct oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    try {
      // Fetch liked items using the _userId
      final shop = Provider.of<Shop>(context, listen: false);
      await shop.fetchLikedItems();
      // Access favorite items from the Shop instance
      final favoriteItems = shop.favoriteItems;
      final response = await Dio().get(
        '$api_endpoint_search?query=${Uri.encodeComponent(widget.searchQuery)}',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.data);
        setState(() {
          filteredProducts.clear();

          for (var row_d in data) {
            Map<String, dynamic> row = Map<String, dynamic>.from(row_d);

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

        filteredProducts.add(product);

          }
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.64,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemPage(product: product),
                    ),
                  );
                },
                child: MyProductTile(product: product),
              );
              
            },
          ),
        ],
      ),
    );
  }
}
