import 'package:ecloset/screens/itemPage.dart';
import 'package:ecloset/widgets/my_product_tile.dart';
import 'package:ecloset/models/shopdress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dresses extends StatelessWidget {
  const Dresses({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the Shop class from the provider
    
    final shopProvider = Provider.of<ShopDress>(context);

    return FutureBuilder<void>(
      future: shopProvider.fetchDresses(context),
      builder: (context, snapshot) {
        if (shopProvider.shopdress.isNotEmpty) {
          // Access the products
          final products = shopProvider.shopdress;

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

              return GestureDetector(
                onTap: () async {
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
          return Text('Error: ${snapshot.error}sdfsf');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
