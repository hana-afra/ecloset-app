import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecloset/constants/endpoints.dart';
import 'package:ecloset/screens/login.dart';
import 'package:ecloset/theme/theme.dart';
import 'package:ecloset/widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


final dio=Dio();
final supabase = Supabase.instance.client;
class SignupScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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

  Future<String> signupUser() async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  String email = emailController.text;
  String password = passwordController.text;
  String name = nameController.text;
  String phone = phoneController.text;
  print(email);
  print(name);
  print(phone);
  print(password);
  


  try {
      final response = await dio.get(
        '$api_endpoint_user_sign?name=$name&email=${Uri.encodeComponent(email.trim())}&phone=$phone&password=$password',
      );
      
    print("Response: ${response..toString()}");

    Map<String, dynamic> ret_data = jsonDecode(response.toString());

if (ret_data['status'] == 200) {
  dynamic userData = ret_data['data'];

  if (userData is List) {
    // Assuming the first element in the list is the user data
    if (userData.isNotEmpty && userData[0] is Map<String, dynamic>) {
      userData = userData[0];
    }
  }

  if (userData is Map<String, dynamic>) {
    // Access the user data from the map
    print(userData);
    
    if (prefs != null) {
      prefs.setString("user_id", "${userData['user_id']}");
      prefs.setString("user_name", userData['name']);
      prefs.setString("user_email", userData['email']);
      prefs.setString("user_phone", userData['phone']);
      prefs.setString("user_password", userData['password']);
    }
    
    print("success");
    return 'success';
  } else {
    print("fail");
    return 'Error: Unexpected user data format';
  }
} else {
  showToast(ret_data['message']);
  print("fail");
  String error_msg = ret_data['message'] ?? 'Unknown error';
  return 'Error: $error_msg';
}

  } catch (e) {
    return 'Error: ${e.toString()}';
  }
}

  

  @override
  Widget build(BuildContext context) {
    void onPressedSignUp() async {
      String signupResult = await signupUser();

      if (signupResult == 'success') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        // Handle signup failure
        print('Signup failed: $signupResult');
        // Display an error message or perform other actions accordingly
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
                'Welcome!',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                  fontSize: 34,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Let\'s get you started!',
                style: GoogleFonts.montserratAlternates(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
                          const SizedBox(height: 40),
              InputButton(
                hintText: 'Name',
                controller: nameController,
              ),
              const SizedBox(height: 20),
              InputButton(
                hintText: 'Email Address',
                controller: emailController,
              ),
              const SizedBox(height: 20),
              InputButton(
                hintText: 'Password',
                icon: Icons.lock,
                controller: passwordController,
                //obscureText: true,
              ),
              const SizedBox(height: 20),
              InputButton(
                hintText: 'Phone number',
                controller: phoneController,
              ),
              
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (value) {
                            value = true;
                          },
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'By joining i agree to the terms ',
                          style: GoogleFonts.montserratAlternates(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ), // ... Radio button and 'Remember me' and 'Forgot password' texts
                ],
              ),
              const SizedBox(height: 20),
              Button(text: 'Sign Up', onPressed: onPressedSignUp),
              const SizedBox(height: 20),
              const SocialLoginButtons(
                googleIcon: FontAwesomeIcons.google,
                facebookIcon: FontAwesomeIcons.facebook,
                cloudIcon: FontAwesomeIcons.cloud,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                  onTap: () {
            // Call the login function when the text is tapped
            Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
          },
                    child: Text(
                      'Log In',
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