// filter_drawer.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecloset/constants/endpoints.dart';
import 'package:ecloset/main.dart';
import 'package:ecloset/models/product.dart';
import 'package:ecloset/screens/filtered_products.dart';
import 'package:flutter/material.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({Key? key}) : super(key: key);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  List<Product> filteredProducts = [];
  List<Map<String, dynamic>> types = []; // to store clothing types
  List<Map<String, dynamic>> wilayas = []; // to store wilayas
  List<Map<String, dynamic>> communes = [];

  int? selectedCategoryId;
  int? selectedTypeId;
  int? selectedWilayaId;
  int? previousWilayaId;
  int? selectedCommuneId;
  String selectedSize = '';
  String minPrice = '';
  String maxPrice = '';

  void selectCategory(int category) {
    setState(() {
      selectedCategoryId = category;
      print(selectedCategoryId);
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch types when the widget is initialized
    fetchTypes();
    fetchWilayas();
    print(selectedWilayaId);
    fetchCommunes(selectedWilayaId);
  }

  Future<void> fetchTypes() async {
    try {
      final response = await dio
          .get('$api_endpoint_types_get'); // Update this to your API endpoint
      if (response.statusCode == 200) {
        setState(() {
          // Update the types list with the fetched types
          types = List<Map<String, dynamic>>.from(jsonDecode(response.data));
        });
      } else {
        print('Error fetching types: ${response.statusCode}');
      }
    } catch (error) {
      print('Dio error: $error');
    }
  }

  Future<void> fetchWilayas() async {
    try {
      final response = await dio.get('$api_endpoint_wilayas_get');

      if (response.statusCode == 200) {
        setState(() {
          // Update the wilayas list with the fetched wilayas
          wilayas = List<Map<String, dynamic>>.from(jsonDecode(response.data));
        });
      } else {
        print('Error fetching wilayas: ${response.statusCode}');
      }
    } catch (error) {
      print('Dio error: $error');
    }
  }

  Future<void> fetchCommunes(int? wilayaId) async {
    try {
      print(wilayaId);
      communes.clear();
      selectedCommuneId = null;
      if (wilayaId != null) {
        final response =
            await dio.get('$api_endpoint_communes_get?id_wilaya=$wilayaId');
        if (response.statusCode == 200) {
          setState(() {
            communes =
                List<Map<String, dynamic>>.from(jsonDecode(response.data));
            print(communes);
          });
        } else {
          print('Error fetching communes: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Dio error: $error');
    }
  }

  Future<void> applyFilter() async {
    try {
      print(selectedCategoryId);
      print(selectedTypeId);
      print(selectedWilayaId);
      print(selectedCommuneId);
      print(selectedSize);
      print(minPrice);
      print(maxPrice);
      // Make a network request to fetch items based on filter criteria
      final response = await dio.get(
        '$api_endpoint_filter?id_category=$selectedCategoryId&id_type=$selectedTypeId&id_wilaya=$selectedWilayaId&size=$selectedSize&'
        'minPrice=$minPrice&maxPrice=$maxPrice',
        //'id_commune': selectedCommuneId,
      );
      if (response.statusCode == 200) {
        //print(response.data);
        
        final Map<String, dynamic> responseData = json.decode(response.data);
         // Assuming the key for the list of items is 'data', adjust it accordingly
        final List<dynamic> data = responseData['data'];

        setState(() {
          filteredProducts.clear();

          for (var row_d in data) {
            Map<String, dynamic> row = Map<String, dynamic>.from(row_d);

            filteredProducts.add(Product(
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
            ));
          }
          try {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FilteredProducts(filteredProducts: filteredProducts),
              ),
            );
          } catch (e) {
            print('Error during navigation: $e');
          }
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      if (error is DioError) {
        print('DioError: ${error.response?.statusCode}, ${error.message}');
      } else {
        print('Error: $error');
        // Show dialog when no items are found
       showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Items Found'),
            content: Text('There are no items matching the selected criteria.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //Gender
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white.withOpacity(0.3),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => selectCategory(2),
                        style: ElevatedButton.styleFrom(
                          primary: selectedCategoryId == 2
                              ? const Color.fromRGBO(211, 169, 163, 1)
                              : const Color.fromRGBO(245, 233, 231, 1),
                          side: const BorderSide(
                            color: Color.fromRGBO(211, 169, 163,
                                1), // Change this color to your desired border color
                            width:
                                1.0, // Adjust the width of the border as needed
                          ),
                        ),
                        child: Text(
                          'Man',
                          style: TextStyle(
                            color: selectedCategoryId == 2
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      ElevatedButton(
                        onPressed: () => selectCategory(1),
                        style: ElevatedButton.styleFrom(
                          primary: selectedCategoryId == 1
                              ? const Color.fromRGBO(211, 169, 163, 1)
                              : const Color.fromRGBO(245, 233, 231, 1),
                          side: const BorderSide(
                            color: Color.fromRGBO(211, 169, 163,
                                1), // Change this color to your desired border color
                            width:
                                1.0, // Adjust the width of the border as needed
                          ),
                        ),
                        child: Text(
                          'Woman',
                          style: TextStyle(
                            color: selectedCategoryId == 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      ElevatedButton(
                        onPressed: () => selectCategory(3),
                        style: ElevatedButton.styleFrom(
                          primary: selectedCategoryId == 3
                              ? const Color.fromRGBO(211, 169, 163, 1)
                              : const Color.fromRGBO(245, 233, 231, 1),
                          side: const BorderSide(
                            color: Color.fromRGBO(211, 169, 163,
                                1), // Change this color to your desired border color
                            width:
                                1.0, // Adjust the width of the border as needed
                          ),
                        ),
                        child: Text(
                          'Child',
                          style: TextStyle(
                            color: selectedCategoryId == 3
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25.0),

                // Type
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Type:',
                      style: TextStyle(
                          fontSize: 22,
                          color: Color.fromRGBO(211, 169, 163, 1),
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(211, 169, 163, 1),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<int>(
                        value: selectedTypeId,
                        onChanged: (value) {
                          setState(() {
                            selectedTypeId = value!;
                            print(selectedTypeId);
                          });
                        },
                        items: types.map<DropdownMenuItem<int>>((type) {
                          return DropdownMenuItem<int>(
                            value: type['id_type'] as int,
                            child: Text(type['name'].toString()),
                          );
                        }).toList(),
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromRGBO(211, 169, 163, 1),
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25.0),

                // Wilaya
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wilaya:',
                      style: TextStyle(
                          fontSize: 22,
                          color: Color.fromRGBO(211, 169, 163, 1),
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(211, 169, 163, 1),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<int>(
                        // Change DropdownButton<String> to DropdownButton<int>
                        value: selectedWilayaId,
                        onChanged: (value) {
                          setState(() {
                            selectedWilayaId = value;
                            print(selectedWilayaId);
                          });

                          // Call fetchCommunes with the updated selected wilayaId
                          fetchCommunes(selectedWilayaId);
                        },

                        items: wilayas.map<DropdownMenuItem<int>>((wilaya) {
                          return DropdownMenuItem<int>(
                            value: wilaya['id_wilaya'] as int,
                            child: Text(wilaya['name'].toString()),
                          );
                        }).toList(),
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromRGBO(211, 169, 163, 1),
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25.0),

                // Commune
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Commune:',
                      style: TextStyle(
                          fontSize: 22,
                          color: Color.fromRGBO(211, 169, 163, 1),
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(211, 169, 163, 1),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<int>(
                        value: selectedCommuneId,
                        onChanged: (value) {
                          setState(() {
                            selectedCommuneId = value!;
                            print(selectedCommuneId);
                          });
                        },
                        items: communes.map<DropdownMenuItem<int>>((commune) {
                          return DropdownMenuItem<int>(
                            value: commune['id_commune'] as int,
                            child: Text(commune['name'].toString()),
                          );
                        }).toList(),
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromRGBO(211, 169, 163, 1),
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25.0),
                //Size
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Size:',
                      style: TextStyle(
                          fontSize: 22,
                          color: Color.fromRGBO(211, 169, 163, 1),
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(211, 169, 163, 1),
                        ), // Customize border color
                        borderRadius: BorderRadius.circular(
                            12), // Customize border radius
                      ),
                      child: DropdownButton<String>(
                        value: selectedSize.isNotEmpty ? selectedSize : null,
                        onChanged: (value) {
                          setState(() {
                            selectedSize = value!;
                          });
                        },
                        items: [
                          'XS',
                          'S',
                          'M',
                          'L',
                          'XL',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value, // Ensure that each value is unique
                            child: Text(value),
                          );
                        }).toList(),
                        isExpanded: true,
                        underline:
                            const SizedBox(), // Remove the default underline
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromRGBO(211, 169, 163, 1),
                          size: 50,
                        ), // Add dropdown icon
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25.0),
                //Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price:',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color.fromRGBO(211, 169, 163, 1),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 125,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromRGBO(211, 169, 163, 1),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: minPrice.isNotEmpty ? minPrice : null,
                            onChanged: (value) {
                              setState(() {
                                minPrice = value!;
                              });
                            },
                            items: [
                              '200',
                              '500',
                              '800',
                              '1000',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color.fromRGBO(211, 169, 163, 1),
                              size: 28,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Min',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                            width: 16), // Add some spacing between dropdowns
                        Container(
                          width: 125,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromRGBO(211, 169, 163, 1),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: maxPrice.isNotEmpty ? maxPrice : null,
                            onChanged: (value) {
                              setState(() {
                                maxPrice = value!;
                              });
                            },
                            items: [
                              '1000',
                              '2000',
                              '3000',
                              '4000',
                              '10000',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color.fromRGBO(211, 169, 163, 1),
                              size: 28,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Max',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: applyFilter,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: const Color.fromRGBO(
                        211, 169, 163, 1), // Background color
                    onPrimary: Colors.white, // Text color
                  ),
                  child: const Text('Apply Filter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
