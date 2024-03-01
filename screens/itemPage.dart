// ignore_for_file: prefer_const_constructors

import 'package:ecloset/models/product.dart';
import 'package:ecloset/screens/profile.dart';
import 'package:flutter/material.dart';

class ItemPage extends StatefulWidget {
  
final Product product;
  const ItemPage({super.key, required this.product});
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          alignment: Alignment.center,
      padding: EdgeInsets.all(10),
          child: Stack(
            clipBehavior: Clip.none,
        alignment: AlignmentDirectional.bottomCenter,
           
            fit: StackFit.expand,
            children: [
              FractionallySizedBox(
                alignment: Alignment.topCenter,
                heightFactor: 0.6,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 7,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: FadeInImage(
                              image: NetworkImage(widget.product.imagePath), 
                              fit: BoxFit.cover, 
                              placeholder: NetworkImage("https://jzredydxgjflzlgkamhn.supabase.co/storage/v1/object/sign/item/item/2024-01-26T21:31:17.285704.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpdGVtL2l0ZW0vMjAyNC0wMS0yNlQyMTozMToxNy4yODU3MDQucG5nIiwiaWF0IjoxNzA2MzAxMDgyLCJleHAiOjIwMjE2NjEwODJ9.Hqjnc2K1p73rVlYD1kqUr39t65g4c5fk9sGp5AzHAek"),
                              ),
                          ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child:  Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFCBABA4).withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child:const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.favorite,
                                size: 32,
                                color: isLiked ? Colors.red : Colors.transparent,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 460),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ProfilePage( product :widget.product)),
            );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: FadeInImage(
                              image: NetworkImage(widget.product.ownerProfilePicture), 
                              fit: BoxFit.cover, 
                              placeholder: NetworkImage("https://jzredydxgjflzlgkamhn.supabase.co/storage/v1/object/sign/item/item/2024-01-26T21:30:55.587640.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpdGVtL2l0ZW0vMjAyNC0wMS0yNlQyMTozMDo1NS41ODc2NDAuanBnIiwiaWF0IjoxNzA2MzAxMDU5LCJleHAiOjIwMjE2NjEwNTl9.EQ8qCe_8uC6EGsNxzptM88Cy8xCKtzg6d0VIeO-aEj4"),
                              ),
                              
                            ),
                          ),
                          SizedBox(width: 16),
                           Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.ownerName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              Text(
                                widget.product.wilaya,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                           Padding(
                            padding: EdgeInsets.only(top: 12), // Add padding to the top
                            child: Text(
                              widget.product.ownerPhone,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                     Positioned(
                      left: 30,
                      bottom: 10,
                      child: Text(
                       "Description",
                        style: TextStyle(
                          color: Color(0xFFB38586),
                          fontSize: 30,
                          fontFamily: 'Birthstone',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 40,
                      bottom: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                           Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.product.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 100),
                              Text(
                                widget.product.price.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                           Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Size",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 240),
                              Text(
                                widget.product.size,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFAB8787), width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(10),
                            child:  Text(
                              widget.product.description,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}