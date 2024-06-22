import 'package:ecloset/screens/itemPage.dart';
import 'package:ecloset/widgets/my_favorite_icon_state.dart';
import 'package:ecloset/models/product.dart';
import 'package:ecloset/models/shopShoes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Shoes extends StatelessWidget {
  const Shoes({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the Shop class from the provider
    final shopProvider = Provider.of<ShopShoes>(context);

    return FutureBuilder<void>(
      future: shopProvider.fetchShoes(context),
      builder: (context, snapshot) {
        if (shopProvider.shopshoes.isNotEmpty) {
          // Access the products
          final products = shopProvider.shopshoes;

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
class MyProductTile extends StatelessWidget {

  final Product product;
  const MyProductTile({
    super.key, 
    required this.product
  });
  

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
       ),
       margin: const EdgeInsets.all(10),
       padding: const EdgeInsets.symmetric(horizontal:10),

      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //product image
          AspectRatio(
            aspectRatio: 0.8,
            child: Stack(
              children: [
                Container(
                 decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                    offset: Offset(0, 0),
                    ),
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      offset: Offset(0, 5),
                    ),
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      offset: Offset(0, 8),
                     ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(product.imagePath),
                     // fit: BoxFit.cover,
                    ),
                  ),
                  width: double.infinity,                 
                ),
              //like button
               Positioned (
                top: 8.0,
                right: 8.0,
                child: MyFavouriteIconState(product: product),
               ),
              ],
            ),
          ),

          const SizedBox(height: 20,),

          
          
          //product name
          Text(
            product.name,
            style: const TextStyle (
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 15,
            ),

          ),
          const SizedBox(height: 4),
          //product price
          Text(
            "${product.price.toStringAsFixed(2)} DZD",
            style: const TextStyle (
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(0, 0, 0, 0.5),
              fontSize: 12,
            ),
          ),

        ],
        )
    );
  }
}