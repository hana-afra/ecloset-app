import 'package:ecloset/constants/endpoints.dart';
import 'package:ecloset/models/product.dart';
import 'package:ecloset/screens/profile.dart';
import 'package:ecloset/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SellingItemPage extends StatefulWidget {
  final Product product;
  const SellingItemPage({super.key, required this.product});
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<SellingItemPage> {
  Future<void> _removeItem() async {
    try {
      print("id_user=${widget.product.ownerId}");
      print("id_item=${widget.product.Id}");
    // Remove item sellig items and update the UI
    // Construct the URL
    String url = '$api_endpoint_selling_item_remove?id_user=${widget.product.ownerId}&id_item=${widget.product.Id}';

    // Print the URL
    print('Request URL: $url');

    // Remove item selling items and update the UI
    final response = await dio.get(url);
      // Check the response status
      if (response.statusCode == 200) {
        print("sucess");
        // Item removed successfully, show a toast
        Fluttertoast.showToast(
          msg: 'Item removed successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xFFB38586),
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // You can add additional logic here if needed
      } else {
         print("sucess");
        // Handle other status codes or errors
        print('Error removing item from selling list. Status code: ${response.statusCode}');
      }
  } catch (error) {
    print('Error removing item from selling list: $error');
    // Handle the error as needed
    }
  }

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
                    placeholder: const NetworkImage(
                        "https://jzredydxgjflzlgkamhn.supabase.co/storage/v1/object/sign/item/item/2024-01-26T21:31:17.285704.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpdGVtL2l0ZW0vMjAyNC0wMS0yNlQyMTozMToxNy4yODU3MDQucG5nIiwiaWF0IjoxNzA2MzAxMDgyLCJleHAiOjIwMjE2NjEwODJ9.Hqjnc2K1p73rVlYD1kqUr39t65g4c5fk9sGp5AzHAek"),
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
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFCBABA4).withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final RenderBox overlay = Overlay.of(context)!
                              .context
                              .findRenderObject() as RenderBox;
                          final RelativeRect position =
                              RelativeRect.fromLTRB(180, 0, 0, 0);

                          // Open the dropdown menu when the three dots are tapped
                          String? value = await showMenu<String>(
                            context: context,
                            position: position,
                            items: <PopupMenuEntry<String>>[
                              // Specify the type explicitly
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Edit'),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'remove',
                                child: ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Remove'),
                                ),
                              ),
                            ],
                          );

                          // Handle the selected option
                          if (value == 'edit') {
                          } else if (value == 'remove') {
                            bool confirmRemove =
                                await showDeleteConfirmationDialog(context);
                            if (confirmRemove) {
                              // User confirmed removal
                              await _removeItem();
                              Navigator.of(context)
                                  .pop(); // Close the page after removal
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFCBABA4).withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 460),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfilePage(product: widget.product)),
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
                              image: NetworkImage(
                                  widget.product.ownerProfilePicture),
                              fit: BoxFit.cover,
                              placeholder: const NetworkImage(
                                  "https://jzredydxgjflzlgkamhn.supabase.co/storage/v1/object/sign/item/item/2024-01-26T21:30:55.587640.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpdGVtL2l0ZW0vMjAyNC0wMS0yNlQyMTozMDo1NS41ODc2NDAuanBnIiwiaWF0IjoxNzA2MzAxMDU5LCJleHAiOjIwMjE2NjEwNTl9.EQ8qCe_8uC6EGsNxzptM88Cy8xCKtzg6d0VIeO-aEj4"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.ownerName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            Text(
                              widget.product.wilaya,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12), // Add padding to the top
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
                  const SizedBox(height: 10),
                  const Positioned(
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
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 100),
                            Text(
                              widget.product.price.toString(),
                              style: const TextStyle(
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
                            const Text(
                              "Size",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 240),
                            Text(
                              widget.product.size,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFFAB8787), width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            widget.product.description,
                            style: const TextStyle(
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

// Function to show the delete confirmation dialog
// Function to show the delete confirmation dialog
Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Item'),
            content: Text('Are you sure you want to delete this item?'),
            actions: [
              TextButton(
                onPressed: () {
                  // User pressed Cancel, close the dialog
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // User pressed Delete, close the dialog and return true
                  Navigator.of(context).pop(true);
                },
                child: Text('Delete'),
              ),
            ],
          );
        },
      ) ??
      false; // Return false if the dialog is dismissed without pressing any button
}
