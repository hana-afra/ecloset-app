import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecloset/theme/theme.dart';
import 'package:ecloset/widgets/buttom_navbar.dart';
import 'package:ecloset/widgets/CustomAppBarIcon.dart';
import 'package:ecloset/tabs/profileitems.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyItemsPage extends StatefulWidget {
  @override
  State<MyItemsPage> createState() => _MyItemsPageState();
}

class _MyItemsPageState extends State<MyItemsPage> {
  late SharedPreferences _prefs;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _prefs = await SharedPreferences.getInstance();

    setState(() {
      _userId = _prefs.getString('user_id') ?? '';
    });
  print(_userId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.grey[50],
            elevation: 0,
            leading: CustomAppBarIcon(),
            pinned: true,
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 8, bottom: 10),
              title: Text(
                'My Items',
                style: GoogleFonts.birthstone(
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryColor,
                  fontSize: 40,
                ),
              ),
              centerTitle: true,
            ),
          ),
           SliverToBoxAdapter(
            child: ProfileItem(id: _userId), // Display the ProfileItem widget here
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(), // Add the BottomNavBar here
    );
  }
}
