import 'package:ecloset/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:ecloset/widgets/Button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecloset/screens/login.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              'Thank you for choosing ',
              style: GoogleFonts.montserratAlternates(
                  fontWeight: FontWeight.w400, fontSize: 25),
            ),
            SizedBox(height: 20),
            Text(
              'ECloset',
              style: GoogleFonts.birthstone(
                fontSize: 64,
              ),
            ),
            SizedBox(height: 100),
            Button(
              text: 'Login',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),

            SizedBox(height: 20),
            Text(
              '_____ OR ______',
              style: GoogleFonts.montserratAlternates(
                  fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30),
            Button(
              text: 'Sign up',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
            ), // Assuming Button widget takes text as parameter
          ],
        ),
      ),
    );
  }
}
