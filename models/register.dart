import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class User {
  final String username;
  final String password;

  User({required this.username, required this.password});
}

List<User> users = [];

void signUp(String username, String password) {
  users.add(User(username: username, password: password));
}

bool login(String username, String password) {
  for (var user in users) {
    if (user.username == username && user.password == password) {
      return true; // Login successful
    }
  }
  return false; // Login failed
}