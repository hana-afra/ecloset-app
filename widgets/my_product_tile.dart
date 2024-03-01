import 'package:ecloset/widgets/my_favorite_icon_state.dart';
import 'package:ecloset/models/product.dart';
import 'package:flutter/material.dart';

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
                    
                  ),
                  width: double.infinity, 
                  child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child:FadeInImage(
                              image: NetworkImage(product.imagePath), 
                              fit: BoxFit.cover, 
                              placeholder: NetworkImage("https://jzredydxgjflzlgkamhn.supabase.co/storage/v1/object/sign/item/item/2024-01-26T21:31:17.285704.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpdGVtL2l0ZW0vMjAyNC0wMS0yNlQyMTozMToxNy4yODU3MDQucG5nIiwiaWF0IjoxNzA2MzAxMDgyLCJleHAiOjIwMjE2NjEwODJ9.Hqjnc2K1p73rVlYD1kqUr39t65g4c5fk9sGp5AzHAek"),
                              ),
                            
                             
                          ),
           
                ),
              //like button
               Positioned (
                top: 1.0,
                right: 1.0,
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