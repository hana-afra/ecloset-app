// ignore_for_file: prefer_const_constructors, prefer_final_fields, library_private_types_in_public_api, use_build_context_synchronously, unnecessary_this, unused_field, unused_local_variable, unnecessary_null_in_if_null_operators, dead_code

import 'dart:convert';
import 'dart:io';
import 'package:ecloset/constants/endpoints.dart';
import 'package:ecloset/main.dart';
import 'package:ecloset/models/shop.dart';
import 'package:ecloset/screens/home.dart';
import 'package:ecloset/screens/login.dart';
import 'package:ecloset/theme/theme.dart';
import 'package:ecloset/widgets/buttom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';

class AddItemsPage extends StatefulWidget {
  @override
  _AddItemsPageState createState() => _AddItemsPageState();
}

class _AddItemsPageState extends State<AddItemsPage> {
  Color themeColor = Color(0xFFAB8787);
  Color borderColor = Color.fromARGB(255, 15, 9, 9);
  Color insideColor = Color(0xFFCBABA4);
  String? imagePath; // Variable to store the picked image path
  String? imageUrlResponse = "https://jzredydxgjflzlgkamhn.supabase.co/storage/v1/object/sign/item/item/2024-01-26T21:31:17.285704.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpdGVtL2l0ZW0vMjAyNC0wMS0yNlQyMTozMToxNy4yODU3MDQucG5nIiwiaWF0IjoxNzA2MzAxMDgyLCJleHAiOjIwMjE2NjEwODJ9.Hqjnc2K1p73rVlYD1kqUr39t65g4c5fk9sGp5AzHAek";

  TextEditingController _productNameController = TextEditingController();
  TextEditingController _wilayaController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _communeController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _typeController = TextEditingController();

  List<Map<String, dynamic>> types = []; // to store clothing types
  List<Map<String, dynamic>> wilayas = []; // to store wilayas
  List<Map<String, dynamic>> communes = [];
  List<Map<String, dynamic>> categories = [];

  String? selectedOption; // Provide a valid default value
  bool _isLoading = false;

  int? selectedCategoryId;
  int? selectedTypeId;
  int? selectedWilayaId;
  int? selectedCommuneId;
  late String _userId;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    // Fetch types when the widget is initialized
    fetchCategory();
    fetchTypes();
    fetchWilayas();
    print('after fetcg $selectedWilayaId');
    fetchCommunes(selectedWilayaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              SizedBox(height: 10.0),
              Text(
                'Add Items',
                style: TextStyle(
                    fontFamily: 'Birthstone', fontSize: 40, color: themeColor),
              ),
              SizedBox(height: 20.0),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 190.0,
                    height: 220.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: imagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: Image.file(
                              File(imagePath!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.photo_camera,
                              size: 60.0,
                              color: Colors.transparent,
                            ),
                            onPressed: () async {
                              _pickImage();
                            },
                          ),
                  ),
                  Container(
                    width: 190.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: Color(0xFF000000).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Icon(
                      Icons.photo_camera,
                      size: 60.0,
                      color: Color(0xFFE7D4CB),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              buildRoundedTextField(
                  'Product Name', themeColor, _productNameController),
              SizedBox(height: 20.0),
              WilayaBuildRoundedDropdown(),
              SizedBox(height: 20.0),
              CommuneBuildRoundedDropdown(),
              SizedBox(height: 20.0),
              CategoryBuildRoundedDropdown(),
              SizedBox(height: 20.0),
              TypeBuildRoundedDropdown(),
              SizedBox(height: 20.0),
              buildRoundedTextField('Price', themeColor, _priceController),
              SizedBox(height: 20.0),
              buildRoundedTextField('Size', themeColor, _sizeController),
              SizedBox(height: 20.0),
              buildRoundedTextField(
                  'Description', themeColor, _descriptionController),
              SizedBox(height: 20.0),
              buildShareButton(),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) {
      
      return;
    }
    setState(() {
      imagePath = imageFile.path;
    });

    // Add the image upload logic here
    final bytes = await File(imagePath!).readAsBytes();
    final fileExt = imagePath!.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    final filePath = 'item/$fileName'; // Adapt the path as needed

    // Inside the _upload method
    print('File Path: $filePath');
    print('File Name: $fileName');
    print('File Extension: $fileExt');

    // Upload the image to Supabase Storage
    await supabase.storage.from('item').uploadBinary(
          filePath,
          bytes,
          fileOptions: FileOptions(contentType: 'image/$fileExt'),
        );

    print('Upload Response:');

    // Get the signed URL for the uploaded image
    imageUrlResponse = await supabase.storage
        .from('item')
        .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10) ?? "https://jzredydxgjflzlgkamhn.supabase.co/storage/v1/object/sign/item/item/2024-01-26T21:31:17.285704.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpdGVtL2l0ZW0vMjAyNC0wMS0yNlQyMTozMToxNy4yODU3MDQucG5nIiwiaWF0IjoxNzA2MzAxMDgyLCJleHAiOjIwMjE2NjEwODJ9.Hqjnc2K1p73rVlYD1kqUr39t65g4c5fk9sGp5AzHAek";

