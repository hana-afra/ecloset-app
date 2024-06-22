import 'dart:convert';
import 'package:ecloset/constants/endpoints.dart';
import 'package:ecloset/screens/home.dart';
import 'package:ecloset/screens/signup.dart';
import 'package:ecloset/theme/theme.dart';
import 'package:ecloset/widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<String> loginUser() async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  String email = emailController.text;
  String password = passwordController.text;
  final encodedEmail = Uri.encodeFull(email.trim());
  final encodedPassword = Uri.encodeFull(password.trim());

  print(email);
  print(password);

  try {
//     final url = '$api_endpoint_user_login?email=$encodedEmail&password=$encodedPassword';
// print('Request URL: $url');

// final response = await dio.get(url);
    final response = await dio.get(
      '$api_endpoint_user_login?email=$encodedEmail&password=$encodedPassword',
    );
    
    print(response.data);

    Map<String, dynamic> ret_data = jsonDecode(response.toString());

    if (ret_data['status'] == 200) {
      print("in");
      dynamic userData = ret_data['data'];
      print(ret_data['data']);
      
      if (userData != null && userData is List<dynamic> && userData.isNotEmpty) {
        // Assuming the first element in the list is the user data
        Map<String, dynamic> userMap = userData[0];

        prefs.setString("user_id", "${userMap['id_user']}");
        prefs.setString("user_name", userMap['name']);
        prefs.setString("user_email", userMap['email']);
        prefs.setString("user_phone", userMap['phone']);
        prefs.setString("user_password", userMap['password']);

        print("success");
        return 'success';
      } else {
        return 'Error: Unexpected user data format';
      }
    } else {
      print("fail");
      showToast(ret_data['message']);
      String error_msg = ret_data['message'] ?? 'Unknown error';
      return 'Error: $error_msg';
    }
  } catch (e) {
    return 'Error: ${e.toString()}';
  }
}



  

  @override
  Widget build(BuildContext context) {
    void onPressed() async {
    String loginResult = await loginUser();

    if (loginResult == 'success') {
      // Navigate to the next screen upon successful login
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Replace NextScreen with your intended screen
      );
    } else {
      // Display an error message
      print('Login failed: $loginResult');
      // Perform other actions based on login failure
    }
  }
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 0),
              Text(
                'Welcome Back!',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                  fontSize: 34,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Yay! You are Back!',
                style: GoogleFonts.montserratAlternates(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 60),
              InputButton(
                hintText: 'Email Address',
                controller: emailController,
              ),
              const SizedBox(height: 30),
              InputButton(
                hintText: 'Password',
                icon: Icons.lock,
                controller: passwordController,
              ),
              const SizedBox(height: 20),
              Button(text: 'Login', onPressed: () => onPressed()),
              const SizedBox(height: 20),
              const SocialLoginButtons(
                googleIcon: FontAwesomeIcons.google,
                facebookIcon: FontAwesomeIcons.facebook,
                cloudIcon: FontAwesomeIcons.cloud,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not registered yet?',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text(
                      'Create an account',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    textColor: const Color.fromARGB(255, 0, 0, 0),
    fontSize: 16.0,
  );
}