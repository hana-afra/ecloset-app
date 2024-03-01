import 'package:ecloset/screens/login.dart';
import 'package:ecloset/screens/signup.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  final String message;

  Register({required this.message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(179, 133, 134, 1),
      appBar: AppBar(
        leading: CustomAppBarIcon(),
        backgroundColor: Color.fromRGBO(179, 133, 134, 1),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 200),
             Text(
              'Login required to $message in ',
              style: TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(245, 233, 231, 1),
              ),
            ),
            const Text(
              'ECLOSET',
              style: TextStyle(
                fontFamily: 'Birthstone',
                fontSize: 70,
                color: Color.fromRGBO(245, 233, 231, 1),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 120, // Adjust the width as needed
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Login()), // Replace NextScreen with your intended screen
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Color.fromRGBO(179, 133, 134, 1),
                  side: BorderSide(color: Colors.white),
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'LOG IN',
                  
                  style: TextStyle(color: Color.fromRGBO(179, 133, 134, 1)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 120, // Adjust the width as needed
              child: ElevatedButton(
                onPressed: () {
                  //SignupScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SignupScreen()), // Replace NextScreen with your intended screen
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(245, 233, 231, 1),
                  onPrimary: Color.fromRGBO(179, 133, 134, 1),
                  side: BorderSide(color: Color.fromRGBO(179, 133, 134, 1)),
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'SIGN UP',
                  style: TextStyle(color: Color.fromRGBO(179, 133, 134, 1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class CustomAppBarIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0), // Adjust the left padding as needed
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
           Navigator.pushReplacementNamed(context, '/home');
          },
          child:  Container(
            decoration: const BoxDecoration(
              color: Color(0xFFCBABA4),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
