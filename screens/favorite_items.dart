// ignore_for_file: camel_case_types, prefer_const_constructors, use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:ecloset/screens/itemPage.dart';
import 'package:ecloset/widgets/buttom_navbar.dart';
import 'package:ecloset/models/product.dart';
import 'package:ecloset/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class favorite_items extends StatefulWidget {
  const favorite_items({
    super.key,
  });

  @override
  State<favorite_items> createState() => _favorite_itemsState();
}

class _favorite_itemsState extends State<favorite_items> {
  late String _userId;
  late SharedPreferences _prefs;
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _prefs = await SharedPreferences.getInstance();

    setState(() {
      _userId = _prefs.getString('user_id') ?? '';
    });
  }
  
  Future<void> _fetchLikedItems() async {
    try {
      await context.read<Shop>().fetchLikedItems();
    } catch (error) {
      print('Error fetching liked items: $error');
      // Handle the error as needed
    }
  }

  void removeFromFavoriteItems(Product product) async {
  try {
    // Remove item from liked items and update the UI
    await context.read<Shop>().removeFromFavoriteItems(product, _userId);
  } catch (error) {
    print('Error removing item from liked list: $error');
    // Handle the error as needed
    }
  }
  @override
  Widget build(BuildContext context) {
    final favoriteItems = context.watch<Shop>().favoriteItems;
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.grey[50],
              elevation: 0,
              pinned: true,
              expandedHeight: 130.0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding:
                    EdgeInsets.all(8), // Adjust the top padding as needed
                title: Text(
                  'My Favorite Items',
                  style: TextStyle(
                    fontFamily: 'Birthstone',
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFD3A9A3),
                  ),
                ),
                centerTitle: true,
              ),
            ),
            FutureBuilder<void>(
                future: _fetchLikedItems(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    );
                  } else {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final product = favoriteItems[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemPage(product: product),
                      ),
                    );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 26, vertical: 10),
                              child: Card(
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 14),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xFFD3A9A3),
                                      width: 1.2,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          //IMAGE
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  76, 175, 80, 1),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                color: Color(0xFFD3A9A3),
                                                width: 2.0,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              child: Image.network(
                                                product.imagePath,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            width: 15,
                                          ),

                                          //TEXT
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  product.name,
                                                  //cardData['ID$index']?['title'],
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  product.ownerName,
                                                  //cardData['ID$index']?['owner'],
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
                                                      255,
                                                      109,
                                                      109,
                                                      109,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          
                                          //HEART
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 2.38, right: 1.19),
                                            child: IconButton(
                                              onPressed: () {
                                                removeFromFavoriteItems(product);
                                                // Handle onPressed logic here
                                              },
                                              icon: Icon(
                                                Icons.favorite,
                                                color: Color(0xFFFF0000),
                                                size: 20.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: favoriteItems.length,
                      ),
                    );
                  }
                }),
          ],
        ),
        bottomNavigationBar: BottomNavBar());
  }
}