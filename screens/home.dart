import 'package:ecloset/widgets/buttom_navbar.dart';
import 'package:ecloset/widgets/filter_drawer.dart';
import 'package:ecloset/widgets/searchproduct.dart';
import 'package:ecloset/pages/page_1.dart';
import 'package:ecloset/pages/page_2.dart';
import 'package:ecloset/pages/page_3.dart';
import 'package:ecloset/pages/page_4.dart';
import 'package:ecloset/tabs/dresses.dart';
import 'package:ecloset/tabs/new_in.dart';
import 'package:ecloset/tabs/pants.dart';
import 'package:ecloset/tabs/shoes.dart';
import 'package:ecloset/tabs/tops.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  final _controller = PageController();
  final TextEditingController _searchController =
      TextEditingController(); // Add a TextEditingController for search

  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); //access products in shop

  void _updateSearchResults(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        endDrawer: const FilterDrawer(),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                scaffoldKey.currentState?.openEndDrawer();
              },
              icon: Image.asset(
                'lib/assets/icons/filter.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const Icon(Icons.notifications_on),
          title: const Center(
            child: Text(
              "Home",
              style: TextStyle(
                color: Color.fromRGBO(179, 133, 134, 1),
                fontSize: 55.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Birthstone',
                shadows: [
                  Shadow(
                    color: Colors.grey, // Choose the color of the shadow
                    blurRadius:
                        2.0, // Adjust the blur radius for the shadow effect
                    offset: Offset(2,
                        2), // Set the horizontal and vertical offset for the shadow
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      margin: const EdgeInsets.symmetric(horizontal: 35)
                          .copyWith(top: 30),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(242, 233, 232, 0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color.fromRGBO(245, 233, 231, 1),
                            width: 2.0,
                          )),
                      child: Row(children: [
                        const Icon(
                          Icons.search,
                          color: Color.fromRGBO(179, 133, 134, 1),
                        ),
                        const SizedBox(
                            width:
                                10), // Adjust the width based on your desired spacing

                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              print("Search Query: $value");
                              _updateSearchResults(value);
                              //SearchProduct();
                              // const SearchProduct(); // Pass the value to your search function
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ])),
                  Visibility(
                    visible: searchQuery.isNotEmpty,
                    child: SearchProduct(searchQuery: _searchController.text),
                  ),
                  if (searchQuery.isEmpty)
                    //ads slider
                    const SizedBox(height: 25),
                  if (searchQuery.isEmpty)
                    SizedBox(
                      height: 210,
                      child: PageView(
                        controller: _controller,
                        children: const [
                          Page1(),
                          Page2(),
                          Page3(),
                          Page4(),
                        ],
                      ),
                    ),
                  if (searchQuery.isEmpty) const SizedBox(height: 10),
                  if (searchQuery.isEmpty)
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 4,
                      effect: const JumpingDotEffect(
                        activeDotColor: Color.fromRGBO(179, 133, 134, 1),
                        dotColor: Color.fromRGBO(245, 233, 231, 1),
                        dotHeight: 8,
                        dotWidth: 8,
                        jumpScale: 1.2,
                      ),
                    ),
                  if (searchQuery.isEmpty) const SizedBox(height: 20),
                  if (searchQuery.isEmpty)
                    const TabBar(
                      isScrollable: true,
                      indicatorColor: Color.fromRGBO(179, 133, 134, 1),
                      labelColor: Color.fromRGBO(179, 133, 134, 1),
                      unselectedLabelColor: Color.fromRGBO(0, 0, 0, 0.5),
                      tabs: [
                        Tab(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 0), // Adjust the left padding as needed
                            child: Text('New In'),
                          ),
                        ),
                        Tab(
                          child: Text('Dresses'),
                        ),
                        Tab(
                          child: Text('Pants'),
                        ),
                        Tab(
                          child: Text('Shoes'),
                        ),
                        Tab(
                          child: Text('Tops'),
                        ),
                      ],
                    ),
                  if (searchQuery.isEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const TabBarView(
                        children: [
                          //NewIn
                          NewIn(),
                          Dresses(),
                          Pants(),
                          Shoes(),
                          Tops(),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}
