// import 'package:ecloset/screens/verify_email.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class CheckEmail extends StatelessWidget {
//   const CheckEmail({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           //COLUMN 2 FOR DECORATION
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 // Image at the bottom left
//                 // Icon at the bottom left
//                 // Align widget to place the image at the bottom right
//                 Align(
//                   alignment: Alignment.topRight,
//                   child:  Container(
//                     //padding: EdgeInsets.all(16),
//                     child: Image.asset(
//                       'lib/assets/images/decoBubbles.png', // replace with your image path
//                       width: 150,
//                       height: 150,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//               Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                    const Text(
//                     'Check your email \nfor reset email',
//                     style: TextStyle(
//                       fontSize: 25,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFFB38586),
//                       fontFamily: 'Montserrat',
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 33),

//                   const Text(
//                   'An email has been sent to you',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontFamily: 'Montserrat',
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 20),

                
//                 const Text(
//                   'douaa.djaid@gmail.com',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Color(0xFFDCBBB3),
//                     fontFamily: 'Montserrat',
//                   ),
//                 ),

//                 const SizedBox(height: 30),
//                 const Text(
//                   "click the reset link provided.If you\ndon't find it please check \n the spam",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Color(0x99000000),
//                     fontFamily: 'Montserrat',
//                   ),
//                   textAlign: TextAlign.center,
//                 ),

//                   const SizedBox(height: 40),

// ElevatedButton(
//   onPressed: () async {
//     // Check if the email app is installed
//     if (await canLaunchUrl('mailto:')) {
//       // Launch the email app
//       await launchUrl('mailto:${userEmail ?? _emailController.text}');
//     } else {
//       // Email app is not installed, open default email in web browser
//       await launchUrl('https://mail.google.com/mail/?view=cm&fs=1&to=${userEmail ?? _emailController.text}');
//     }
//   },
//   style: ElevatedButton.styleFrom(
//     primary: const Color(0xFFD3A9A3),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(40.0),
//       side: const BorderSide(
//         color: Color(0xFFB38586),
//         width: 2.0,
//       ),
//     ),
//     minimumSize: const Size(155, 55),
//   ),
//   child: const Text(
//     'Open Email App',
//     style: TextStyle(
//       color: Colors.white,
//       fontSize: 15.0,
//       fontWeight: FontWeight.bold,
//       fontFamily: 'Montserrat',
//     ),
//   ),
// ),
// const SizedBox(height: 40),

//                   const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   //crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text(
//                       'Resend Code',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                         fontFamily: 'Montserrat',
//                       ),
//                     ),
//                     SizedBox(width: 100),
//                     Text(
//                       'Change email',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                         fontFamily: 'Montserrat',
//                       ),
//                     ),
//                   ],
//                 ),

//                   const SizedBox(height: 40),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     //crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text(
//                         'return to',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                           fontFamily: 'Montserrat',
//                         ),
//                       ),
//                       SizedBox(width: 5),
//                       Text(
//                         'Sign up',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                           fontFamily: 'Montserrat',
//                           color: Color(0xFFDCBBB3),
//                         ),
//                       ),
//                     ],
//                   ),

//                   // Image at the bottom left
//                   // Icon at the bottom left
//                 ],
//               ),
//             ),
//         ],
//       )
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckEmail extends StatefulWidget {
  const CheckEmail({Key? key}) : super(key: key);

  @override
  _CheckEmailState createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
  late String userEmail; // Nullable, as we're not sure if the user is logged in yet
   late SharedPreferences _prefs;

  

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

  Future<void> getCurrentUserEmail() async {
    // Get the current user from Supabase
    // TODO: Replace the following line with your actual method to get the user email
    // final user = supabase.auth.currentUser;
    final user = null; // Replace this with the actual user retrieval logic
    if (user != null && user.email != null) {
      setState(() {
        userEmail = user.email!;
      });
    }
  }

 void _launchEmail() async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'recipient@example.com', // Replace with the recipient email addres
    );

    // ignore: deprecated_member_use
    if (await canLaunch(_emailLaunchUri.toString())) {
      // ignore: deprecated_member_use
      await launch(_emailLaunchUri.toString());
    } else {
      throw 'Could not launch email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  child: Image.asset(
                    'lib/assets/images/decoBubbles.png',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Check your email \nfor reset email',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFB38586),
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 33),
                const Text(
                  'An email has been sent to you',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                 Text(
                     userEmail,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFDCBBB3),
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "click the reset link provided. If you\n"
                  "don't find it please check \n the spam",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0x99000000),
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _launchEmail,
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
                    'Open Email App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                const SizedBox(height: 40),
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
                const SizedBox(height: 40),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'return to',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Sign up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        color: Color(0xFFDCBBB3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
