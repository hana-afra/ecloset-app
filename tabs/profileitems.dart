import 'package:ecloset/models/my_selling_items.dart';
import 'package:ecloset/screens/sellingitemPage.dart';
import 'package:ecloset/widgets/my_product_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProfileItem extends StatefulWidget {
  final String id;

  const ProfileItem({super.key,  required this.id});

  @override
  State<ProfileItem> createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: Provider.of<MySellingItems>(context).fetchMySellingItems(context, widget.id),
      builder: (context, snapshot) {
         if (snapshot.hasError) {
          // Handle error state
          return Text('Error: ${snapshot.error}');
        } else  {
          // Access the products from MySellingItems instance
          final mySellingItems = Provider.of<MySellingItems>(context).mysellingItems;

          return GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.64,
            ),
            itemCount: mySellingItems.length,
            itemBuilder: (context, index) {
              // Get each product from the MySellingItems instance
              final product = mySellingItems[index];

              // Return as a product tile UI
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SellingItemPage(product: product),
                    ),
                  );
                },
                child: MyProductTile(product: product),
              );
            },
          );
        }
      },
    );
  }
}
