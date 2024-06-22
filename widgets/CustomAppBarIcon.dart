import 'package:flutter/material.dart';

class CustomAppBarIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0), // Adjust the left padding as needed
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child:  Container(
            decoration: BoxDecoration(
              color: Color(0xFFCBABA4),
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
