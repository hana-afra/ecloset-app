import 'package:ecloset/models/shop.dart';
import 'package:ecloset/screens/itemPage.dart';
import 'package:ecloset/widgets/my_product_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewIn extends StatelessWidget {
  const NewIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<Shop>(context);

    return FutureBuilder<void>(
      future: shopProvider.fetchProducts(),
      builder: (context, snapshot) {
        //print("Snapshot: $snapshot");
        if (shopProvider.shop.isNotEmpty) {
          // Access the products
          final products = shopProvider.shop;

          return GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.64,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              // Store the context in a variable
              final currentContext = context;

              return GestureDetector(
                onTap: () async {
                  // Use the stored context inside the asynchronous block
                  final isLoggedIn = await shopProvider.checkIfLoggedIn();

                  if (isLoggedIn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemPage(product: product),
                      ),
                    );
                  } else {
                    // Show a dialog to prompt the user to log in or cancel
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Login Required'),
                        content: Text('Please log in to view details.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                             Navigator.pushReplacementNamed(context, '/welcome');
                            },
                            child: Text('Login'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: MyProductTile(product: product),
              );
            },
          );
        } else if (snapshot.hasError) {
          // If there's an error, handle it accordingly
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