    imageUrlResponse ??
        "https://jzredydxgjflzlgkamhn.supabase.co/storage/v1/object/sign/item/item/2024-01-26T21:31:17.285704.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpdGVtL2l0ZW0vMjAyNC0wMS0yNlQyMTozMToxNy4yODU3MDQucG5nIiwiaWF0IjoxNzA2MzAxMDgyLCJleHAiOjIwMjE2NjEwODJ9.Hqjnc2K1p73rVlYD1kqUr39t65g4c5fk9sGp5AzHAek";

    print('$imageUrlResponse');

    // Continue with the rest of your code, e.g., updating the UI or calling the onUpload callback

    setState(() {});
  }

  Widget buildRoundedTextField(
      String labelText, Color borderColor, TextEditingController controller) {
    return Container(
      width: 340.0,
      height: 60.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20.0,
              color: Colors.black.withOpacity(0.5),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

//WILAYA
  Widget WilayaBuildRoundedDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 340.0,
          height: 60.0,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            border: Border.all(color: Color.fromARGB(255, 154, 136, 132)),
          ),
          child: DropdownButtonFormField<int?>(
            value: selectedWilayaId ?? null,
            decoration: InputDecoration(
              labelText: selectedWilayaId == null ? 'Wilaya' : '',
              labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20.0,
                color: Colors.black.withOpacity(0.5),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              border: InputBorder.none,
            ),
            onChanged: (int? value) {
              setState(() {
                selectedWilayaId = value;
              });
              fetchCommunes(selectedWilayaId);
            },
            items: wilayas.map<DropdownMenuItem<int?>>((wilaya) {
              return DropdownMenuItem<int?>(
                value: wilaya['id_wilaya'] as int?,
                child: Text(wilaya['name'].toString()),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget CommuneBuildRoundedDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 340.0,
          height: 60.0,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            border: Border.all(color: Color.fromARGB(255, 154, 136, 132)),
          ),
          child: DropdownButtonFormField<int?>(
            value: selectedCommuneId ?? null,
            decoration: InputDecoration(
              labelText: selectedCommuneId == null ? 'Commune' : '',
              labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20.0,
                color: Colors.black.withOpacity(0.5),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              border: InputBorder.none,
            ),
            onChanged: (int? value) {
              setState(() {
                selectedCommuneId = value;
              });
            },
            items: communes.map<DropdownMenuItem<int?>>((commune) {
              return DropdownMenuItem<int?>(
                value: commune['id_commune'] as int?,
                child: Text(commune['name'].toString()),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget CategoryBuildRoundedDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 340.0,
          height: 60.0,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            border: Border.all(color: Color.fromARGB(255, 154, 136, 132)),
          ),
          child: DropdownButtonFormField<int?>(
            value: selectedCategoryId ?? null,
            decoration: InputDecoration(
              labelText: selectedCategoryId == null ? 'Category' : '',
              labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20.0,
                color: Colors.black.withOpacity(0.5),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              border: InputBorder.none,
            ),
            onChanged: (int? value) {
              setState(() {
                selectedCategoryId = value;
              });
            },
            items: categories.map<DropdownMenuItem<int?>>((category) {
              return DropdownMenuItem<int?>(
                value: category['id_category'] as int?,
                child: Text(category['name'].toString()),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget TypeBuildRoundedDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 340.0,
          height: 60.0,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            border: Border.all(color: Color.fromARGB(255, 154, 136, 132)),
          ),
          child: DropdownButtonFormField<int?>(
            value: selectedTypeId ?? null,
            decoration: InputDecoration(
              labelText: selectedTypeId == null ? 'Type' : '',
              labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20.0,
                color: Colors.black.withOpacity(0.5),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              border: InputBorder.none,
            ),
            onChanged: (int? value) {
              setState(() {
                selectedTypeId = value;
              });
            },
            items: types.map<DropdownMenuItem<int?>>((type) {
              return DropdownMenuItem<int?>(
                value: type['id_type'] as int?,
                child: Text(type['name'].toString()),
              );
            }).toList(),
          ),
        ),
      ],
    );
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
      print('wialaya id $wilayaId');
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

  Future<void> fetchCategory() async {
    try {
      print('fetch category');
      final response = await dio.get(
          '$api_endpoint_categories_get'); // Update this to your API endpoint
      print('fetch qfter category');
      if (response.statusCode == 200) {
        setState(() {
          // Update the types list with the fetched types
          categories =
              List<Map<String, dynamic>>.from(jsonDecode(response.data));
        });
      } else {
        print('Error fetching types: ${response.statusCode}');
      }
    } catch (error) {
      print('Dio error: $error');
    }
  }

  Widget buildShareButton() {
    return Container(
      width: 150,
      height: 60.0,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Color(0xFFAB8787)),
        color: Color(0xFFCBABA4),
      ),
      child: TextButton(
        onPressed: () async {
          // Show a confirmation dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Addition"),
                content: Text("Are you sure you want to add this item?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        _prefs = await SharedPreferences.getInstance();
                        _userId = _prefs.getString('user_id') ?? '';
                        print("before product");
                        print('Category: $selectedCategoryId');
                        print('Type: $selectedTypeId');
                        print('Wilaya: $selectedWilayaId');
                        print('Commune: $selectedCommuneId');
                        print('Size: ${_sizeController.text}');
                        print('Price: ${double.parse(_priceController.text)}');
                        print('Name: ${_productNameController.text}');
                        print('Image: $imageUrlResponse ');
                        print('Description: ${_descriptionController.text}');
                        print('id _user<<<<<<<<<<<');

                        print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<before insert');

                        final response = await dio.get(
                          '$api_endpoint_item_upload?name=${_productNameController.text}&id_category=$selectedCategoryId&id_type=$selectedTypeId&id_wilaya=$selectedWilayaId&size=${_sizeController.text}&'
                          'price=${double.parse(_priceController.text)}&id_user=$_userId&description=${_descriptionController.text}'
                          '&id_commune=$selectedCommuneId&image_path=$imageUrlResponse',
                        );
                        print("after insert");

                        Map<String, dynamic> ret_data =
                            jsonDecode(response.toString());
                        print('after json');

                        // Check the response status from the server
                        if (ret_data['status'] == 200) {
                          // The item was successfully inserted into the server's database
                          print('Item successfully inserted into the server.');
                        } else {
                          // Handle the case where the server returned an error
                          print('Server returned an error: ${response.data}');
                        }

                        // Navigate to the HomeScreen after adding the item
                        Navigator.of(context)
                            .pop(); // Close the confirmation dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } catch (error) {
                        showToast('Unexpected error occurred');
                        print('Error during item insertion: $error');
                      }
                    },
                    child: Text("Confirm"),
                  ),
                ],
              );
            },
          );
        },
        child: const Text(
          'Share',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.primaryFontFamily,
          ),
        ),
      ),
    );
  }
}
