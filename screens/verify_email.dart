import 'package:ecloset/screens/reset_pw.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signup.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  List<TextEditingController> codeControllers =
      List.generate(6, (index) => TextEditingController());
  late SharedPreferences _prefs;
  late String userEmail; // Nullable, as we're not sure if the user is logged in yet

  

  @override
  void initState() {
    
    super.initState();
    _loadUserData();
   // getCurrentUserEmail(); // Move the call to getCurrentUserEmail here if needed immediately on screen load
  }

  Future<void> _loadUserData() async {
  _prefs = await SharedPreferences.getInstance();
  if (_prefs != null) {
    setState(() {
      _emailController.text = _prefs.getString('user_email') ?? '';
      print(_emailController.text);
    });
  }
}

  TextEditingController _emailController = TextEditingController();

  // Future<void> getCurrentUserEmail() async {
  //   // Get the current user from Supabase
  // final user = supabase.auth.currentUser;
  //   if (user != null && user.email != null) {
  //     setState(() {
  //       userEmail = user.email!;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Verify Your Email',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFB38586),
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 70),
                  const Text(
                    'A verification code has been sent to',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                     _emailController.text,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFDCBBB3),
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Please check your inbox and enter the\nverification code below to verify\nyour email address ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0x99000000),
                      fontFamily: 'Montserrat',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                      (index) => buildCodeBox(index),
                    ),
                  ),
                  const SizedBox(height: 40),
ElevatedButton(
  onPressed: () async {
    String enteredCode = codeControllers.map((controller) => controller.text).join();
    bool isCodeCorrect = await verifyOtp(useremail: _emailController.text , otp: enteredCode);

    if (isCodeCorrect) {
      // Code is correct, proceed with further actions
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResetPwPage()),
      );
    } else {
      // Code is incorrect, show a toast notification
      Fluttertoast.showToast(
        msg: 'Incorrect verification code. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        textColor: const Color.fromARGB(255, 0, 0, 0),
        fontSize: 16.0,
      );
    }
  },
  style: ElevatedButton.styleFrom(
    primary: const Color(0xFFD3A9A3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40.0),
      side: const BorderSide(
        color: Color(0xFFB38586),
        width: 2.0,
      ),
    ),
    minimumSize: const Size(155, 55),
  ),
  child: const Text(
    'Verify',
    style: TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    ),
  ),
)
,
                  const SizedBox(height: 60),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Resend Code',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      SizedBox(width: 100),
                      Text(
                        'Change email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    child: Image.asset(
                      'lib/assets/images/decoSnake.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCodeBox(int index) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF2E9E8),
        border: Border.all(width: 1, color: const Color(0xFFCBABA4)),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: codeControllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
      ),
    );
  }

//   Future<void> verifyOtp({required String useremail, required String otp}) async {
//     await supabase.auth.verifyOTP(
//       email: useremail,
//       token: otp,
//       //type: Auth.confirmSignup,
//        type: OtpType.signup,
//     );
//   }
}
Future<bool> verifyOtp({required String useremail, required String otp}) async {
  try {
    // Call Supabase's OTP verification endpoint
    await supabase.auth.verifyOTP(
      email: useremail,
      token: otp,
      type: OtpType.signup, // Replace with the appropriate type
    );

    // If the verification is successful, return true
    return true;
  } catch (error) {
    // If there is an error during verification, return false
    return false;
  }
}

