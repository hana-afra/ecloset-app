// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:ecloset/screens/login.dart';
import 'package:flutter/material.dart';

class ResetPwPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [

          //COLUMN 2 FOR DECORATION
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Image at the bottom left
              // Icon at the bottom left
              // Align widget to place the image at the bottom right
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  //padding: EdgeInsets.all(16),
                  child: Image.asset(
                    'lib/assets/images/decoSnake.png', // replace with your image path
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ],
          ),



          //1st column 

          Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Reset Password',
               style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xFFB38586),
                fontFamily: 'Montserrat',
                
              ),
            ),
            SizedBox(height: 70),


    

           Container(
              width: 326,
              height: 52,
              child: TextField(
                decoration: InputDecoration(
                  hintText: '',
                  labelText: 'New Password',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                    width: 1.0,
                    color: Color(0xFFB38586),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                    width: 1.0,
                    color: Color(0xFFCBABA4),
                    ),
                  ),
                ),
              ),
              
            ),
            SizedBox(height: 50),




            Container(
              width: 326,
              height: 52,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'l',
                  labelText: 'Confirm Password',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                    width: 1.0,
                    color: Color(0xFFB38586),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                    width: 1.0,
                    color: Color(0xFFCBABA4),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),



  ElevatedButton(
  onPressed: () {
     Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
  },
  style: ElevatedButton.styleFrom(
    primary: Color(0xFFD3A9A3), // Background color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40.0), // Border radius
      side: BorderSide(
        color: Color(0xFFB38586), // Border color
        width: 2.0, // Border width
      ),
    ),
    minimumSize: Size(155, 55), // Width and height
  ),
  child: Text(
    'Update Password',
    style: TextStyle(
      color: Colors.white,
      fontSize: 15.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    ),
  ),
),

          ],
        ),
      ),



      //COLUMN 2 FOR DECORATION
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Image at the bottom left
              // Icon at the bottom left
              // Align widget to place the image at the bottom right
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  //padding: EdgeInsets.all(16),
                  child: Image.asset(
                    'lib/assets/images/decoSnake.png', // replace with your image path
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            ],
          )


        ],
      )
      
    );
  }

  Widget buildCodeBox() {
    return Container(
      
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Color(0xFFF2E9E8),
        border: Border.all(width: 1, color: Color(0xFFCBABA4)),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
