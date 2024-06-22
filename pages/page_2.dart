import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding (
        padding:  const EdgeInsets.symmetric(horizontal: 20.0).copyWith(top: 10),
        child: ClipRRect (
          borderRadius: BorderRadius.circular(40),
          child: Container(
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/promo-banner-10.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
        )
    );
  }
}