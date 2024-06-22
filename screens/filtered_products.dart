import 'package:ecloset/models/product.dart';
import 'package:ecloset/screens/itemPage.dart';
import 'package:ecloset/tabs/new_in.dart';
import 'package:ecloset/tabs/shoes.dart';
import 'package:ecloset/widgets/buttom_navbar.dart';
import 'package:ecloset/widgets/filter_drawer.dart';
import 'package:ecloset/widgets/searchproduct.dart';
import 'package:flutter/material.dart';

class FilteredProducts extends StatefulWidget {
  final List<Product> filteredProducts;

  const FilteredProducts({Key? key, required this.filteredProducts})
      : super(key: key);

  @override
  State<FilteredProducts> createState() => _FilteredProductsState();
}

class _FilteredProductsState extends State<FilteredProducts> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void _updateSearchResults(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
            "Filter Search",
            style: TextStyle(
              color: Color.fromRGBO(179, 133, 134, 1),
              fontSize: 55.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'Birthstone',
              shadows: [
                Shadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.symmetric(horizontal: 35).copyWith(top: 30),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(242, 233, 232, 0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color.fromRGBO(245, 233, 231, 1),
                    width: 2.0,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Color.fromRGBO(179, 133, 134, 1),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          print("Search Query: $value");
                          _updateSearchResults(value);
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
                  ],
                ),
              ),
              Visibility(
                visible: searchQuery.isNotEmpty,
                child: SearchProduct(searchQuery: _searchController.text),
              ),
              if (searchQuery.isEmpty && widget.filteredProducts.isEmpty)Container(
                height: MediaQuery.of(context).size.height,
                child: NewIn()),
              
              if (searchQuery.isEmpty && widget.filteredProducts.isNotEmpty)  GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.64,
                  ),
                  itemCount: widget.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = widget.filteredProducts[index];
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
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
  
}
