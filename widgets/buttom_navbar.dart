// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors 
 
import 'package:ecloset/screens/register.dart';
import 'package:flutter/material.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
 
class BottomNavBar extends StatefulWidget { 
  @override 
  State<BottomNavBar> createState() => _BottomNavBarState(); 
} 
 
class _BottomNavBarState extends State<BottomNavBar> { 
  late int selectedIndex; 
  //it will be initialized later 
 
  @override 
  Widget build(BuildContext context) { 
    // Initialize selectedIndex based on the current route 
    //retrieves the current route from the widget tree. 
    //?.settings.name accesses the name property of the settings object associated with the route. 
    selectedIndex = getCurrentIndex(ModalRoute.of(context)?.settings.name ?? '/home'); 
 
    return Container( 
      width: MediaQuery.of(context).size.width, 
      //sets the width of the container to the width of the current screen, ensuring that the container takes up the full width of the screen 
      height: 60.0, 
      decoration: BoxDecoration( 
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)), 
        color: Colors.white, 
        boxShadow: [ 
          BoxShadow( 
            color: Colors.grey.withOpacity(0.5), 
            spreadRadius: 2, 
            blurRadius: 5, 
            offset: Offset(0, 2), 
          ), 
        ], 
        border: Border.all( 
          color: Color(0xFFD3A9A3), 
          width: 1.2, 
        ), 
      ), 
      child: Row( 
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
        children: [ 
          buildNavItem(0, 'lib/assets/icons/home.png', '/home'), 
          buildNavItem(1, Icons.search, '/search'), 
          buildNavItem(2, Icons.add_circle_outline_rounded, '/plus'), 
          buildNavItem(3, Icons.favorite, '/favorite'), 
          buildNavItem(4, Icons.person, '/profile'), 
        ], 
      ), 
    ); 
  } 
 //Dynamic hold values of any type 
  Widget buildNavItem(int index, dynamic icon, String route) { 
    //value based on the comparison 
    bool isSelected = selectedIndex == index; 
 
    return GestureDetector( 
      onTap: () async {
        if (index == 2) {
          String message = "Add a new item on sale";
          // Check if the user is logged in
          bool isLoggedIn = await checkLoggedIn(); // Replace with your actual function
          if (isLoggedIn) {
            setState(() {
              selectedIndex = index;
              Navigator.pushReplacementNamed(context, route);
            });
          } else {
            Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Register(message: message)),
        );
          }
        } else if (index == 4) {
          String message = "View Profile";
          // Check if the user is logged in
          bool isLoggedIn = await checkLoggedIn(); // Replace with your actual function
          if (isLoggedIn) {
            setState(() {
              selectedIndex = index;
              Navigator.pushReplacementNamed(context, route);
            });
          } else {
            Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Register(message: message)),
        );
          }
        } else {
          setState(() {
            selectedIndex = index;
            Navigator.pushReplacementNamed(context, route);
          });
        }
      },
      child: Container( 
        child: buildIcon(index, icon, isSelected), 
      ), 
    ); 
  } 
 
  Widget buildIcon(int index, dynamic icon, bool isSelected) { 
    if (icon is IconData) { 
      return Icon( 
        icon, 
        color: isSelected ? Color(0xFFB38586): const Color(0xFFE7D4CB), 
        size: index == 2 ? 43 : 30, 
      ); 
    } else if (icon is String) { 
      return Image.asset( 
        icon, 
        width: index == 2 ? 43 : 30, 
        height: index == 2 ? 43 : 30, 
        color: isSelected ? Color(0xFFB38586) : const Color(0xFFE7D4CB), 
      ); 
    } else { 
      // Handle other cases or provide a default widget 
      return Container(); 
    } 
  } 
  // Function to check if the user is logged in
  Future<bool> checkLoggedIn() async {
    // Replace this with your actual logic to check if the user is logged in
    // You might use SharedPreferences or any other authentication mechanism
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_id');
  }
 
  // Function to get the current index based on the route 
  int getCurrentIndex(String? route) { 
    switch (route) { 
      case '/home': 
        return 0; 
      case '/search': 
        return 1; 
      case '/plus': 
        return 2; 
      case '/favorite': 
        return 3; 
      case '/profile': 
        return 4; 
      default: 
        return 0; // Default to home if route is not recognized 
    } 
  } 
}