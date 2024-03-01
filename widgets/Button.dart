import 'package:ecloset/screens/signup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ecloset/theme/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const Button({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 188,
      height: 63,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
              side: BorderSide(
                color: AppColors.primaryColor, // Border color
                width: 2.0,
              ),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            AppColors.secondaryColor, // Button background color
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}


class InputButton extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final TextEditingController controller; // Accepts TextEditingController

  const InputButton({
    Key? key,
    required this.hintText,
    this.icon,
    required this.controller, // Includes TextEditingController in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late FocusNode _focusNode = FocusNode();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Container(
        width: 326,
        height: 49,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          border: Border.all(
            color: AppColors.primaryColor,
            width: 1.0,
          ),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller, // Use the passed controller
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(_focusNode);
                },
              ),
            ),
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  icon,
                  color: Colors.black26,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SocialLoginButtons extends StatelessWidget {
  final IconData googleIcon;
  final IconData facebookIcon;
  final IconData cloudIcon;

  const SocialLoginButtons({
    Key? key,
    required this.googleIcon,
    required this.facebookIcon,
    required this.cloudIcon,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCircleButton(context, googleIcon, () => _onGooglePressed(context)),
        _buildCircleButton(context, facebookIcon, () => _onFacebookPressed(context)),
        _buildCircleButton(context, Icons.apple, _onApplePressed),
      ],
    );
  }

  Widget _buildCircleButton(BuildContext context, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 62,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: Color.fromRGBO(231, 212, 203, 1.0),
        ),
        icon: Icon(
          icon,
          color: Colors.black,
          size: 25,
        ),
        label: SizedBox.shrink(),
      ),
    );
  }

  void _onGooglePressed(BuildContext context) async {
    try {
      await supabase.auth.signInWithOAuth(
        Provider.google,
      redirectTo: kIsWeb ? null : '/welcome',
      );

      // Handle successful authentication - e.g., navigate to home screen
      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      print('Error signing in with Google: $error');
      // Handle error - e.g., show error message to the user
    }
  }

  void _onFacebookPressed(BuildContext context) async {
    try {
      await supabase.auth.signInWithOAuth(
        Provider.facebook,
  redirectTo: kIsWeb ? null : '/welcome',
      );

      // Handle successful authentication - e.g., navigate to home screen
      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      print('Error signing in with Facebook: $error');
      // Handle error - e.g., show error message to the user
    }
  }

  void _onApplePressed() {
    // Implement Apple login logic
    print('Apple button pressed!');
  }
}
    


class IconLabel extends StatelessWidget {

  final IconData iconImage;
  const IconLabel({super.key, required this.iconImage});

  @override
  Widget build(BuildContext context) {
    return FaIcon(iconImage);
  }
}



class ButtonP extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const ButtonP({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 89,
      height: 39,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
              side: BorderSide(
                color: AppColors.primaryColor, // Border color
                width: 2.0,
              ),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            AppColors.secondaryColor, // Button background color
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.zero,
          ),
          alignment: Alignment.center, // Center aligns text within button
        ),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
